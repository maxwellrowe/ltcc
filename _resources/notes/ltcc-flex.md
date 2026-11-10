# LTCC Flex snippet

Register `_resources/snippets/ltcc-flex.html` as the snippet source in Modern Campus. Its transformation lives in `_resources/xsl/_shared/snippets.xsl`.

Each body row becomes one direct flex child. All content within that row stays grouped, including nested snippets and components. Add or remove body rows to change the number of items.

The parent always gets `d-flex`. Its class setting accepts Bootstrap utilities:

| Layout | Container classes |
| --- | --- |
| Stack on mobile, row at lg | `flex-column flex-lg-row gap-3` |
| Wrapping row | `flex-row flex-wrap gap-3` |
| Center items | `flex-wrap justify-content-center align-items-center gap-3` |
| Spread items across a row at lg | `flex-column flex-lg-row justify-content-lg-between gap-3` |

Item classes can include `flex-lg-fill`, `flex-shrink-0`, or `align-self-lg-center`. Ordering classes such as `order-lg-2` change visual order only, so avoid them when they would make keyboard or reading order confusing.

`flex-fill` distributes available space but does not guarantee equal widths for different content. Use the LTCC Columns snippet with `col-*` classes when a precise column grid is needed. Bootstrap's width utilities such as `w-100` do not have responsive variants in this theme.

Place the Flex snippet **inside** an LTCC Container when you want a centered page-width constraint. Putting one Container inside a single flex row groups everything inside it as one flex item.

Prefer palette classes such as `bg-gray-100` to the optional Background Shorthand field. Background values preserve case so image paths remain intact. If both are supplied, Bootstrap's `bg-*` utility may override the inline background color.

The initial two rows stack below lg and sit side by side at lg and above. No new CSS or JavaScript is required.
