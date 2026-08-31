# Data table standard

Design the information, not the database. A table is a task-oriented view of records, not a visual dump of an API response.

## Contents

- [Reason before choosing columns](#reason-before-choosing-columns)
- [Choose the representation and row model](#choose-the-representation-and-row-model)
- [Design table controls](#design-table-controls)
- [Design actions](#design-actions)
- [Design pagination](#design-pagination)
- [Design every table state](#design-every-table-state)
- [Handle smaller viewports](#handle-smaller-viewports)
- [Apply table-specific accessibility](#apply-table-specific-accessibility)
- [Implementation checklist](#implementation-checklist)

## Reason before choosing columns

Never begin by mapping every API or database field to a column. First determine:

- what records and fields are available;
- what the user is trying to accomplish with this view;
- what identifies a record at a glance;
- what users need to compare across rows;
- what users naturally search, filter, or sort by;
- what actions belong to each record; and
- what is merely supporting, operational, or internal metadata.

Inspect all available fields, then classify each by its role in this task:

| Role | Meaning | Likely treatment |
| --- | --- | --- |
| Identity | Recognizes or distinguishes the record | Make prominent; often the first column |
| Primary | Supports the main comparison or decision | Keep visible in the primary row |
| Supporting | Adds useful context but is not needed for every scan | Use a secondary line, expansion, drawer, or detail view |
| Operational | Supports status, workflow, or an action | Show only when it changes what the user understands or can do |
| Internal | Exists for implementation, auditing, or transport | Omit unless the task specifically requires it |

This classification is contextual. A field can be primary in one table and internal in another. Do not expose a field merely because it exists.

### Combine fields by meaning

Look for raw fields that together represent one concept. For example, prefer an `Employee`, `Person`, `Contact`, or `Full name` column displaying `Andrea Caselli` over separate `First name` and `Last name` columns. The label must reflect the concept in this application.

The display value, search fields, and sort key need not match. The employee cell can combine avatar, first name, and last name; global search can include email and employee ID; default sorting can still use `lastName`.

Other useful combinations can include city and country as `Location`, start and end dates as `Period`, or status and its reason as one `Status` presentation when the reason clarifies the state. Combine fields only when they form a concept users understand, not simply to reduce the column count.

## Choose the representation and row model

Confirm that repeated records and cross-record comparison actually make a table appropriate. When hierarchy, narrative content, or one-record-at-a-time action dominates, a list, cards, or another view may work better.

If a table is appropriate, choose what belongs in the primary row from the information hierarchy:

- Keep identity and information needed for scanning or comparison visible.
- Do not squeeze in secondary columns just because they technically fit at one desktop width.
- Use secondary lines inside a cell when they clarify the primary value without creating another comparison axis.
- Move useful secondary detail to an expandable row, drawer, or detail view when it would otherwise make the row dense.
- Never hide the table's primary information behind expansion.

Do not use a fixed maximum column count. Density depends on content width, scan patterns, importance, and viewport—not just the number of fields.

## Design table controls

### Search

Provide search for a meaningful table unless it would offer no useful way to locate records. Search the fields users naturally associate with identity, not every backend field.

Prefer one global search when several raw fields represent the same search concept. An employee search can match first name, last name, email, and employee ID without presenting four inputs. Use separate search controls only for meaningfully distinct concepts. Always provide an obvious way to clear the query.

### Filters

Add filters only for fields that materially narrow the dataset for the user's task. Prioritize crucial dimensions rather than generating a filter for every column or raw field.

Active filters must be apparent. Let users clear an individual filter and provide a simple way to clear all search/filter state when multiple criteria can accumulate. Reset pagination to the first page after criteria change unless preserving the page has a deliberate, defensible benefit.

### Sorting

Make important identity and comparison columns sortable when their ordering is meaningful. Do not imply sortability on values where ordering would be arbitrary or misleading.

For combined cells, define the sort key deliberately. `Andrea Caselli` may display as a full name while sorting by `lastName`. Make the active column and direction visible and understandable.

## Design actions

When a record has multiple secondary actions, put a keyboard-accessible ellipsis menu in a final actions column instead of repeating several buttons in every row. Present it as a polished floating menu, keep labels concise, group related actions, and use icons only when they improve recognition. The actions column is not sortable.

Place destructive actions at the bottom of the menu, visually separate them from ordinary actions, and use destructive styling. Do not let them compete with the primary workflow or sit where accidental activation is likely. Require confirmation when the outcome cannot be trivially undone.

A row click must not make embedded controls ambiguous: menu triggers, links, selection controls, and expansion controls need distinct behavior and interaction targets.

## Design pagination

Assume a dataset that can grow needs pagination unless the product has a justified alternative such as bounded data or deliberate virtualization/infinite loading. Include the current page, navigation controls, and sensible page-size choices.

Choose client- or server-side pagination from expected dataset size and application architecture. Do not fetch thousands of records solely to paginate them in the browser when the server can page, filter, and sort. Keep search, filters, sorting, page, and page size consistent in one query state so results and controls cannot drift apart.

## Design every table state

### Empty and no-results states

Treat these as different states:

- **Empty dataset:** explain that no records exist yet, such as `No employees have been added yet.` Offer a relevant creation action when the user can resolve it.
- **No search/filter results:** explain that the current criteria matched nothing, such as `No employees match "Michelangelo".` Offer recovery by clearing search, clearing filters, or adjusting criteria.

Never reuse one generic empty message for both.

### Initial loading

Use a skeleton when appropriate, and make it mirror the final table: preserve header and column geometry, approximate realistic content widths, show a sensible number of rows, and minimize layout shift. Do not substitute unrelated full-width gray bars.

### Failure, refresh, and mutation

Plan separately for initial loading failure, background refresh, mutations, and relevant partial failures. If stale data remains safe and useful during refresh, keep it visible and show restrained refresh feedback instead of replacing the table with an empty spinner. During mutations, communicate what is pending and prevent only interactions that would conflict.

Use persistent inline feedback for information the user must retain or act on. For transient mutation success and non-blocking errors, prefer Sonner at `bottom-right` unless the project already has a deliberate notification pattern. For longer asynchronous work, use one promise/lifecycle toast that moves from loading to success or error rather than emitting unrelated toasts.

## Handle smaller viewports

Set a priority for each piece of row information. On narrower viewports, decide deliberately whether to:

- hide secondary columns;
- move secondary content into an expansion or detail surface;
- preserve the table with horizontal scrolling; or
- use a different representation when scanning and actions genuinely improve.

Do not leave a desktop table to overflow by accident, and do not automatically convert every table into cards. Preserve the user's primary comparison task in whichever representation you choose.

## Apply table-specific accessibility

- Expose sortable headers as interactive controls with the current sort direction programmatically available.
- Make action menus fully keyboard operable and give icon-only controls accessible names.
- Communicate expanded/collapsed state and the relationship between an expansion control and its content.
- Keep row selection, row navigation, and nested actions distinguishable to keyboard and assistive-technology users.
- Never use color alone to communicate status, selection, or destructive meaning.

## Implementation checklist

- [ ] Analyze the task and complete dataset before choosing columns.
- [ ] Identify primary information and combine related fields only when semantically useful.
- [ ] Keep row density reasonable and primary information immediately visible.
- [ ] Add useful search, filters, clear/reset behavior, and meaningful sorting.
- [ ] Use the agreed action-menu pattern and separate destructive actions.
- [ ] Choose a deliberate pagination/data-loading strategy.
- [ ] Distinguish empty-dataset and no-results states.
- [ ] Make the loading skeleton reflect the actual layout.
- [ ] Cover initial failure, refresh, mutation, and feedback states.
- [ ] Choose responsive behavior from information priority.
- [ ] Verify table-specific keyboard and assistive-technology behavior.
