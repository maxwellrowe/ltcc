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
