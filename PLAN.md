# Implementation Plan

Reference `DESIGN.md` for full spec. Reference `flutter-foundation.md` for architecture patterns.

---

## Phase 1: Foundation
> Goal: App compiles, drawer nav works, database generates, empty shell screens exist.

- [x] 1.1 — Add all dependencies to `pubspec.yaml`
- [x] 1.2 — Create database tables (`data/database/tables.dart`)
- [x] 1.3 — Create database connection (`data/database/connection.dart`)
- [x] 1.4 — Create database class (`data/database/database.dart`)
- [x] 1.5 — Run `build_runner`, confirm Drift codegen succeeds
- [x] 1.6 — Create domain models (Customer, Product, Order, OrderLineItem, DeliveryPlan, DeliveryPlanItem)
- [x] 1.7 — Create repositories (Customer, Product, Order, DeliveryPlan, Settings, ErrorLog)
- [x] 1.8 — Create ErrorLogService
- [x] 1.9 — Create DbCallMixin + database providers
- [x] 1.10 — Wire up `main.dart` with initialization sequence
- [x] 1.11 — Create `app.dart` with MaterialApp.router
- [x] 1.12 — Create `router.dart` with drawer navigation shell + placeholder pages
- [x] 1.13 — Create `core/constants.dart` + `core/utils/id_generator.dart`

**Checkpoint:** App runs, drawer opens with all sections (Orders, Finished Orders, Delivery Plans, Customers, Products, Settings), each showing a placeholder page.

---

## Phase 2: Customers & Products (CRUD)
> Goal: Can create, edit, delete customers and products. Searchable dropdown widget built.

- [x] 2.1 — Customer provider (app-wide notifier)
- [x] 2.2 — Customers page (list with search/filter)
- [x] 2.3 — Customer form page (shared add/edit, with delete)
- [x] 2.4 — Product provider (app-wide notifier)
- [x] 2.5 — Products page (list with active/inactive toggle)
- [x] 2.6 — Product form page (shared add/edit, with soft-delete)
- [x] 2.7 — Searchable dropdown widget (reusable)

**Checkpoint:** Can add/edit/delete customers and products. Search works. Soft-delete works for products.

---

## Phase 3a: Order Form
> Goal: Can create and edit orders with full order form UX.

- [x] 3a.1 — Order provider (app-wide notifier with line item management)
- [x] 3a.2 — Settings provider (warning toggles)
- [x] 3a.3 — Customer search widget (searchable dropdown + "+" quick-add button)
- [x] 3a.4 — Product line editor widget (product dropdown + qty + price + remove)
- [x] 3a.5 — Order bottom bar widget (total + save)
- [x] 3a.6 — Order form page — new mode (customer selection, customer info display, dates, products, note, save)
- [x] 3a.7 — Order form page — edit mode (delivered/paid toggles with dates, delete, save-to-rolodex, delivery plan references)

**Checkpoint:** Can create an order by picking a customer and adding products. Can edit an order, toggle delivered/paid, delete. Customer info snapshots correctly. Prices default from product reference price and can be adjusted.

---

## Phase 3b: Order Lists
> Goal: Main orders page and finished orders page fully functional.

- [x] 3b.1 — Order card widget (with delivered/paid indicators)
- [x] 3b.2 — Orders page (All/New/Delivered/Paid filter tabs, 3 sort options, FAB, tap to edit)
- [x] 3b.3 — Finished orders provider (group-by-month toggle, customer filter)
- [x] 3b.4 — Finished orders page (flat list default, group-by-month, customer filter, sorted by finished date)

**Checkpoint:** Non-finished orders show on the main page with filter tabs. Sort options work. Finished orders (both delivered + paid) appear on their own page with grouping and filtering.

---

## Phase 4: Delivery Plans
> Goal: Full delivery plan lifecycle works.

- [x] 4.1 — DeliveryPlan provider (stream-backed, bulk mark delivered/paid)
- [x] 4.2 — Delivery plans page (current/finished tabs)
- [x] 4.3 — Order selection page (multi-select, plan-membership badges)
- [x] 4.4 — Delivery plan detail page (reorderable list, edit name, delivery date)
- [x] 4.5 — Product summary widget (aggregated quantities + total dollar amount)
- [x] 4.6 — Swipe actions on plan order tiles (delivered, paid, remove from plan)
- [x] 4.7 — Mark All Delivered + Mark All Paid (one-way, with confirmation)
- [x] 4.8 — Add/remove orders from existing plan
- [x] 4.9 — Order edit page — delivery plan references (already done in Phase 3a)

**Checkpoint:** Can create a delivery plan from active orders, reorder them, see product summary, mark all delivered. Orders show which plans they belong to.

---

## Phase 5: Polish
> Goal: Settings functional, empty states handled, warnings work, app feels complete.

- [x] 5.1 — Settings page (4 warning toggles, app version, dev page link)
- [x] 5.2 — Dev page (error log viewer)
- [x] 5.3 — Empty states for all list pages
- [x] 5.4 — Confirmation dialogs (delete, undeliver, unpaid, plan deliver) respecting settings
- [x] 5.5 — Final UI pass (consistent spacing, loading states, edge cases)
- [x] 5.6 — Dark mode and add more color to the app just a bit
- [ ] 5.7 — Make an icon and get the app a proper name
