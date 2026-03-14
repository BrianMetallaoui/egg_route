# Egg Delivery Tracker — Design Document

## Overview

An Android app for a small egg delivery business to manage customers, products, orders, and delivery planning. Built with the flutter-foundation stack (Riverpod + Drift + GoRouter).

---

## Data Model

### Customer (Rolodex)
| Field | Type | Notes |
|-------|------|-------|
| id | String | Prefixed: `cust-{timestamp}` |
| name | String | Required |
| address | String | Can be empty |
| notes | String | Free-form, can be empty |

### Product
| Field | Type | Notes |
|-------|------|-------|
| id | String | Prefixed: `prod-{timestamp}` |
| label | String | e.g., "Dozen Eggs", "Half Dozen Eggs" |
| referencePrice | double | Default price when adding to an order (can be 0) |
| isActive | bool | Soft-delete so historical orders still reference it |

### Order
| Field | Type | Notes |
|-------|------|-------|
| id | String | Prefixed: `ord-{timestamp}` |
| customerId | String | FK → Customer (always linked, never orphaned) |
| isDelivered | bool | Has the product been handed off? Default: `false` |
| isPaid | bool | Has money been received? Default: `false` |
| orderDate | DateTime | When the order was placed (defaults to today) |
| deliveryDate | DateTime? | Projected delivery date, nullable |
| deliveredDate | DateTime? | When actually delivered (auto-set when isDelivered → true, defaults to today, editable) |
| paidDate | DateTime? | When paid (auto-set when isPaid → true, defaults to today, editable) |
| note | String | Optional note for the order |

An Order is a **single customer's order**. It always links to a Customer — you cannot create an order without selecting an existing customer. The order displays the customer's current info (no snapshot). Editing customer details is done from the Customers section.

**Status is two independent booleans, not an enum.** `isDelivered` and `isPaid` can flip in any order — a customer might pay ahead of delivery, pay on delivery, or pay after. An order is "finished" when both are true.

**Date rules:**
- `orderDate` — set on creation (defaults to today), always editable.
- `deliveryDate` — projected/scheduled delivery date, nullable, always editable.
- `deliveredDate` — auto-set when `isDelivered` flips to `true` (defaults to today), editable. Cleared when `isDelivered` flips back to `false`.
- `paidDate` — auto-set when `isPaid` flips to `true` (defaults to today), editable. Cleared when `isPaid` flips back to `false`.

**Derived:**
- `isFinished` → `isDelivered && isPaid`
- `finishedDate` → when both are true, `max(deliveredDate, paidDate)` — used for sorting on the Finished Orders page. Not stored, computed at read time.

### OrderLineItem
| Field | Type | Notes |
|-------|------|-------|
| id | String | Prefixed: `oli-{timestamp}` |
| orderId | String | FK → Order |
| productId | String | FK → Product (reference) |
| productLabel | String | **Snapshot** — copied from Product |
| quantity | int | How many of this product |
| unitPrice | double | Defaults to Product.referencePrice, adjustable per-line |

**Computed:** `lineTotal = quantity * unitPrice`
**Computed on Order:** `orderTotal = sum of all lineItem lineTotals`

### DeliveryPlan
| Field | Type | Notes |
|-------|------|-------|
| id | String | Prefixed: `dp-{timestamp}` |
| name | String | Optional label (e.g., "Tuesday Route") |
| createdAt | DateTime | When the plan was created |
| isFinished | bool | True when user marks the whole plan as delivered |

### DeliveryPlanItem
| Field | Type | Notes |
|-------|------|-------|
| id | String | Prefixed: `dpi-{timestamp}` |
| deliveryPlanId | String | FK → DeliveryPlan |
| orderId | String | FK → Order |
| sortOrder | int | User-controlled position in the delivery sequence |

**Key rules:**
- One order CAN appear in multiple delivery plans (flexibility for the user).
- On plan creation, items are auto-sorted grouping same-customer orders together. After that, fully user-controlled.
- An order tile in the selection screen shows a badge if it's already in another plan, but doesn't prevent selection.

### Settings
| Field | Type | Notes |
|-------|------|-------|
| id | int | Single row (id = 1) |
| warnOnDelete | bool | Default: `true` — confirm before deleting an order |
| warnOnUndeliver | bool | Default: `true` — confirm before un-marking an order as delivered |
| warnOnUnpaid | bool | Default: `true` — confirm before un-marking an order as paid |
| warnOnPlanDeliver | bool | Default: `true` — confirm before bulk-marking all orders in a delivery plan as delivered |

### ErrorLog
Standard error log table per flutter-foundation.

---

## Order Lifecycle

```
                ┌─────────────┐
                │     New      │
                │ !delivered   │
                │ !paid        │
                └──────┬───────┘
               ┌───────┴────────┐
               ▼                ▼
    ┌──────────────┐  ┌──────────────┐
    │  Delivered    │  │    Paid      │
    │  delivered    │  │  !delivered  │
    │  !paid        │  │   paid       │
    └───────┬──────┘  └──────┬───────┘
            └───────┬────────┘
                    ▼
            ┌──────────────┐
            │   Finished    │
            │  delivered    │
            │  paid          │
            └──────────────┘
```

- **New**: `!isDelivered && !isPaid` — just created, nothing has happened yet.
- **Delivered only**: `isDelivered && !isPaid` — product handed off, awaiting payment.
- **Paid only**: `!isDelivered && isPaid` — customer paid ahead, awaiting delivery.
- **Finished**: `isDelivered && isPaid` — both done, order moves to Finished Orders page.

Both flags can be toggled freely. Four separate settings control warnings:
- **warnOnDelete** (default ON): Confirm before deleting an order.
- **warnOnUndeliver** (default ON): Confirm before un-marking delivered (on save, if `isDelivered` went from true → false).
- **warnOnUnpaid** (default ON): Confirm before un-marking paid (on save, if `isPaid` went from true → false).
- **warnOnPlanDeliver** (default ON): Confirm before bulk-marking all orders in a delivery plan as delivered.

**Warning trigger rule:** Warnings are checked **on save**, comparing the current state to what was originally loaded. If a boolean went from `true` to `false`, the relevant warning fires. If it was already `false` when the page loaded (even if the user toggled it on and off), no warning.

---

## Navigation Structure

**Hamburger drawer** with sections:

```
Drawer:
├── Orders (default/home)
├── Finished Orders
├── Delivery Plans
├── Customers
├── Products
└── Settings
```

No bottom navigation bar. The drawer is the primary navigation between sections.

---

## Features & Screens

### 1. Orders Section (Home)

#### Orders Page (`/` — default)
The main page. Shows all **non-finished** orders (where `!isDelivered || !isPaid`).

**Filter tabs:**
- **All** — all non-finished orders
- **New** — `!isDelivered && !isPaid`
- **Delivered** — `isDelivered && !isPaid`
- **Paid** — `!isDelivered && isPaid`

**Sort options:**
- **Order Date** (default) — newest first
- **Delivery Date** — concrete dates at top (ascending), null dates at bottom
- **Customer** — alphabetical by customer name

Each order card shows: customer name, product summary, total, delivered/paid indicators, delivery date (if set), and a badge if it's part of a delivery plan.

**FAB**: Create new order.

Tap any order → Order Edit Page.

#### Finished Orders Page (`/finished-orders`)

Accessible from the drawer. A dedicated page for reviewing orders where both `isDelivered && isPaid`.

**Default view:** One flat list, sorted by finished date descending (most recently finished first). Finished date = `max(deliveredDate, paidDate)`.

**Controls:**
- **Group by month** toggle — when enabled, orders are grouped under month headers (e.g., "March 2026") based on finished date, with a total shown per group.
- **Filter by customer** dropdown — narrow the list to a specific customer.

Each order card shows the same info as the main orders page, plus the delivered date and paid date. Tap → Order Edit Page.

#### New Order Page (`/order/new`)

**Layout (top to bottom):**

1. **Customer section**
   - Searchable dropdown to select a customer (must link to existing customer)
   - **"+" button** next to the search bar → navigates to Add Customer page. On return, the new customer is available to search/select.
   - Once selected, the customer's **address** and **notes** display directly below the dropdown (read-only — editing customer info is done from the Customers section).

2. **Order date** — date picker, defaults to today.

3. **Delivery date** — date picker, optional (nullable).

4. **Products section**
   - Each line item row: searchable product dropdown + quantity field + unit price field (pre-filled from product reference price) + line total (computed, read-only) + remove button
   - **"+" button** next to the product dropdown → navigates to Add Product page. On return, the new product is available to search/select.
   - **"Add Product" button** at the bottom of the products list to add another line item row.

5. **Order note** — optional free-form text field.

**Persistent bottom bar:**
- Left: **Order total** (updates live as products/quantities/prices change)
- Right: **Save button**

On save → order is created with `isDelivered = false, isPaid = false`, navigates back to Orders page.

#### Order Edit Page (`/order/:id`)

Same layout as New Order Page, with these additions:

- **Delivered toggle** (checkbox/switch) with date picker for `deliveredDate`. When toggled on, date auto-fills to today. When toggled off, date clears.
- **Paid toggle** (checkbox/switch) with date picker for `paidDate`. When toggled on, date auto-fills to today. When toggled off, date clears.
- **Delivery plan references** — if this order belongs to any delivery plans, show them as tappable chips/links (e.g., "Part of: Tuesday Route, Weekend Batch"). Tapping navigates to that plan.
- **Delete button** in the app bar (top right) — with optional warning dialog.

On save, the app compares the original loaded state to the current state:
- If `isDelivered` went true → false and `warnOnUndeliver` is on → show warning.
- If `isPaid` went true → false and `warnOnUnpaid` is on → show warning.
- If both flipped, show both warnings (or a combined one).

The customer dropdown is still editable (can switch the customer on the order).

---

### 2. Delivery Plans Section

#### Delivery Plans Page (`/delivery-plans`)

Two sub-tabs:
- **Current** — plans where `isFinished = false`
- **Finished** — plans where `isFinished = true`

Each plan card shows: name, order count, total value, created date.

**FAB**: Create new delivery plan.

#### New Delivery Plan — Order Selection Page (`/delivery-plans/new`)

- Shows all non-finished orders (`!isDelivered || !isPaid`)
- Each order tile shows: customer name, product summary, total, delivered/paid indicators
- **Badge/indicator** on orders that are already part of another delivery plan (shows which plan(s)), but selection is NOT blocked
- Multi-select with checkboxes
- **"Create Plan"** button at the bottom

On creation:
- Orders are auto-sorted: grouped by customer (same customer's orders adjacent), then by order date within each customer group.
- User is taken to the plan detail page where they can reorder.

#### Delivery Plan Detail Page (`/delivery-plan/:id`)

- **Plan name** (editable at top)
- **Product summary panel** — collapsible, shows aggregated product quantities across all orders in the plan (e.g., "Dozen Eggs × 15, Half Dozen × 3") plus total dollar amount for the whole run. This is the "what to load up" view.
- **Reorderable list** of orders in the plan. Each item shows:
  - Customer name + address
  - Product list + order total
  - Delivered/paid indicators
  - Quick toggle to mark delivered
- **Edit plan**: add more orders (goes to selection page) or remove orders (swipe/button). Adding/removing has no effect on the order itself — it just changes plan membership.
- **"Mark All Delivered" button** — sets `isDelivered = true` and `deliveredDate = today` on all orders in the plan, and sets `isFinished = true` on the plan itself. Does NOT mark as paid — the user handles payment separately. Shows a confirmation dialog if `warnOnPlanDeliver` setting is on.
- **Delete plan** button — removes the plan only, orders are unaffected.

---

### 3. Customers Section

#### Customers Page (`/customers`)
- List of all customers
- Search/filter by name
- Tap → Customer Edit Page
- FAB to add new customer

#### Customer Add/Edit Page (`/customer/new`, `/customer/:id`)
- Name (required)
- Address
- Notes (free-form)
- Save / Delete

---

### 4. Products Section

#### Products Page (`/products`)
- List of all products with reference price
- Toggle to show/hide inactive products
- Tap → Product Edit Page
- FAB to add new product

#### Product Add/Edit Page (`/product/new`, `/product/:id`)
- Label (required)
- Reference price
- Active/inactive toggle
- Save / Delete (soft-delete sets inactive)

---

### 5. Settings Section

#### Settings Page (`/settings`)
- **Warn on order delete** toggle (default: on)
- **Warn on un-marking delivered** toggle (default: on)
- **Warn on un-marking paid** toggle (default: on)
- **Warn on plan deliver** toggle (default: on)
- App version info
- **Dev page** link → error log viewer (per flutter-foundation)

---

## Domain Model Relationships (per flutter-foundation pattern)

Following the "rich objects over foreign keys" pattern:

- **Order** holds `Customer?` (reference to rolodex), `List<OrderLineItem>`, `List<DeliveryPlanRef>` (plans this order belongs to)
- **OrderLineItem** holds `Product?` (reference to catalog entry)
- **DeliveryPlan** holds `List<DeliveryPlanItem>`
- **DeliveryPlanItem** holds `Order` (the full order with its line items)

The repository does the JOINs. Everything above the repo layer uses dot notation.

**Loading strategy:**
- Order list page: load orders with line items (one level). Delivery plan membership loaded as a lightweight list (just plan id + name, no deep load).
- Delivery plan detail: load plan → items → full orders with line items (two levels).
- Order edit page: load order with line items + lightweight delivery plan list.

---

## Folder Structure

```
lib/
├── main.dart
├── app.dart
├── router.dart
├── core/
│   ├── constants.dart
│   └── utils/
│       └── id_generator.dart
├── data/
│   ├── database/
│   │   ├── database.dart
│   │   ├── tables.dart
│   │   └── connection.dart
│   ├── models/
│   │   ├── customer.dart
│   │   ├── product.dart
│   │   ├── order.dart
│   │   ├── order_line_item.dart
│   │   ├── delivery_plan.dart
│   │   └── delivery_plan_item.dart
│   └── repositories/
│       ├── customer_repository.dart
│       ├── product_repository.dart
│       ├── order_repository.dart
│       ├── delivery_plan_repository.dart
│       ├── settings_repository.dart
│       └── error_log_repository.dart
├── features/
│   ├── orders/
│   │   ├── orders_page.dart             # main page with filter tabs + sort
│   │   ├── orders_provider.dart         # sort/filter state
│   │   ├── finished_orders_page.dart    # finished orders page with grouping + filter
│   │   ├── finished_orders_provider.dart # group-by-month toggle + customer filter
│   │   ├── order_form_page.dart         # shared new + edit order page
│   │   └── widgets/
│   │       ├── order_card.dart
│   │       ├── customer_search.dart     # searchable dropdown with + button
│   │       ├── product_line_editor.dart # product row: dropdown + qty + price
│   │       └── order_bottom_bar.dart    # total + save button
│   ├── delivery_plans/
│   │   ├── delivery_plans_page.dart     # current/finished tabs
│   │   ├── delivery_plan_detail_page.dart
│   │   ├── order_selection_page.dart
│   │   └── widgets/
│   │       ├── product_summary.dart     # aggregated product totals
│   │       └── plan_order_tile.dart     # reorderable order tile
│   ├── customers/
│   │   ├── customers_page.dart
│   │   ├── customer_form_page.dart      # shared add + edit
│   │   └── widgets/
│   ├── products/
│   │   ├── products_page.dart
│   │   ├── product_form_page.dart       # shared add + edit
│   │   └── widgets/
│   └── settings/
│       ├── settings_page.dart
│       └── dev_page.dart
├── providers/
│   ├── database_providers.dart
│   ├── notifier_helpers.dart
│   ├── customer_provider.dart
│   ├── product_provider.dart
│   ├── order_provider.dart
│   ├── delivery_plan_provider.dart
│   └── settings_provider.dart
├── services/
│   └── error_log_service.dart
└── widgets/
    ├── status_chip.dart
    └── searchable_dropdown.dart         # reusable searchable dropdown
```

---

## Build Order (Implementation Phases)

### Phase 1: Foundation
1. Add dependencies (riverpod, drift, go_router, sqlite3_flutter_libs, path_provider, path, package_info_plus, drift_dev, build_runner)
2. Set up database tables, connection, database class
3. Set up ErrorLogService, DbCallMixin, database providers
4. Wire up main.dart, app.dart, router.dart with drawer navigation shell
5. Create domain models
6. Create repositories

### Phase 2: Customers & Products (CRUD)
7. Customer provider + Customers page + Customer form (add/edit)
8. Product provider + Products page + Product form (add/edit)
9. Searchable dropdown widget (reusable for both customers and products)

### Phase 3: Orders (Core Feature)
10. Order provider (with OrderLineItem management)
11. Settings provider (warning toggles)
12. Order form page (new + edit, shared layout):
    - Customer search with + button
    - Customer info display (address, notes)
    - Product line items with + button
    - Bottom bar (total + save)
    - Delivered/paid toggles with dates (edit mode only)
    - Delete (edit mode only)
    - Delivery plan references (edit mode only)
    - "Save to Rolodex" (edit mode only)
13. Orders list page with filter tabs (All / New / Delivered / Paid) + sort options
14. Finished orders page (flat list, group-by-month toggle, customer filter)

### Phase 4: Delivery Plans
15. DeliveryPlan provider
16. Delivery plans page (current/finished tabs)
17. Order selection page (multi-select with plan-membership badges)
18. Delivery plan detail page (reorderable list, product summary, mark-all-delivered, add/remove orders)

### Phase 5: Polish
19. Settings page with warning toggles + dev page
20. UI polish, empty states, confirmation dialogs

---

## Open Questions — RESOLVED

1. ~~Order = delivery run or per-customer?~~ → **Per-customer.** Batching handled by DeliveryPlans.
2. ~~Status transitions?~~ → **Two independent booleans** (`isDelivered`, `isPaid`). Both can toggle freely. Warnings on save when either goes true → false.
3. ~~Deleting orders?~~ → **Allowed** with optional warning (separate setting).
4. ~~Same customer in delivery plan?~~ → **Yes.** Different orders, auto-grouped by customer on creation.
5. ~~Target platform?~~ → **Android only.**
6. ~~Price model?~~ → **quantity × unitPrice.** Default from reference price, adjustable.
7. ~~Scheduling?~~ → **orderDate + optional deliveryDate + deliveredDate + paidDate.** All editable. Sort by order date, delivery date, or customer.

## Design Decisions Log

- **Status is two booleans, not an enum.** `isDelivered` and `isPaid` are independent — customer can pay before, during, or after delivery. Order is "finished" when both are true.
- **Finished date is derived, not stored.** `max(deliveredDate, paidDate)` when both exist. Used for sorting on the Finished Orders page.
- **Warnings checked on save, not on toggle.** Compare original loaded state to current state. Only warn if a boolean went true → false. Toggling on and off without saving doesn't trigger.
- **No truncation on customer notes in order form.** This is a purpose-built app. Full notes display; user scrolls if long.
- **No customer snapshots.** Orders link to a customer and display their current info. Editing customer details is done from the Customers section. This keeps it simple — the customer is the customer.
- **Customer must exist before creating an order.** No inline customer creation in the order form — but a "+" quick-add button navigates to the customer form and back.
- **Same pattern for products.** "+" button next to product dropdown navigates to product form.
- **Shared form page for new + edit orders.** Same layout, edit mode adds delivered/paid toggles, delete, and plan references.
- **Hamburger drawer navigation** instead of bottom tabs. Sections: Orders, Finished Orders, Delivery Plans, Customers, Products, Settings.
- **Finished orders have their own dedicated page** in the drawer. Default: flat list sorted by finished date descending. Optional group-by-month toggle + customer filter.
- **Orders can belong to multiple delivery plans.** Badge shown during selection but doesn't block.
- **"Mark All Delivered" on delivery plan** marks orders as delivered (not paid). User handles payment separately.
- **No separate reports section.** The finished orders page with month grouping and totals covers reporting needs.
