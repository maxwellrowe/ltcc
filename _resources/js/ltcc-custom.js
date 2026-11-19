/* LTCC theme behavior. Bootstrap 5 must be available by DOM readiness for its controls. */
(() => {
  "use strict";

  // Replace the legacy Modernizr class switch before the page renders.
  document.documentElement.classList.remove("no-js");
  document.documentElement.classList.add("js");

  // Bootstrap modals work best as direct children of body, outside layout wrappers.
  function moveModalsToBody(root = document) {
    if (!document.body) return;
    const modals = root instanceof Element && root.matches(".modal")
      ? [root, ...root.querySelectorAll(".modal")]
      : root.querySelectorAll(".modal");
    modals.forEach((modal) => {
      if (modal.parentElement !== document.body) {
        document.body.appendChild(modal);
      }
    });
  }

  function initScrollHeader(root) {
    root.querySelectorAll('.primary-header').forEach((header) => {
      if (header.dataset.scrollInitialized) return;
      header.dataset.scrollInitialized = 'true';
      const slot = document.createElement('div');
      header.before(slot);
      slot.append(header);
      const desktop = window.matchMedia('(min-width: 992px)');
      let previousY = Math.max(0, window.scrollY);
      let directionY = previousY;
      let direction = 0;
      let queued = false;

      function measure() {
        slot.style.height = desktop.matches ? `${header.offsetHeight}px` : '';
      }

      function update() {
        queued = false;
        const y = Math.max(0, window.scrollY);
        const delta = y - previousY;
        const nextDirection = Math.sign(delta);
        if (nextDirection && nextDirection !== direction) {
          direction = nextDirection;
          directionY = previousY;
        }
        const wasFixed = header.classList.contains('is-scroll-fixed');
        const slotBounds = slot.getBoundingClientRect();
        // Enter fixed mode after the header leaves the viewport; release only
        // when its original top meets the fixed top, avoiding a vertical jump.
        const pastHeader = desktop.matches && (wasFixed ? slotBounds.top <= 0 : slotBounds.bottom <= 0);
        header.classList.toggle('is-scroll-fixed', pastHeader);
        if (!pastHeader) {
          header.classList.remove('is-scroll-visible', 'is-scroll-ready');
          header.inert = false;
        } else {
          if (!wasFixed) {
            header.classList.remove('is-scroll-visible', 'is-scroll-ready');
            // Commit the offscreen fixed position before enabling transitions.
            // This layout read occurs only when crossing into fixed mode.
            header.getBoundingClientRect();
            header.classList.add('is-scroll-ready');
          }
          const interacting = header.contains(document.activeElement) || header.querySelector('.dropdown-menu.show');
          if (interacting) {
            header.classList.add('is-scroll-visible');
          } else if (Math.abs(y - directionY) >= 8) {
            header.classList.toggle('is-scroll-visible', direction < 0);
          } else if (!wasFixed) {
            header.classList.remove('is-scroll-visible');
          }
          header.inert = !header.classList.contains('is-scroll-visible');
        }
        previousY = y;
      }

      function schedule() {
        if (queued) return;
        queued = true;
        window.requestAnimationFrame(update);
      }

      window.addEventListener('scroll', schedule, { passive: true });
      window.addEventListener('resize', () => { measure(); schedule(); });
      desktop.addEventListener('change', () => { measure(); schedule(); });
      header.addEventListener('focusout', schedule);
      header.addEventListener('hidden.bs.dropdown', schedule);
      new ResizeObserver(() => { measure(); schedule(); }).observe(header);
      measure();
      update();
    });
  }

  function initMobileNavigation(root) {
    const menu = root.querySelector('#primary-navigation');
    if (!menu || menu.dataset.mobileInitialized) return;
    menu.dataset.mobileInitialized = 'true';
    // Reverse the mobile copy in the DOM so keyboard order matches visual order.
    menu.querySelectorAll('.navbar-utility .navbar-nav').forEach(list => {
      [...list.children].reverse().forEach(item => list.append(item));
    });
    const desktop = window.matchMedia('(min-width: 992px)');
    const header = menu.closest('.site-header');
    let saved = null;
    let open = menu.classList.contains('show');
    function sizeMenu() {
      if (!saved) return;
      const top = Math.max(0, header.getBoundingClientRect().bottom);
      menu.style.setProperty('--mobile-menu-top', `${top}px`);
    }
    function sync() {
      if (open && !desktop.matches) {
        if (!saved) {
          const body = document.body;
          saved = { x: window.scrollX, y: window.scrollY, styles: {} };
          ['position', 'top', 'left', 'width', 'overflow'].forEach(name => {
            saved.styles[name] = [body.style.getPropertyValue(name), body.style.getPropertyPriority(name)];
          });
          body.style.position = 'fixed';
          body.style.top = `${-saved.y}px`;
          body.style.left = `${-saved.x}px`;
          body.style.width = '100%';
          body.style.overflow = 'hidden';
          menu.classList.add('is-mobile-scrollable');
        }
        sizeMenu();
      } else if (saved) {
        const previous = saved;
        saved = null;
        Object.entries(previous.styles).forEach(([name, [value, priority]]) => {
          if (value) document.body.style.setProperty(name, value, priority);
          else document.body.style.removeProperty(name);
        });
        menu.classList.remove('is-mobile-scrollable');
        menu.style.removeProperty('--mobile-menu-top');
        window.scrollTo({ left: previous.x, top: previous.y, behavior: 'instant' });
      }
    }
    menu.addEventListener('show.bs.collapse', event => {
      if (event.target !== menu) return;
      open = true;
      sync();
    });
    menu.addEventListener('hidden.bs.collapse', event => {
      if (event.target !== menu) return;
      open = false;
      sync();
    });
    desktop.addEventListener('change', sync);
    window.addEventListener('resize', sizeMenu);
    window.visualViewport?.addEventListener('resize', sizeMenu);
    sync();
  }

  // Use native Dropdown on desktop and Collapse for inline mobile panels.
  function initPrimaryMenus(root) {
    root.querySelectorAll('[data-primary-menu]').forEach((trigger) => {
      if (trigger.dataset.primaryMenuInitialized) return;
      const panel = document.getElementById(trigger.getAttribute('aria-controls'));
      if (!panel) return;
      trigger.dataset.primaryMenuInitialized = 'true';
      const desktop = window.matchMedia('(min-width: 992px)');
      let currentMode;
      function sync() {
        if (currentMode === desktop.matches || panel.classList.contains('collapsing')) return;
        const dropdown = window.bootstrap.Dropdown.getInstance(trigger);
        if (dropdown) { dropdown.hide(); dropdown.dispose(); }
        window.bootstrap.Collapse.getInstance(panel)?.dispose();
        panel.classList.remove('show');
        panel.style.removeProperty('height');
        trigger.classList.remove('show');
        trigger.setAttribute('aria-expanded', 'false');
        panel.classList.toggle('dropdown-menu', desktop.matches);
        panel.classList.toggle('collapse', !desktop.matches);
        trigger.classList.toggle('collapsed', !desktop.matches);
        trigger.setAttribute('data-bs-toggle', desktop.matches ? 'dropdown' : 'collapse');
        currentMode = desktop.matches;
      }
      desktop.addEventListener('change', sync);
      // A breakpoint change during a collapse waits for Bootstrap to finish.
      panel.addEventListener('shown.bs.collapse', sync);
      panel.addEventListener('hidden.bs.collapse', sync);
      sync();
    });
  }

  function initTranslationModal() {
    const modal = document.getElementById('site-translation');
    if (!modal || modal.dataset.translationInitialized) return;
    modal.dataset.translationInitialized = 'true';
    const widget = modal.querySelector('#google_translate_element');
    const status = modal.querySelector('[data-translation-status]');
    let closeWhenShown = false;
    let loadingTimer;
    function prepareSelect() {
      const select = widget.querySelector('.goog-te-combo');
      if (!select) return;
      select.id = 'site-translation-language';
      select.classList.add('form-select', 'mb-3');
      if (status) status.hidden = true;
      clearTimeout(loadingTimer);
    }
    new MutationObserver(prepareSelect).observe(widget, { childList: true, subtree: true });
    prepareSelect();
    modal.addEventListener('shown.bs.modal', () => {
      if (closeWhenShown) {
        closeWhenShown = false;
        window.bootstrap.Modal.getInstance(modal)?.hide();
        return;
      }
      prepareSelect();
      widget.querySelector('.goog-te-combo')?.focus();
      if (!widget.querySelector('.goog-te-combo')) {
        clearTimeout(loadingTimer);
        loadingTimer = setTimeout(() => {
          if (status && !widget.querySelector('.goog-te-combo')) status.textContent = 'Google Translate could not load. Please close this window and try again.';
        }, 10000);
      }
    });
    modal.addEventListener('hidden.bs.modal', () => { clearTimeout(loadingTimer); closeWhenShown = false; });
    modal.addEventListener('change', event => {
      if (!event.target.matches('.goog-te-combo') || !event.target.value) return;
      // Let Google's change handler finish before closing the dialog.
      setTimeout(() => {
        const instance = window.bootstrap.Modal.getInstance(modal);
        instance?.hide();
        // Bootstrap ignores hide() during its opening transition.
        closeWhenShown = modal.classList.contains('show');
      }, 0);
    });
  }

  // Tooltips and popovers are opt-in; other data-bs-* controls use Bootstrap's data API.
  // This is safe to call again after inserting CMS content dynamically.
  function init(root = document) {
    moveModalsToBody(root);
    window.LTCC?.components?.init(root);
    initScrollHeader(root);
    if (!window.bootstrap) {
      // Legacy pages do not yet load Bootstrap 5; the class switch still applies.
      return;
    }
    initTranslationModal();
    initPrimaryMenus(root);
    initMobileNavigation(root);
    root.querySelectorAll('[data-bs-toggle="tooltip"]').forEach((element) => {
      window.bootstrap.Tooltip.getOrCreateInstance(element);
    });
    root.querySelectorAll('[data-bs-toggle="popover"]').forEach((element) => {
      window.bootstrap.Popover.getOrCreateInstance(element);
    });
    root.querySelectorAll('[data-ltcc-toggle="toast"]').forEach((trigger) => {
      if (trigger.dataset.ltccInitialized) return;
      const target = document.getElementById(trigger.getAttribute("data-ltcc-target"));
      if (!target) return;
      trigger.addEventListener("click", () => window.bootstrap.Toast.getOrCreateInstance(target).show());
      trigger.dataset.ltccInitialized = "true";
    });
  }

  window.LTCC = window.LTCC || {};
  window.LTCC.init = init;
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", () => init(), { once: true });
  } else {
    init();
  }
})();
