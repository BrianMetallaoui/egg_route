# Flutter Foundation Guide

A practical "do it this way from day one" reference for new Flutter projects. Based on patterns proven across two production apps (a budgeting app and a puzzle game).

---

## Folder Structure

```
lib/
├── main.dart                    # Entry point: init DB, pre-load, set up error handlers, runApp
├── app.dart                     # Root MaterialApp widget, theme configuration
├── router.dart                  # GoRouter route definitions
├── core/
│   ├── constants.dart           # App-wide constants (colors, padding, fonts)
│   └── utils/                   # Pure utility functions (formatting, math, etc.)
├── data/
│   ├── database/
│   │   ├── database.dart        # @DriftDatabase class, migration strategy
│   │   ├── tables.dart          # Drift table definitions
│   │   └── connection.dart      # Platform-specific SQLite connection factory
│   ├── models/                  # Domain model classes
│   └── repositories/            # One repository per entity, maps DB rows → domain models
├── features/
│   └── {feature_name}/
│       ├── {feature}_page.dart        # Screen-level widget
│       ├── {feature}_provider.dart    # Feature-scoped provider (if needed)
│       └── widgets/                   # Feature-specific widgets (if needed)
├── providers/
│   ├── database_providers.dart  # databaseProvider + initial data providers
│   ├── notifier_helpers.dart    # DbCallMixin
│   └── {entity}_provider.dart   # App-wide notifiers and derived providers
├── services/
│   └── {purpose}_service.dart   # Business logic that doesn't fit in providers or repositories
└── widgets/
    └── {widget_name}.dart       # Reusable widgets shared across features
```

**Rules of thumb:**
- `features/` is the UI layer — pages and their directly supporting code. If a provider only serves one feature, it lives in that feature folder.
- `providers/` holds app-wide state that multiple features consume.
- `data/` owns all persistence. Nothing outside `data/` touches Drift tables directly.
- `services/` holds stateless business logic (error logging, import/export, content loading). Services don't hold state — they do work and return results.
- `widgets/` holds reusable UI components used by two or more features.

---

## App Entry Point

Every app should follow this initialization sequence in `main.dart`:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Create database
  final db = AppDatabase(openConnection());

  // 2. Initialize services
  await ErrorLogService.init(db);

  // 3. Pre-load data needed for first frame
  final settings = await db.settingsRepo.getSettings();
  // ... other pre-loads as needed

  // 4. Set up global error handlers
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    ErrorLogService.logError(db, details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    ErrorLogService.logError(db, error, stack);
    return true;
  };

  // 5. Launch app with pre-loaded data
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        initialSettingsProvider.overrideWithValue(settings),
      ],
      child: const MainApp(),
    ),
  );
}
```

**Why pre-load:** This gives you an instant first frame with real data — no loading spinners, no async gaps. The `initialXxxProvider` values bootstrap the notifiers synchronously. Streams or subsequent reads take over after the first frame.

---

## State Management — Riverpod

Use `flutter_riverpod` with the `Notifier` pattern.

### Provider Types and When to Use Them

| Type | Use When |
|------|----------|
| `NotifierProvider<N, T>` | Core mutable state (entities, settings, game state) |
| `Provider<T>` | Derived/computed values, singleton services |
| `Provider.family<T, A>` | Parameterized lookups (e.g., entity by ID) |

### Core Notifier Template

```dart
class EntityNotifier extends Notifier<List<Entity>> with DbCallMixin {
  @override
  List<Entity> build() {
    // Option A: Pre-load + stream (for data that changes from multiple sources)
    final db = ref.watch(databaseProvider);
    final sub = db.entityRepo.watchAll().listen(
      (data) => state = data,
      onError: (Object e, StackTrace st) => ErrorLogService.logError(db, e, st),
    );
    ref.onDispose(sub.cancel);
    return List.from(ref.read(initialEntitiesProvider));

    // Option B: Pre-load + direct mutation (for state changed only by this notifier)
    // return ref.read(initialEntitiesProvider);
  }

  Future<void> add(Entity entity) async {
    await dbCall((db) => db.entityRepo.insert(entity));
    // If using Option B, also update state directly:
    // state = [...state, entity];
  }
}

final entityProvider =
    NotifierProvider<EntityNotifier, List<Entity>>(EntityNotifier.new);
```

**Choose Option A** when data can change from outside the notifier (imports, background sync, other notifiers). The stream ensures all sources of truth converge.

**Choose Option B** when only this notifier modifies the data (game state, UI-only state). Direct mutation is simpler.

### Derived Providers

```dart
// Computed value from existing state
final totalProvider = Provider<double>((ref) {
  final items = ref.watch(entityProvider);
  return items.fold(0.0, (sum, e) => sum + e.amount);
});

// Parameterized lookup
final entityByIdProvider = Provider.family<Entity?, String>((ref, id) {
  final entities = ref.watch(entityProvider);
  return entities.where((e) => e.id == id).firstOrNull;
});
```

### Feature-Level Providers

For state that only one feature needs (filter/sort configs, selection state), put the provider file in the feature folder:

```dart
// features/some_feature/some_feature_provider.dart
class FeatureConfigNotifier extends Notifier<FeatureConfig> {
  @override
  FeatureConfig build() => FeatureConfig();

  void updateFilter(String filter) => state = state.copyWith(filter: filter);
}
```

### Database Provider Setup

```dart
// providers/database_providers.dart
final databaseProvider = Provider<AppDatabase>((ref) => throw UnimplementedError());
final initialSettingsProvider = Provider<SettingsState>((ref) => throw UnimplementedError());
// Add one per entity type you pre-load
```

These throw by default and are overridden at startup. This makes it impossible to accidentally use them without initialization.

---

## Error Handling

### DbCallMixin

Every notifier that touches the database should use this mixin:

```dart
// providers/notifier_helpers.dart
mixin DbCallMixin<T> on Notifier<T> {
  Future<R> dbCall<R>(Future<R> Function(AppDatabase db) fn) async {
    final db = ref.read(databaseProvider);
    try {
      return await fn(db);
    } catch (e, st) {
      await ErrorLogService.logError(db, e, st);
      rethrow;
    }
  }
}
```

Usage:

```dart
Future<void> delete(String id) async {
  await dbCall((db) => db.entityRepo.delete(id));
}
```

### ErrorLogService

A static service that captures errors to the database for later debugging:

```dart
// services/error_log_service.dart
class ErrorLogService {
  static String _currentRoute = '';
  static String _appVersion = '';

  static Future<void> init(AppDatabase db) async {
    _appVersion = /* read from package_info */;
    await db.errorLogRepo.cleanupOldLogs(); // Purge entries > 300 days
  }

  static void setCurrentRoute(String route) => _currentRoute = route;

  static Future<void> logError(AppDatabase db, Object error, StackTrace? stack) async {
    await db.errorLogRepo.insertLog(
      errorMessage: error.toString(),
      stackTrace: stack?.toString() ?? '',
      appVersion: _appVersion,
      currentRoute: _currentRoute,
      platform: Platform.operatingSystem,
    );
  }
}
```

Include a developer page in settings that lets you view and export these logs. It's invaluable for debugging issues users report.

### Error Handling Strategy

- **Global handlers** (`FlutterError.onError`, `PlatformDispatcher.instance.onError`) catch everything.
- **DbCallMixin** logs and rethrows database errors so callers can optionally show UI feedback.
- **Stream error handlers** log errors on reactive subscriptions without crashing the app.
- **Don't swallow errors silently.** Log everything, rethrow where appropriate.

---

## Navigation — GoRouter

```dart
// router.dart
GoRouter buildRouter() => GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    ErrorLogService.setCurrentRoute(state.matchedLocation);
    return null; // No actual redirect — just tracking the current route for error context
  },
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomePage()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
    GoRoute(path: '/settings/dev', builder: (_, __) => const DevPage()),
    GoRoute(
      path: '/entity/:id',
      builder: (_, state) => EntityPage(id: state.pathParameters['id']!),
    ),
  ],
);
```

**Conventions:**
- Use `context.push('/path')` to navigate, `context.pop()` to go back.
- Use path parameters (`/:id`) for entity-specific routes.
- Use query parameters (`?filter=true`) for optional modifiers.
- No named routes — path strings are simpler and more debuggable.
- If your app needs persistent tabs, use `StatefulShellRoute.indexedStack`.
- Track the current route in `redirect` for error log context.

Dispose the router in `MainApp`:

```dart
// app.dart
class MainApp extends StatefulWidget { ... }
class _MainAppState extends State<MainApp> {
  late final GoRouter _router = buildRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router, ...);
  }
}
```

---

## Database — Drift

### Table Definitions

```dart
// data/database/tables.dart
@DataClassName('SettingRow')
class Settings extends Table {
  IntColumn get id => integer()();
  BoolColumn get someFlag => boolean().withDefault(const Constant(false))();
  RealColumn get someValue => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {id};
}
```

### Database Class

```dart
// data/database/database.dart
@DriftDatabase(tables: [Settings, Entities, ErrorLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: stepByStep(
      // from1To2: (m, schema) async { ... },
    ),
  );

  // Repository accessors
  late final settingsRepo = SettingsRepository(this);
  late final entityRepo = EntityRepository(this);
  late final errorLogRepo = ErrorLogRepository(this);
}
```

### Connection

```dart
// data/database/connection.dart
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

QueryExecutor openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
```

---

## Repository Layer

```dart
// data/repositories/entity_repository.dart
class EntityRepository {
  final AppDatabase _db;
  EntityRepository(this._db);

  Future<List<Entity>> getAll() async {
    final rows = await _db.select(_db.entities).get();
    return rows.map(_mapRow).toList();
  }

  Stream<List<Entity>> watchAll() {
    return _db.select(_db.entities).watch().map(
      (rows) => rows.map(_mapRow).toList(),
    );
  }

  Future<void> insert(Entity entity) async {
    await _db.into(_db.entities).insert(
      EntitiesCompanion.insert(
        id: entity.id,
        name: entity.name,
        // ... map domain model → companion
      ),
    );
  }

  Entity _mapRow(EntityRow row) => Entity(
    id: row.id,
    name: row.name,
    // ... map row → domain model
  );
}
```

**Key principles:**
- Repositories are the only code that knows about Drift row types.
- Everything above the repository layer works with domain models.
- Use `watch*()` streams when you need reactive updates, `get*()` futures when you don't.

---

## Model Relationships — Rich Objects over Foreign Keys

Store relationships as foreign key IDs in SQLite, but expose them as full domain model objects in Dart. The repository layer does the JOIN and mapping; everything above it uses dot notation.

### The Pattern

The domain model holds the related object. The foreign key ID is a derived getter:

```dart
final class Transaction {
  final Category? category;
  final List<Tag> tags;

  // Derived — used by repositories for DB writes and by providers for filtering.
  String get categoryId => category?.id ?? SystemCategories.uncategorized.id;

  const Transaction({
    required this.id,
    required this.amount,
    this.category,
    this.tags = const [],
    // ...
  });
}
```

The repository JOIN populates the object on reads:

```dart
class TransactionRepository {
  JoinedSelectStatement _joinQuery() {
    return _db.select(_db.transactions).join([
      leftOuterJoin(
        _db.categories,
        _db.categories.id.equalsExp(_db.transactions.categoryId),
      ),
      leftOuterJoin(
        _db.transactionTags,
        _db.transactionTags.transactionId.equalsExp(_db.transactions.id),
      ),
      leftOuterJoin(
        _db.tags,
        _db.tags.id.equalsExp(_db.transactionTags.tagId),
      ),
    ]);
  }

  List<Transaction> _mapRows(List<TypedResult> rows) {
    // Group join results, build domain objects with related entities populated
    // ...
    return Transaction(
      category: catRow != null ? Category(id: catRow.id, ...) : null,
      tags: tagsForTx,
    );
  }
}
```

On writes, the repository reads the getter — same ID the DB expects:

```dart
await _db.into(_db.transactions).insert(
  TransactionsCompanion.insert(
    categoryId: Value(tx.categoryId), // getter extracts category?.id
  ),
);
```

### Why This Works

- **Single source of truth.** You set `category:` when creating a Transaction. There's no separate `categoryId` field to keep in sync.
- **Dot notation everywhere.** UI code reads `transaction.category?.label`, `transaction.tags.first.label` — no provider lookups needed.
- **DB layer is untouched.** SQLite still stores a foreign key ID. The JOIN resolves it on reads. The getter extracts it on writes.
- **Filtering still works.** `transactions.where((t) => t.categoryId == someId)` uses the getter transparently.

### When constructing for writes

The UI layer works with IDs (e.g., a category picker returns an ID string). The notifier resolves the ID to a full object before constructing the model:

```dart
Future<void> saveTransaction({required String? categoryId, ...}) async {
  final categories = ref.read(categoryProvider);
  final category = categoryId != null
      ? categories.where((c) => c.id == categoryId).firstOrNull
      : null;

  final transaction = Transaction(category: category, ...);
}
```

### How deep to load

Decide per-model how far to eagerly load:
- **One level** (Transaction → Category) — almost always the right call. Covers 90% of UI needs.
- **Two levels** (Order → LineItem → Product) — only if the UI regularly needs it.
- **Don't load deep chains** (A → B → C → D) — fetch deeper levels on demand.

---

## Model / Data Class Conventions

### Domain Models

```dart
final class Entity {
  final String id;
  final String name;
  final double amount;
  final DateTime date;
  final String? memo;

  const Entity({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    this.memo,
  });

  Entity copyWith({
    String? name,
    double? amount,
    DateTime? date,
    String? Function()? memo, // Nullable field pattern
  }) => Entity(
    id: id,
    name: name ?? this.name,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    memo: memo != null ? memo() : this.memo,
  );
}
```

**Conventions:**
- Use `final class` for domain models.
- All fields `final`.
- `copyWith()` for creating modified instances.
- For nullable fields in `copyWith`, use the `T? Function()?` pattern so callers can explicitly set `null`.
- No freezed — manual `copyWith` is simple enough and avoids code generation overhead.
- Custom equality only when needed (by ID, not by value).

### Config / State Objects

```dart
final class FeatureConfig {
  final DateTime? startDate;
  final Set<String> selectedIds;
  final SortOrder sortOrder;

  const FeatureConfig({
    this.startDate,
    this.selectedIds = const {},
    this.sortOrder = SortOrder.descending,
  });

  FeatureConfig copyWith({...}) => ...;

  bool get hasActiveFilters => startDate != null || selectedIds.isNotEmpty;
}
```

### Enums

```dart
enum SortOrder { ascending, descending }
enum Difficulty implements Comparable<Difficulty> {
  easy, medium, hard, extreme;

  @override
  int compareTo(Difficulty other) => index.compareTo(other.index);
}
```

### ID Generation

Use descriptive prefixed IDs for entities that might be debugged or exported:

```dart
String generateId(String prefix) =>
    '$prefix-${DateTime.now().millisecondsSinceEpoch}';

// Usage: generateId('tx')  → "tx-1708977123456"
//        generateId('cat') → "cat-1708977456789"
```

---

## Dependency Injection

Riverpod IS the DI system. No need for GetIt, injectable, or other service locators.

```dart
// Define
final databaseProvider = Provider<AppDatabase>((ref) => throw UnimplementedError());

// Override at startup
ProviderScope(
  overrides: [databaseProvider.overrideWithValue(db)],
  child: const MainApp(),
)

// Consume in notifiers
final db = ref.read(databaseProvider);

// Consume in widgets
final entities = ref.watch(entityProvider);
```

**Principles:**
- All dependencies flow through Riverpod providers.
- Repositories take `AppDatabase` via constructor (created as `late final` fields on the database class).
- Notifiers access dependencies via `ref.read()` / `ref.watch()`.
- No global singletons, no static mutable state (except `ErrorLogService` which is a deliberate exception for crash safety).

---

## Testing

### Structure

```
test/
├── helpers/
│   └── test_data.dart          # Factory functions for test objects
├── core/utils/
│   └── {utility}_test.dart
├── data/
│   ├── models/
│   │   └── {model}_test.dart
│   └── repositories/
│       └── {repo}_test.dart
└── {domain}/                   # For domain-specific logic tests
    └── {component}_test.dart
```

### Test Helpers

```dart
// test/helpers/test_data.dart
Entity makeEntity({
  String? id,
  String name = 'Test',
  double amount = 0.0,
  DateTime? date,
}) => Entity(
  id: id ?? 'test-${DateTime.now().millisecondsSinceEpoch}',
  name: name,
  amount: amount,
  date: date ?? DateTime(2024, 1, 15),
);
```

Provide sensible defaults for every field. Tests should only specify the fields they care about.

### Repository Tests

Test against a real in-memory Drift database — don't mock the database layer:

```dart
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('insert and retrieve entity', () async {
    final entity = makeEntity(name: 'Test');
    await db.entityRepo.insert(entity);
    final result = await db.entityRepo.getAll();
    expect(result.length, 1);
    expect(result.first.name, 'Test');
  });
}
```

### What to Test

| Layer | Test? | Approach |
|-------|-------|----------|
| Utilities / pure functions | Yes | Standard unit tests |
| Domain models (copyWith, extensions) | Yes | Unit tests |
| Repositories | Yes | In-memory database |
| Domain logic (solvers, calculators) | Yes | Unit tests |
| Notifiers | Optional | More complex to set up, lower priority |
| Widgets | Optional | Only for complex interactive widgets |

---

## New Project Checklist

When starting a new Flutter project:

1. **Set up folder structure** per the template above.
2. **Add dependencies:** `flutter_riverpod`, `go_router`, `drift`, `sqlite3_flutter_libs`, `path_provider`, `path`, `package_info_plus`.
3. **Add dev dependencies:** `drift_dev`, `build_runner`, `flutter_lints`.
4. **Create `database.dart`, `tables.dart`, `connection.dart`** with at least a settings table and error log table.
5. **Create `ErrorLogService`** and `ErrorLogRepository`.
6. **Create `notifier_helpers.dart`** with `DbCallMixin`.
7. **Create `database_providers.dart`** with `databaseProvider` and `initialSettingsProvider`.
8. **Wire up `main.dart`** with the initialization sequence.
9. **Create `router.dart`** with route tracking redirect.
10. **Create `app.dart`** with `MaterialApp.router`.
11. **Create `test/helpers/test_data.dart`** with factory functions.
12. **Add a dev page** under settings for error log viewing.

After this foundation is in place, start building features.
