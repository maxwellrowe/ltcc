/* Reusable migrated components. Requires Bootstrap/Swiper only for their controls. */
(() => {
  'use strict';
  const reduced = matchMedia('(prefers-reduced-motion: reduce)');
  const filters = new WeakSet();
  const sliders = new WeakSet();
  const matched = new Set();
  let queued = false;
  const select = (root, selector) => [...(root.matches?.(selector) ? [root] : []), ...root.querySelectorAll(selector)];

  // Compatibility for existing match-height-* classes, scoped to each row/slider.
  // New markup can use Bootstrap h-100 / flex utilities instead.
  function measureHeights() {
    queued = false;
    const groups = new Map();
    for (const item of matched) {
      if (!item.isConnected) { matched.delete(item); continue; }
      item.style.minHeight = item.dataset.ltccOriginalMinHeight;
      if (!item.getClientRects().length) continue;
      const scope = item.closest('.swiper-wrapper, .row') || item.parentElement;
      if (!groups.has(scope)) groups.set(scope, []);
      groups.get(scope).push(item);
    }
    for (const items of groups.values()) {
      const rows = new Map();
      for (const item of items) {
        const key = item.classList.contains('match-height-all') ? 'all' : Math.round(item.getBoundingClientRect().top / 2) * 2;
        if (!rows.has(key)) rows.set(key, []);
        rows.get(key).push(item);
      }
      for (const row of rows.values()) {
        const height = Math.max(...row.map(item => item.getBoundingClientRect().height));
        row.forEach(item => { item.style.minHeight = `${height}px`; });
      }
    }
  }
  function scheduleHeights() { if (!queued) { queued = true; requestAnimationFrame(measureHeights); } }

  function initHeroes(root) {
    select(root, '.ltcc-hero-swiper').forEach(element => {
      if (sliders.has(element) || element.swiper || !window.Swiper) return;
      const controls = element.querySelector('.ltcc-hero__controls');
      const pause = controls.querySelector('[data-hero-pause]');
      const icon = pause.querySelector('span');
      let paused = reduced.matches, visible = true, hovering = false, focused = false;
      const swiper = new Swiper(element, {
        slidesPerView: 1, spaceBetween: 0, rewind: true,
        speed: reduced.matches ? 0 : 600,
        autoplay: { delay: 5000, disableOnInteraction: false },
        navigation: { prevEl: controls.querySelector('[data-hero-prev]'), nextEl: controls.querySelector('[data-hero-next]') },
        a11y: { enabled: true, containerRoleDescriptionMessage: 'Image slideshow' },
      });
      sliders.add(element);
      controls.hidden = false;
      const sync = () => {
        if (paused || !visible || hovering || focused || document.hidden) swiper.autoplay.stop();
        else if (!swiper.autoplay.running) swiper.autoplay.start();
        pause.setAttribute('aria-label', paused ? 'Play slideshow' : 'Pause slideshow');
        pause.setAttribute('aria-pressed', String(paused));
        icon.classList.toggle('fa-circle-play', paused);
        icon.classList.toggle('fa-circle-pause', !paused);
      };
      pause.addEventListener('click', () => { paused = !paused; hovering = false; focused = false; sync(); });
      element.addEventListener('mouseenter', () => { hovering = true; sync(); });
      element.addEventListener('mouseleave', () => { hovering = false; sync(); });
      element.addEventListener('focusin', event => { focused = event.target !== pause; sync(); });
      element.addEventListener('focusout', event => { if (!element.contains(event.relatedTarget)) { focused = false; sync(); } });
      document.addEventListener('visibilitychange', sync);
      reduced.addEventListener('change', () => { paused = reduced.matches; swiper.params.speed = reduced.matches ? 0 : 600; sync(); });
      if ('IntersectionObserver' in window) new IntersectionObserver(entries => { visible = entries[0].isIntersecting; sync(); }, { threshold: .1 }).observe(element);
      sync();
    });
  }

  function init(root = document) {
    select(root, '.match-height-row, .match-height-all').forEach(item => {
      if (!matched.has(item)) item.dataset.ltccOriginalMinHeight = item.style.minHeight;
      matched.add(item);
    });
    select(root, '.ltcc-profiles-filter').forEach(bar => {
      if (filters.has(bar)) return;
      // Existing PHP output places the filter immediately before its card row.
      const targetId = bar.getAttribute('aria-controls');
      const group = targetId ? document.getElementById(targetId) : bar.nextElementSibling;
      if (!group || !group.querySelector('.ltcc-card-profile-col')) return;
      filters.add(bar);
      const buttons = [...bar.querySelectorAll('button')];
      const ownsHash = bar === document.querySelector('.ltcc-profiles-filter');
      function apply(button, updateHash = false) {
        const filter = button.dataset.toggle || '';
        // Class names only: never treat an editor-provided value as a selector.
        if (filter && !/^[a-zA-Z0-9_-]+$/.test(filter)) return;
        group.querySelectorAll('.ltcc-card-profile-col').forEach(item => { item.hidden = !!filter && !item.classList.contains(filter); });
        buttons.forEach(item => { item.classList.toggle('active', item === button); item.setAttribute('aria-pressed', String(item === button)); });
        if (ownsHash && updateHash) {
          const url = new URL(location.href);
          if (filter) url.hash = filter.replace(/^type-/, '');
          else if (buttons.some(item => `#${(item.dataset.toggle || '').replace(/^type-/, '')}` === url.hash)) url.hash = '';
          history.replaceState(history.state, '', url);
        }
        window.LTCC?.animations?.init(group);
        scheduleHeights();
      }
      const fromHash = () => buttons.find(button => button.dataset.toggle && `#${button.dataset.toggle.replace(/^type-/, '')}` === location.hash);
      buttons.forEach(button => { button.type = 'button'; button.addEventListener('click', () => apply(button, true)); });
      const initial = (ownsHash && fromHash()) || buttons.find(button => button.classList.contains('active')) || buttons[0];
      if (initial) apply(initial);
      if (ownsHash) window.addEventListener('hashchange', () => { const button = fromHash() || buttons.find(button => !button.dataset.toggle); if (button) apply(button); });
    });

    select(root, '.ltcc-image-swiper, .ltcc-profile-swiper').forEach(element => {
      if (sliders.has(element) || element.swiper || !window.Swiper) return;
      sliders.add(element);
      const images = element.classList.contains('ltcc-image-swiper');
      const count = element.querySelectorAll('.swiper-wrapper > .swiper-slide').length;
      const pause = document.createElement('button');
      pause.type = 'button'; pause.className = 'btn btn-primary btn-sm ltcc-slider-pause';
      pause.setAttribute('aria-label', 'Pause slideshow'); pause.setAttribute('aria-pressed', 'false');
      pause.textContent = 'Pause slideshow'; element.append(pause);
      let paused = reduced.matches, visible = false, hovering = false, focused = false;
      const swiper = new Swiper(element, {
        slidesPerView: images ? 'auto' : 1,
        spaceBetween: 30, rewind: true, watchOverflow: true, zoom: true,
        speed: reduced.matches ? 0 : 500,
        breakpoints: images ? undefined : { 768: { slidesPerView: 2 }, 992: { slidesPerView: 3 } },
        autoplay: { delay: 4000, disableOnInteraction: false },
        navigation: { prevEl: element.querySelector('.swiper-button-prev'), nextEl: element.querySelector('.swiper-button-next') },
        a11y: { enabled: true },
      });
      const sync = () => {
        if (paused || !visible || hovering || focused || document.hidden || swiper.isLocked || count < 2) swiper.autoplay.stop();
        else swiper.autoplay.start();
        pause.hidden = swiper.isLocked || count < 2;
        pause.textContent = paused ? 'Play slideshow' : 'Pause slideshow';
        pause.setAttribute('aria-label', pause.textContent);
        pause.setAttribute('aria-pressed', String(paused));
      };
      pause.addEventListener('click', () => { paused = !paused; hovering = false; focused = false; sync(); });
      element.addEventListener('mouseenter', () => { hovering = true; sync(); });
      element.addEventListener('mouseleave', () => { hovering = false; sync(); });
      element.addEventListener('focusin', event => { focused = event.target !== pause; sync(); });
      element.addEventListener('focusout', event => { if (!element.contains(event.relatedTarget)) { focused = false; sync(); } });
      document.addEventListener('visibilitychange', sync);
      reduced.addEventListener('change', () => { paused = reduced.matches; swiper.params.speed = reduced.matches ? 0 : 500; sync(); });
      swiper.on('resize', sync);
      if ('IntersectionObserver' in window) new IntersectionObserver(entries => { visible = entries[0].isIntersecting; sync(); }, { threshold: .1 }).observe(element);
      else visible = true;
      sync();
    });
    initHeroes(root);
    scheduleHeights();
  }
  window.addEventListener('resize', scheduleHeights, { passive: true });
  document.addEventListener('load', event => { if (event.target.tagName === 'IMG') scheduleHeights(); }, true);
  document.fonts?.ready.then(scheduleHeights);
  window.LTCC = window.LTCC || {};
  window.LTCC.components = { init };
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', () => init(), { once: true });
  else init();
})();
