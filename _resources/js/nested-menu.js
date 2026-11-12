/* Bootstrap section navigation; preserve one editable sidebar across breakpoints. */
document.addEventListener('DOMContentLoaded', () => {
  const sidebar = document.querySelector('[data-interior-sidebar]');
  const desktopSlot = document.querySelector('[data-sidebar-desktop-slot]');
  const mobileSlot = document.querySelector('[data-sidebar-mobile-slot]');
  if (sidebar && desktopSlot && mobileSlot) {
    const desktop = window.matchMedia('(min-width: 992px)');
    const relocate = () => (desktop.matches ? desktopSlot : mobileSlot).append(sidebar);
    relocate();
    desktop.addEventListener('change', relocate);
  }
  let sequence = 0;
  const normalizePath = href => {
    try {
      const url = new URL(href, window.location.href);
      if (url.origin !== window.location.origin) return null;
      return url.pathname.replace(/\/(index|default)\.(php|html?|pcf)$/i, '').replace(/\/+$/, '') || '/';
    } catch { return null; }
  };
  document.querySelectorAll('.sidenav').forEach(sidenav => {
    if (sidenav.classList.contains('is-ready')) return;
    const wrapItems = container => {
      let wrapper;
      [...container.children].forEach(child => {
        if (child.tagName === 'LI') {
          if (!wrapper) { wrapper = document.createElement('ul'); container.insertBefore(wrapper, child); }
          wrapper.append(child);
        } else wrapper = null;
      });
    };
    wrapItems(sidenav);
    sidenav.querySelectorAll('li').forEach(wrapItems);
    const currentPath = normalizePath(window.location.href);
    sidenav.querySelectorAll('a[href]').forEach(link => {
      const href = link.getAttribute('href');
      if (!href || href.startsWith('#') || /^javascript:/i.test(href) || normalizePath(href) !== currentPath) return;
      link.classList.add('current');
      link.setAttribute('aria-current', 'page');
      link.closest('li')?.classList.add('current');
      let ancestor = link.closest('li')?.parentElement.closest('li');
      while (ancestor && sidenav.contains(ancestor)) { ancestor.classList.add('active'); ancestor = ancestor.parentElement.closest('li'); }
    });
    // Leave every list readable if Bootstrap is unavailable.
    if (!window.bootstrap?.Collapse) return;
    sidenav.querySelectorAll('li').forEach(li => {
      const list = li.querySelector(':scope > ul');
      const link = li.querySelector(':scope > a');
      if (!list || !link) return;
      li.classList.add('has-children');
      if (!list.id) { do { list.id = `section-submenu-${++sequence}`; } while (document.querySelectorAll(`[id="${list.id}"]`).length > 1); }
      const expanded = li.classList.contains('active') || li.classList.contains('current');
      list.classList.add('collapse');
      list.classList.toggle('show', expanded);
      const toggle = document.createElement('button');
      toggle.type = 'button'; toggle.className = 'btn sidenav-child-toggle';
      toggle.setAttribute('aria-label', `Toggle ${link.textContent.trim()} submenu`);
      toggle.setAttribute('aria-expanded', String(expanded));
      toggle.setAttribute('aria-controls', list.id);
      li.insertBefore(toggle, list);
      const collapse = bootstrap.Collapse.getOrCreateInstance(list, { toggle: false });
      toggle.addEventListener('click', () => collapse.toggle());
      // Placeholder parent links retain their existing click-to-toggle behavior.
      if (!link.getAttribute('href') || link.getAttribute('href') === '#') {
        link.setAttribute('role', 'button'); link.setAttribute('aria-controls', list.id); link.setAttribute('aria-expanded', String(expanded));
        link.addEventListener('click', event => { event.preventDefault(); collapse.toggle(); });
        link.addEventListener('keydown', event => { if (event.key === ' ') { event.preventDefault(); collapse.toggle(); } });
      }
      ['show', 'hide'].forEach(action => list.addEventListener(`${action}.bs.collapse`, event => {
        if (event.target !== list) return;
        const open = action === 'show';
        toggle.setAttribute('aria-expanded', String(open));
        if (link.getAttribute('role') === 'button') link.setAttribute('aria-expanded', String(open));
        li.classList.toggle('active', open);
      }));
    });
    sidenav.classList.add('is-ready');
  });
});
