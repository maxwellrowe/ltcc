/* Optional reusable homepage behavior: Bootstrap Collapse + Swiper. */
(() => {
  'use strict';
  const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');
  const desktop = window.matchMedia('(min-width: 992px)');
  document.querySelectorAll('[data-hero-alert]').forEach(alert => {
    const content = alert.querySelector('.collapse');
    const toggle = alert.querySelector('[data-bs-toggle="collapse"]');
    if (!content || !toggle) return;
    const sync = () => {
      content.classList.toggle('show', desktop.matches);
      toggle.setAttribute('aria-expanded', String(desktop.matches));
    };
    sync();
    desktop.addEventListener('change', sync);
  });

  document.querySelectorAll('[data-slider]').forEach(root => {
    const kind = root.dataset.slider;
    const video = root.querySelector('.hero-video');
    const pauseButton = root.querySelector('.slider-pause');
    const previous = root.querySelector('.slider-prev');
    const next = root.querySelector('.slider-next');
    const container = root.querySelector('.swiper');
    let manuallyPaused = reducedMotion.matches;
    let focused = false;
    let hovered = false;
    let visible = true;
    let swiper;
    const videoMode = kind === 'hero' && root.dataset.heroMode === 'video' && video;
    const setPauseLabel = () => {
      pauseButton?.setAttribute('aria-pressed', String(manuallyPaused));
      pauseButton?.setAttribute('aria-label', manuallyPaused ? 'Play slideshow' : 'Pause slideshow');
      const glyph = pauseButton?.querySelector('span');
      glyph?.classList.toggle('fa-play', manuallyPaused);
      glyph?.classList.toggle('fa-pause', !manuallyPaused);
    };
    const playback = () => {
      const stopped = manuallyPaused || focused || hovered || !visible || document.hidden;
      if (videoMode) {
        if (stopped) video.pause();
        else video.play().catch(() => { manuallyPaused = true; setPauseLabel(); });
      } else if (kind !== 'news' && swiper?.autoplay) {
        if (stopped) swiper.autoplay.stop();
        else swiper.autoplay.start();
      }
    };
    if (videoMode) {
      container.hidden = true;
      video.hidden = false;
      video.querySelectorAll('source[data-src]').forEach(source => { source.src = source.dataset.src; });
      video.load();
      previous.hidden = true;
      next.hidden = true;
    } else if (typeof Swiper !== 'undefined') {
      swiper = new Swiper(container, {
        slidesPerView: ['images', 'news'].includes(kind) ? 'auto' : 1,
        spaceBetween: ['images', 'news'].includes(kind) ? 16 : 0,
        rewind: true,
        speed: reducedMotion.matches ? 0 : 650,
        effect: kind === 'hero' ? 'fade' : 'slide',
        fadeEffect: { crossFade: true },
        autoHeight: kind === 'quote',
        autoplay: kind === 'news' ? false : { delay: Number(root.dataset.autoplay) || 7000, disableOnInteraction: false },
        navigation: { prevEl: previous, nextEl: next },
        a11y: { enabled: true },
        on: {
          init(instance) { updateSlideAccess(instance); },
          slideChange(instance) { updateSlideAccess(instance); }
        }
      });
    } else {
      root.querySelector('.slider-controls')?.setAttribute('hidden', '');
      return;
    }
    function updateSlideAccess(instance) {
      if (['images', 'news'].includes(kind)) return;
      instance.slides.forEach((slide, index) => { slide.inert = index !== instance.activeIndex; });
    }
    pauseButton?.addEventListener('click', () => { manuallyPaused = !manuallyPaused; setPauseLabel(); playback(); });
    root.addEventListener('focusin', () => { focused = true; playback(); });
    root.addEventListener('focusout', event => { if (!root.contains(event.relatedTarget)) { focused = false; playback(); } });
    root.addEventListener('mouseenter', () => { hovered = true; playback(); });
    root.addEventListener('mouseleave', () => { hovered = false; playback(); });
    document.addEventListener('visibilitychange', playback);
    reducedMotion.addEventListener('change', () => { manuallyPaused = reducedMotion.matches; if (swiper) swiper.params.speed = reducedMotion.matches ? 0 : 650; setPauseLabel(); playback(); });
    new IntersectionObserver(entries => { visible = entries[0].isIntersecting; playback(); }, { threshold: .1 }).observe(root);
    setPauseLabel();
    playback();
  });
})();
