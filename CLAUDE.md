# Egg Delivery Tracker

Android app for managing egg delivery orders. Built with Flutter using Riverpod + Drift + GoRouter.

## Architecture

Follow `flutter-foundation.md` for all patterns — it is the single source of truth for how code is structured. Key rules:

- **Riverpod** for state management. `Notifier` pattern with `DbCallMixin` for database calls.
- **Drift** for persistence. Repository layer maps DB rows <-> domain models. Nothing outside `data/` touches Drift tables directly.
- **GoRouter** with hamburger drawer navigation (not bottom nav).
- **Rich objects over foreign keys** — repositories do JOINs, everything above uses dot notation.
- Domain models are `final class` with manual `copyWith`. No freezed, no code generation for models.

## Design

Full spec is in `DESIGN.md`. Read it before implementing any feature — it has the data model, screen layouts, UX flows, and build phases.

## Project Structure

```
lib/
├── main.dart / app.dart / router.dart
├── core/constants.dart, utils/
├── data/database/, models/, repositories/
├── features/orders/, delivery_plans/, customers/, products/, settings/
├── providers/          # app-wide notifiers
├── services/           # stateless business logic
└── widgets/            # shared UI components
```

- Feature-scoped providers live in `features/{name}/`.
- App-wide providers live in `providers/`.
- One repository per entity in `data/repositories/`.

## Key Patterns

### Customer info snapshotting
When creating an order, customer name/address/notes are **copied** to the order. Edits to the snapshot do NOT affect the master customer record. A "Save to Rolodex" action explicitly pushes changes back. Same principle for product label snapshots on line items.

### Order status — two independent booleans
Status is NOT a single enum. Orders have two independent flags:
- `isDelivered` — has the product been handed off?
- `isPaid` — has money been received?

These can flip in any order (customer may pay before, during, or after delivery). An order is "finished" when BOTH are true. Finished date = `max(deliveredDate, paidDate)` — derived, not stored.

### Dates
- `orderDate` — set on creation, always editable
- `deliveryDate` — projected delivery date, nullable, always editable
- `deliveredDate` — auto-set when `isDelivered` → true (defaults to today), editable. Cleared when → false.
- `paidDate` — auto-set when `isPaid` → true (defaults to today), editable. Cleared when → false.

### Warning settings
Four independent boolean settings (all default ON):
1. `warnOnDelete` — confirm before deleting an order
2. `warnOnUndeliver` — confirm before un-marking delivered
3. `warnOnUnpaid` — confirm before un-marking paid
4. `warnOnPlanDeliver` — confirm before bulk-marking a delivery plan as delivered

Warnings are checked **on save**, comparing the original loaded state to the current state. Only warn if a boolean went `true → false`. When the setting is OFF, perform the action immediately with no dialog.

### ID generation
Prefixed IDs: `cust-{timestamp}`, `prod-{timestamp}`, `ord-{timestamp}`, `oli-{timestamp}`, `dp-{timestamp}`, `dpi-{timestamp}`.

## Commands

```bash
# Run the app
flutter run

# Run code generation (Drift)
dart run build_runner build --delete-conflicting-outputs

# Watch for code generation changes
dart run build_runner watch --delete-conflicting-outputs

# Run tests
flutter test

# Analyze
flutter analyze
```

## Dependencies

Core: `flutter_riverpod`, `go_router`, `drift`, `sqlite3_flutter_libs`, `path_provider`, `path`, `package_info_plus`

Dev: `drift_dev`, `build_runner`, `flutter_lints`

## Conventions

- Android only — do not add iOS/web-specific code.
- No truncation on customer notes in the order form. Display in full, let the user scroll.
- Customers must exist before creating an order. No inline creation — use the "+" quick-add button to navigate to the customer form and back. Same for products.
- Products use soft-delete (`isActive` flag) so historical orders still reference them.
- Finished orders (both delivered AND paid) live on their own dedicated page (`/finished-orders`), not a tab on the main orders page.
- Orders can belong to multiple delivery plans.
- "Mark All Delivered" on a delivery plan marks orders as delivered (not paid).
- Do not refer to the client by name anywhere in code, comments, or docs.
