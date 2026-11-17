# Hero component

Create a Modern Campus component with source name `component-hero`. Use the existing page property **Top of Page Media → Hero**, then place it in the Hero editable region. This provides full-width output and removes the template page title. The component supplies the page's H1; use one Hero per page.

| Field | Source class | Type |
| --- | --- | --- |
| Pre-Title | `pre-title` | Optional text |
| Title | `title` | Required text (renders H1) |
| Sub Title | `subtitle` | Optional text |
| Display Calls to Action | `show-ctas` | Yes: `true`; No: `false`; defaults to Yes |
| Call to Action Label | `cta-label` | Optional text above CTA links |
| Calls to Action | `ctas` | Repeatable element group: Link URL (`link`), Link Text (`text`) |
| Images | `images` | Repeatable element group: Image (`image`), optional Alt Text (`alt`) |

The Image field accepts either an image URL or image-element output from the CMS picker. If the optional `alt` field is omitted, the transform preserves the picker's image alt text; if supplied, it takes precedence. Use empty alt text only for decorative images. Link fields accept URLs or anchor output.

Replace sample values with your generated CMS variables; repeat each inner `<ul>` per group entry:

```html
<ouc:component name="component-hero">
  <ul>
    <li class="pre-title">Find Your Path</li>
    <li class="title">Academics</li>
    <li class="subtitle">Elevated education starts here</li>
    <li class="show-ctas">true</li>
    <li class="cta-label">Explore your options</li>
    <li class="ctas">
      <ul>
        <li class="link">#programs</li>
        <li class="text">Explore Programs</li>
      </ul>
      <ul>
        <li class="link">/admissions/</li>
        <li class="text">Apply Now</li>
      </ul>
    </li>
    <li class="images">
      <ul>
        <li class="image">/_resources/images/hero-1.jpg</li>
        <li class="alt">Students learning together</li>
      </ul>
      <ul>
        <li class="image">/_resources/images/hero-2.jpg</li>
        <li class="alt">The Lake Tahoe Community College campus</li>
      </ul>
    </li>
  </ul>
</ouc:component>
```

## Behavior

- The background spans full width using `bg-blue-950`; both panels sit inside `container-xl`. Images use Bootstrap `ratio-4x3` with cover cropping, and desktop panels use equal Bootstrap columns.
- Text is left of the image at `lg` (992px) and above; image precedes text below `lg`.
- Title is 3.75rem desktop / 2.5rem mobile. The dark background uses blue-950. The photo crops to fill its panel.
- One valid image produces a static image with no controls. Two or more initialize Swiper and autoplay on load: five seconds per slide with a 600ms transition.
- Controls: Previous, Next, Pause/Play, with accessible names. Navigation is scoped per instance; repeated initialization does not duplicate controls.
- Reduced-motion users start paused with zero transition duration. Users can choose Play. Autoplay also pauses when offscreen, in a hidden tab, on hover, or while other controls have keyboard focus.
- Without JavaScript, the first image remains visible and controls stay hidden.
- Missing images produce a text-only panel. Empty image rows and incomplete CTA rows are skipped. Empty optional fields produce no empty labels.
- CTA links use the existing MKT link styling. Same-page hash links get down arrows; other URLs get right arrows. Add matching destination IDs in page content.
- `show-ctas=false` hides the entire CTA area: label, mountain mark, and links; saved CTA values remain intact.
- The optional CTA label appears only when there are valid links. The Figma mountain mark is decorative and uses a local 48×20 SVG.
- Bootstrap supplies layout, ordering, wrapping and control styles. Scoped SCSS supplies design-specific typography, panel dimensions, colors and control positioning. Swiper handles the slider; no homepage-specific styles/scripts are required.

## Deploy

Publish these assets before publishing pages with the Hero:

- `/_resources/css/ltcc-custom.css`
- `/_resources/js/ltcc-components.js`
- `/_resources/img/components/hero-mountain.svg`

Deploy `/_resources/xsl/_shared/components.xsl`, create the CMS component, then publish affected pages. Existing shared head/foot includes already load Swiper. The demo photo is for the development preview only; production images come from the component fields.

Preview: `/_dev/bootstrap-theme/hero.html` (single-image and text-only examples follow the first slider).

Validation: `scripts/tests/test_hero_transform.py` uses SaxonC with CMS globals stubbed. `scripts/tests/hero.browser.js` covers autoplay, reduced motion, controls, reinitialization, responsive placement, loaded assets and overflow. Desktop and mobile screenshots were visually checked against Figma 6157:5713.
