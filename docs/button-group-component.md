# Button Group component

Create `component-button-group` with these fields. Labels can be friendly; stored values must match the values below.

| Field class | Choices / values | Default |
| --- | --- | --- |
| `layout` | Horizontal: `horizontal`; Vertical: `vertical` | `horizontal` |
| `horizontal-alignment` | Left: `left`; Center: `center`; Right: `right` | `left` |
| `vertical-alignment` | Top: `top`; Center: `center`; Bottom: `bottom` | `top` |
| `buttons` | Repeat the child `ul` for each button | — |
| `text` | Button Text | Required |
| `url` | Button URL (plain URL or anchor) | Required |
| `size` | Small: `btn-sm`; Normal: blank; Large: `btn-lg` | Normal |
| `style` | Bootstrap `btn-primary`, `btn-secondary`, etc., or `btn-outline-*` | `btn-primary` |

Supported styles: primary, secondary, success, danger, warning, info, light, dark, their outline variants, and `btn-link`. Invalid styles fall back to `btn-primary`; invalid sizes use normal sizing. Layout/alignment values are case-insensitive. Incomplete buttons are omitted, and an empty group produces no output.

```html
<ouc:component name="component-button-group">
  <ul>
    <li class="layout">horizontal</li>
    <li class="horizontal-alignment">left</li>
    <li class="vertical-alignment">center</li>
    <li class="buttons">
      <ul>
        <li class="text">Apply Now</li>
        <li class="url">/apply/</li>
        <li class="size">btn-lg</li>
        <li class="style">btn-primary</li>
      </ul>
      <ul>
        <li class="text">Learn More</li>
        <li class="url">/academics/</li>
        <li class="size">btn-lg</li>
        <li class="style">btn-outline-secondary</li>
      </ul>
    </li>
  </ul>
</ouc:component>
```

Horizontal layout maps horizontal alignment to `justify-content-*` and vertical alignment to `align-items-*`. Vertical layout reverses that mapping. Horizontal groups wrap on narrow screens. Both use `gap-2`, `list-unstyled`, and `mb-0`; anchors have only the selected button classes. No custom CSS, JS, or extra output wrappers are required.

Vertical Center/Bottom justification needs spare height in the list to have a visible effect; the component does not impose a fixed height. Existing spacing/animation wrappers can surround the component as needed.

Deploy `_resources/xsl/_shared/components.xsl` and republish pages using this component. Test with `scripts/tests/test_button_group_transform.py` in the SaxonC Python environment.
