# Editorial heading spacing

Open `/_dev/editorial-spacing/` through the local server. The page displays computed-style and geometric checks automatically; resize and reload to check the other breakpoint.

Production rules live in `_resources/scss/theme/_editorial.scss`, imported immediately after the base typography rules. No HTML changes or JavaScript are required in production. The JavaScript in this preview only tests the CSS.

| Context | Below lg | lg and above |
| --- | --- | --- |
| First heading | Existing Bootstrap 0 top margin | Same |
| Content → h1/h2/h3 | 1.5rem | 3rem |
| Content → h4/h5/h6 | 1rem | 1.5rem |
| Heading → heading | .5rem | .5rem |
| Heading → paragraph | Existing .5rem heading bottom margin | Same |
| Paragraph → paragraph | Existing 1rem paragraph bottom margin | Same |

Scope: direct headings in `.main-content`, its semantic sections/articles, `.ltcc-container` snippets, and Bootstrap grid columns. Structured components and their descendants are excluded centrally (cards, accordions, navigation, sidebars, headers/footers, modals, page heroes, slider components and header link groups). Arbitrary nested wrappers are intentionally not treated as editorial sections.

Three contextual rules use `:where()` for zero-specificity scoping and preceding siblings. The heading `:is(h1, …)` retains one type selector of specificity to tie Bootstrap's heading reset; source order then supplies the margin. Class-based component styles, inline styles, and Bootstrap spacing utilities can override them. No `!important` is added.

Only heading top margins change. In normal block flow the previous paragraph/list bottom margin collapses with the heading top margin to the larger value. Inside flex/grid containers margins do not collapse, and an explicit parent gap also adds spacing; those layouts should continue to use their intentional Bootstrap spacing utilities. The special `.page-title` keeps its existing bottom border/padding/margin. Invisible editor controls inserted as siblings can count as preceding content in CMS edit mode; published content has the normal first-child behavior.

Verified in headless Chrome at 1440px and 600px: 24 checks per width, including section separation, adjacent headings, figures, tables, lists, first headings, consecutive paragraphs, component exclusions, utility overrides, nested CMS/grid contexts, and page-title typography. The CMS server itself is not needed for this static CSS preview.
