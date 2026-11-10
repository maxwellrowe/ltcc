# MKT Link List

`ouc:component[@name="component-link-list"]` is transformed by `_shared/components.xsl`, in the default mode and when nested in another component.

The outer `ul` supplies `li.color` (`dark` or `light`) and `li.size` (a Bootstrap class such as `fs-7`). Each direct child `ul` inside `li.icons` is one link. Its settings are `li.text`, `li.link`, `li.icon`, and `li.style`.

- `default`: text only.
- `before`: supplied Font Awesome icon before the text.
- `after`: supplied Font Awesome icon after the text.
- `arrow`: existing arrow-link styling; ignores the supplied icon.

Missing or unknown styles use text only. Color defaults to dark. An empty size inherits the normal link size. Rows missing text or a destination are omitted. Link fields accept a URL as text or an anchor whose href supplies the destination; other source anchor attributes are not copied.

Before/after icons use the full supplied Font Awesome classes and are decorative because the adjacent text names the link. Dark icons use blue-700; light icons use green-200. Underlines affect text only and are 1.5px thick. Light links match the existing light arrow treatment: underline revealed on hover/focus. Arrow links retain their 1.5px bottom border. All variants provide focus outlines and respect reduced motion.

The existing outer animation/spacing wrapper can stay unchanged. No new component options or JavaScript are required. Use the standard anim-scroll-* types when animation is desired; anim-scroll-none has no effect.
