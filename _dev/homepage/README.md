# LTCC homepage prototype

Static HTML based on LTCC Design: desktop **Homepage - Find Your Path 4** (`6951:12664`) and mobile **Home - Find Your Path 2** (`6889:21155`).

## Preview and build

From the repository root (`ltcc/ltcc`):

```sh
npm run build:homepage
python3 -m http.server 8765 --bind 127.0.0.1
```

Open http://127.0.0.1:8765/_dev/homepage/. Stop the server with Ctrl+C.
The normal `npm run build` also compiles the optional homepage stylesheet. `npm run build:css` continues to build the shared site theme only.

The page uses existing Bootstrap 5.3.8 theme CSS, Font Awesome, shared header JS, and Swiper 12.2.0 (the version already used in shared includes). The homepage CSS/JS are optional additions and are not loaded by current published pages. Keep the `ltcc-homepage` body class while using this scoped stylesheet.

## Future Modern Campus fields

- **Hero:** `data-hero-mode="images"` displays the `.swiper-slide` image list. Set it to `video` to use `.hero-video`; edit its source `data-src` and poster. The existing local campus video is an example, is ignored by Git, and must be published separately. Keep the pause control. Hero text and CTA remain real HTML over either media type.
- **Hero alert:** add `hidden` to `[data-hero-alert]` to turn off, or omit it from the XSL output. Title, description and CTA are separate elements. Bootstrap Collapse starts open at lg (992px), closed below it; resizing across lg resets to the breakpoint default. Below lg the alert is fixed bottom-right and hidden while the mobile menu/search is open. Use unique IDs for additional instances.
- **Card Link:** `<a class="card card-link">` wraps the entire card. For a nonlinked card use `<article class="card card-link">` with identical image/body markup and omit `.card-link-arrow`. Do not nest other links inside a linked card.
- **Support card:** `.card.card-support` holds an icon, heading, description and optional separate arrow link. Ordinary Bootstrap `.card`, `.card-img-top`, `.card-body` remain the baseline card building blocks.
- **Quote carousel:** each `.swiper-slide` contains a figure. With an image use the Bootstrap row and columns shown. Without an image omit its column and use the full-width figure in the second example. Attribution is a figcaption. Replace placeholder quotes before publication.
- **Image slider:** repeat `.swiper-slide` with an image. Height comes from `--image-slider-height` (24.375rem desktop, 12rem mobile); widths follow each image's intrinsic aspect ratio. Override that custom property on an instance for another height.
- **News:** repeat the news card slides from a feed later. This Swiper is manually controlled; it does not autoplay.
- **Events:** repeat Bootstrap grid columns/cards from a feed later.
- `data-autoplay` is the interval in milliseconds. Hero and campus video use a shared circular pause/play control; automatic motion pauses offscreen and in hidden tabs. Other automatic sliders also pause on hover and keyboard focus; reduced-motion preferences disable autoplay initially. Users can explicitly start it with the play control.

The header duplicates the existing include markup for this standalone preview and has simplified example mega-menu content. Replace the prototype header/footer with the published shared includes when integrating. News/events dates and statistics are Figma examples, not verified current institutional data. Destination links are representative section links; wire approved destinations and article links in the CMS. No feeds or CMS templates have been changed.

## Assets and validation

Images were downloaded from the requested Figma frames; photographs are proportionally resized JPEG exports for web loading, with the artwork and SVGs preserved. Their originals are retained locally in `/tmp/ltcc-figma-homepage-originals` during this session. The new assets coexist with older homepage assets already in this directory.

Validated Sass compilation, JavaScript syntax, local asset existence, unique HTML IDs and Bootstrap target references. Browser automation was unavailable/stalled, so desktop/mobile visual parity and live interactions still need a browser review. Check 390px, 768px, 992px and 1440px widths, menu scroll lock, alert toggle, each slider, reduced motion and video mode before publishing.

## Playback updates

The hero advances automatically and has only a pause/play control. The campus film uses muted, inline, looping playback, started by the component script when visible; its matching button pauses/resumes playback. Reduced-motion preferences start both paused. The campus film remains hidden below lg as in the existing mobile composition.

`theme/_media-controls.scss` defines the reusable `.media-playback-toggle` using Bootstrap button variables.
