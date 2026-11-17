# Contact component and faculty snippet

The existing `ou-faculty-list` authoring table is unchanged. Its first column (photo) is ignored; a row now requires only a name. Existing heading-top, heading-bottom, name, title, email and website cells retain their positions. Empty/NBSP fields do not generate links. Deploy both `_shared/snippets.xsl` and `_shared/components.xsl` together, then republish affected pages.

The snippet and individual component call the same named `ltcc-contact` template in `components.xsl`.

## Modern Campus component source

Replace the example values with your generated field variables; keep the component name and class names exactly as shown. Create one contact per component, using an existing spacing/animation wrapper outside it as needed.

```html
<ouc:component name="component-contact">
  <ul>
    <li class="name">America Ramirez</li>
    <li class="title">Financial Aid Technician</li>
    <li class="email">america@ltcc.edu</li>
    <li class="website">https://www.ltcc.edu/financial-aid/</li>
  </ul>
</ouc:component>
```

- `name`: required text. An empty name suppresses the entire contact.
- `title`: optional text.
- `email`: optional email address; either a plain address or `mailto:` value works.
- `website`: optional URL/link field; a plain URL or an anchor element works.

No photo field is needed. Blank email/website values omit the corresponding circle button. Accessible names include the contact name. Website links open in the same tab.

## Complete Contact Section component

Use `component-contact-section` for optional section headings and a repeatable contact group:

```html
<ouc:component name="component-contact-section">
  <ul>
    <li class="heading-top">Business</li>
    <li class="heading-bottom">Faculty</li>
    <li class="contacts">
      <ul>
        <li class="name">John Kingsbury</li>
        <li class="title">Business Instructor</li>
        <li class="email">john@ltcc.edu</li>
        <li class="website"></li>
      </ul>
    </li>
  </ul>
</ouc:component>
```

Repeat the inner `<ul>` inside `li.contacts` for each person. Replace example values with Modern Campus field variables. Both headings are optional; with neither present, the heading and its divider are omitted. Contacts without a name are skipped, and a section with no named contacts is omitted entirely. Each contact has the same optional fields as the individual component.

The faculty snippet and section component share the `ltcc-contact-section` wrapper and `ltcc-contact` renderer, so matching data produces identical output. No new CSS or JavaScript is required for the section component.

## Appearance and deployment

Uses existing Bootstrap flex, spacing and button utilities, with scoped SCSS for 20px names, 12px titles, 50px circle buttons, the section heading, and a 1.5px dashed gray-500 contact divider. The divider uses a CSS border and requires no SVG. On small screens the divider is hidden and long names/buttons can wrap. Background color is inherited so the component can be used in different containers.

Publish `/_resources/css/ltcc-custom.css` along with the XSL changes. No JavaScript changes are needed. Preview at `/_dev/bootstrap-theme/contact.html` through the local development server.

Validation: `scripts/tests/test_contact_transform.py` (SaxonC) covers actual existing snippet input, rows without photos, optional fields/NBSP, accessible link labels, and identical component/snippet output. Desktop and narrow-screen Chrome checks cover sizing, icons, divider styling, and overflow.
