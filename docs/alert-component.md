# Alert component and global alert workflow

Create a Modern Campus component named **Alert** with this source. Replace example values with the generated CMS field variables, and keep these class names.

```html
<ouc:component name="component-alert">
  <ul>
    <li class="start">2026-12-01T08:00</li>
    <li class="end">2026-12-02T17:00</li>
    <li class="display">scheduled</li>
    <li class="style">default</li>
    <li class="dismissible">true</li>
    <li class="title">Campus Update</li>
    <li class="content"><p>Your alert message goes here.</p></li>
    <li class="button-text">Learn More</li>
    <li class="button-link">/campusresources/</li>
    <li class="icon">fa-bell</li>
  </ul>
</ouc:component>
```

| Field | Type / stored values |
| --- | --- |
| Start Date and Time (`start`) | Optional date/time: `MM/DD/YYYY h:mm AM/PM` (Modern Campus), `YYYY-MM-DDTHH:mm`, or `YYYY-MM-DD HH:mm` |
| End Date and Time (`end`) | Same format; optional |
| Display (`display`) | Show Based on Date and Time Settings: `scheduled`; Show Always: `always`; Hide: `hide` |
| Style (`style`) | Default: `default`; Info: `info`; Emergency: `emergency` |
| Dismissible (`dismissible`) | Yes: `true`; No: `false`; missing field defaults to Yes |
| Title (`title`) | Text, optional |
| Content (`content`) | WYSIWYG rich content, optional |
| Button Text (`button-text`) | Text; only shown together with a nonempty link |
| Button Link (`button-link`) | URL/link chooser; accepts plain URL or anchor markup |
| Icon (`icon`) | `fa-bell`, `fa-circle-exclamation`, `fa-circle-info`, `fa-smile`, `fa-bullhorn` |

Icons always receive `fa-sharp fa-regular`; blank/unknown icons default to bell. Default is pale blue with a blue button; Info is gray with a green button; Emergency is pale red with a green button. The named styles follow Figma node 6876:11034. Titles use blue-900, and body content gray-900. All variants use Bootstrap alert markup. Dismissible alerts use the native Bootstrap 5 close control at the top right; non-dismissible alerts omit the control and the reserved padding. Dismissal lasts for the current page view only.

## Scheduling

- If the scheduler helper is missing or unreadable, the alert is hidden and an error is logged; the rest of the page continues rendering. Publish `/_resources/php/alerts.php` to enable scheduling.
- Evaluated in PHP on each request, not when the page is published, and works without JavaScript.
- Unzoned times use **America/Los_Angeles** (Pacific time, including daylight saving time).
- ISO dates with seconds and `Z` or `±HH:mm` offsets are also accepted. Prefer explicit offsets for ambiguous fall-back DST times.
- Start is inclusive; end is exclusive. Blank start/end means no limit at that boundary. Both blank with Scheduled means always active.
- Invalid dates, nonexistent local DST times, or end at/before start keep a scheduled alert hidden.
- Show Always ignores dates. Hide, missing Display, and unknown Display values produce no published alert.
- CMS editing/preview shows a status note and alert even when hidden/future/expired; runtime visibility is tested on the published PHP page.
- An already-open page does not automatically refresh at a boundary. Server/CDN full-page caching can delay changes until the cached page expires.
- No title, content or complete button means no output.

## Global alert migration

`/_resources/includes/alert.pcf` still publishes `/_resources/includes/alert.php`. The existing page templates load that file dynamically above the header. The PCF-level Display Alert property is removed; component settings now control visibility. The local old alert content is preserved inside a **hidden** example component so migration does not activate the previously disabled message.

Create the actual CMS component and replace the example `ouc:component` in `alert.pcf` with a CMS-managed instance. Remove the old `show-alert` property from the live PCF and replace its old raw alert markup at the same time; the new XSL no longer consults that property. Do not leave old raw content there expecting the removed property to hide it.

Deploy in order:

1. `/_resources/php/alerts.php` (runtime scheduler) and `/_resources/css/ltcc-custom.css` (compiled styles).
2. `/_resources/xsl/_shared/components.xsl` and `/_resources/xsl/alert.xsl` together. The alert template now imports the shared common stack for CMS component expansion.
3. Update the live `alert.pcf` component/content and publish it to regenerate `alert.php`.

Pages already including `alert.php` do not need republishing for global-alert content changes. A component inserted directly into an ordinary page requires that page to be published; once published, its schedule runs at request time. Scheduled components require PHP output, as used by this site's templates.

Preview examples: `/_dev/bootstrap-theme/alerts.html`. Tests: `php scripts/tests/test_alerts.php` and `scripts/tests/test_alert_transform.py` in the SaxonC environment. CMS service imports are stubbed in local transform tests.
