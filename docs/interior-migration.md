# Interior Page rollout — November 12, 2026

## Compatible layout values

| Stored `layout` value | Editor label | Output |
| --- | --- | --- |
| `one` | 1 Column | Centered reading column, maximum 50rem (800px at default root size); no sidenav |
| `two` | 2 Columns Nav | `col-lg-9` main content and `col-lg-3` sidebar |
| `three` | 2 Columns with Additional Content | Same two-column layout, with existing `right-content` beneath sidenav |
| `full` | Full Width | Browser-width content, no container or layout padding; no sidenav |

Missing/unrecognized layout values fall back to `one`. New pages default to `one`. Existing `two` and `three` selections stay unchanged. Do **not** globally replace `three` with `two`, or rename the `right-content` region: doing so hides existing additional content.

Below lg (992px), a single sidebar moves immediately below the shared header and above the hero/content. Bootstrap Collapse controls the section menu and nested lists. Real parent links remain navigable with separate submenu toggle buttons; `href="#"` parent links retain click-to-toggle behavior. Current-page ancestors open automatically. The additional content stays below the nav within the section-menu panel.

## Files to deploy

- `_resources/xsl/common.xsl` — optional body-class and after-header hooks (defaults preserve other templates).
- `_resources/xsl/interior.xsl` — layouts, hero output, breadcrumb markup, responsive sidebar.
- `_resources/ou/templates/interior.tmpl` — new-page property options/regions.
- `_resources/css/ltcc-custom.css` — rebuilt shared stylesheet.
- `_resources/js/nested-menu.js` and `_resources/includes/footcode.inc` — Bootstrap submenu controls, responsive sidebar relocation, cache-busting version.

SCSS source files should also be synced to your source workspace: `ltcc-custom.scss`, `theme/_nested-menu.scss`, and `theme/_interior.scss`.

Republish existing Interior Page PCFs after deploying the XSL/CSS/JS. Two/three-column pages adopt the new layout without changing their selected values. Existing pages keep breadcrumbs visible if the new parameter is missing.

## Existing PCF property/region changes

Updating the `.tmpl` does not update existing PCFs. Limit changes to files using exactly `/_resources/xsl/interior.xsl`; exclude archives and unrelated templates. Preserve each file’s selected options.

1. In the `layout` parameter, change the displayed labels for `two` and `three`, and add `one` / `full` with `selected="false"`. Do not reset existing selected values to the new-page default.
2. Add the `hero` option to `top-media`, unselected. Retain the selected `off`, `banner`, or `slider` option. Update its prompt to “Top of Page Media.”
3. Add this property inside `ouc:properties[@label='config']`:

```xml
<parameter name="show-breadcrumbs" type="select" group="Everyone" prompt="Show Breadcrumbs" alt="Show or hide the breadcrumb trail.">
  <option value="true" selected="true">Show</option>
  <option value="false" selected="false">Hide</option>
</parameter>
```

4. Add this top-level editable region once (do not place it inside another region):

```xml
<ouc:div label="hero-content" group="Everyone" button-text="Hero Content">
  <ouc:editor csspath="/_resources/ou/editor/wysiwyg.css" cssmenu="/_resources/ou/editor/styles.txt" wysiwyg-class="hero-content"/>
</ouc:div>
```

5. Replace `button-text="Right Column Content"` with `button-text="Additional Content"` only on the `right-content` region. Leave its label, content, and `wysiwyg-class="right-content"` intact.

Hero mode adds `page-hero-enabled` to the body and suppresses the `.page-title` H1. The future hero component/content must supply the page H1. Hero output has no container/padding/margin, and begins directly below the header (below the section toggle on mobile). Banner output uses Bootstrap `img-fluid` and stays within its chosen content column. The legacy Slider option is retained.

## Optional export migration helper

The helper performs the changes above on exported PCFs, preserving content and selections. It does not connect to Modern Campus or publish anything. It is dry-run by default; unknown or ambiguous parameter values are reported as `REVIEW` and left untouched.

```sh
python3 scripts/migrate-interior.py /path/to/export
# After reviewing the dry-run:
python3 scripts/migrate-interior.py /path/to/export --write
```

Write mode creates a `.pcf.bak` for each changed file and refuses to overwrite an existing backup. Do not upload `.bak` files into the CMS. Review diffs before importing. A dry-run against this checkout identified 118 PCFs; none of those pages were rewritten during this implementation.

Avoid a blanket multiline find/replace of the entire property block: it can reset selections or remove page-specific properties. The helper is idempotent and tested against the current exported PCFs.

## Review before site-wide publish

Check one page in each layout, both breadcrumb settings, each media mode, and both sides of 992px. Verify CMS Edit buttons after the sidebar moves, real parent navigation links, deep submenu expansion and keyboard controls. Shared server-only Modern Campus imports are unavailable locally, so CMS preview is the final integration check. Figma references: Presentation `5710:4142`, Sidebar `5710:4144`, Sidebar Nav Interior `5586:808`, Mobile Toggler `5644:4478`, Breadcrumb `5591:924`. Breadcrumb separators use CSS pseudo-element borders, as requested.

## Automated checks completed

- Shared Sass compiled successfully (existing Bootstrap/Sass deprecation warnings only).
- JavaScript syntax and XSL XML parsing passed.
- SaxonC ran 120 combinations: five stored/default layouts × four media modes × three breadcrumb settings × published/edit contexts. Modern Campus services were stubbed; the real interior stylesheet was compiled and executed.
- Migration tests checked existing selections, new-template defaults, content preservation across the 118 current PCFs, and idempotence.

Re-run migration tests with `python3 -m unittest discover -s scripts/tests -p test_interior_migration.py`. The transform check is `python3 scripts/tests/test_interior_transform.py` in a Python environment with `saxonche` installed (validation used SaxonC 12.5).

## Copy-and-paste find/replace for existing source

These are **literal text replacements, not regular expressions**, based on the Search PCF supplied. Restrict the batch to unmigrated `.pcf` files using `/_resources/xsl/interior.xsl`; exclude archives, other templates and already-migrated pages. Preview matches first. Steps that insert options/regions must run only once per file. If an opening tag differs, review that file separately rather than replacing its whole properties block.

The existing `selected="true"` values are deliberately preserved. In the supplied Search page, `two` and `slider` remain selected. The default of `one` applies to newly created pages, not migrated pages.

### 1. Add Show Breadcrumbs

Find:

```xml
<ouc:properties label="config">
```

Replace with:

```xml
<ouc:properties label="config">
    <parameter name="show-breadcrumbs" type="select" group="Everyone" prompt="Show Breadcrumbs" alt="Show or hide the breadcrumb trail.">
        <option value="true" selected="true">Show</option>
        <option value="false" selected="false">Hide</option>
    </parameter>
```

Do this only if `name="show-breadcrumbs"` is absent. Existing heading, breadcrumb text and all other properties stay where they are.

### 2. Add the Hero media option and update the property description

Find:

```xml
<parameter section="Top of Page Media" name="top-media" type="select" group="Everyone" prompt="Banner / Slider" alt="Choose between banner or slider for the top of the page media. Turn it off to hide the banner or use the snippet version.">
```

Replace with:

```xml
<parameter section="Top of Page Media" name="top-media" type="select" group="Everyone" prompt="Top of Page Media" alt="Hero creates a full-width editable region and replaces the page heading. Banner and Slider stay within the content area.">
    <option value="hero" selected="false">Hero</option>
```

This replaces only the opening tag. Leave the existing Slider, Banner and Off options, their selections, and the closing `</parameter>` intact. The Hero option appears first in the dropdown; it is not automatically selected.

### 3. Add the new layout options

Find:

```xml
<parameter section="Page Layout" name="layout" type="select" group="Everyone" prompt="Number of Columns" alt="Switch between two or three column layout.">
```

Replace with:

```xml
<parameter section="Page Layout" name="layout" type="select" group="Everyone" prompt="Number of Columns" alt="Choose a reading-width column, content with section navigation, content with navigation and additional content, or full browser width.">
    <option value="one" selected="false">1 Column</option>
    <option value="full" selected="false">Full Width</option>
```

Leave the two existing option lines and closing tag intact. Then make these two literal replacements within the layout options:

| Find | Replace |
| --- | --- |
| `>Two Column</option>` | `>2 Columns Nav</option>` |
| `>Three Column</option>` | `>2 Columns with Additional Content</option>` |

This works for both existing two-column and three-column selections without changing their `selected` attributes. The resulting order is 1 Column, Full Width, 2 Columns Nav, 2 Columns with Additional Content. You can move the Full Width line to the bottom for the same order as the new-page template; that is cosmetic and does not affect behavior.

For the supplied Search example, the final block is:

```xml
<parameter section="Page Layout" name="layout" type="select" group="Everyone" prompt="Number of Columns" alt="Choose a reading-width column, content with section navigation, content with navigation and additional content, or full browser width.">
    <option value="one" selected="false">1 Column</option>
    <option value="two" selected="true">2 Columns Nav</option>
    <option value="three" selected="false">2 Columns with Additional Content</option>
    <option value="full" selected="false">Full Width</option>
</parameter>
```

Use this complete block only for a page that currently selects `two`; do not apply it as a universal replacement to three-column pages.

### 4. Add the Hero editable region

Find:

```xml
<ouc:div label="main-content" group="Everyone" button-text="Main Content">
```

Replace with:

```xml
<ouc:div label="hero-content" group="Everyone" button-text="Hero Content">
    <ouc:editor csspath="/_resources/ou/editor/wysiwyg.css" cssmenu="/_resources/ou/editor/styles.txt" wysiwyg-class="hero-content"/>
</ouc:div>

<ouc:div label="main-content" group="Everyone" button-text="Main Content">
```

Do this only if `label="hero-content"` is absent. This inserts a sibling region before the main region; it does not replace the main region’s editor or content. In the supplied page, `<div>{{a:463418}}</div>` remains unchanged. The empty Hero region becomes editable when Hero is selected in page properties.

### 5. Rename the Additional Content edit button

Find:

```xml
<ouc:div label="right-content" group="Everyone" button-text="Right Column Content">
```

Replace with:

```xml
<ouc:div label="right-content" group="Everyone" button-text="Additional Content">
```

Keep `label="right-content"`, its editor settings and everything inside the region unchanged.

### 6. Check and publish

- Confirm exactly one selected option in each of `layout`, `top-media`, and `show-breadcrumbs`.
- Confirm only one `hero-content` region and one `show-breadcrumbs` parameter.
- Compare the original and changed source: main content, assets, metadata, gallery, scripts and additional content must be unchanged.
- Deploy the supporting XSL/CSS/JS listed above, preview representative pages in Modern Campus, then republish affected pages.
- No `_nav.inc` source replacements are needed for these changes.

For differently formatted property tags or mixed migrated/unmigrated batches, use the dry-run helper above instead of widening these literal searches.
