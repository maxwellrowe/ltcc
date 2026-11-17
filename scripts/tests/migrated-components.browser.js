// Inject into the migration preview for headless/browser interaction checks.
addEventListener('load', () => setTimeout(async () => {
  const checks = [];
  const check = (name, pass) => checks.push({ name, pass: !!pass });
  try {
    const a = document.getElementById('images-a');
    const b = document.getElementById('images-b');
    const profile = document.getElementById('profiles-carousel');
    check('all three Swipers initialized', a.swiper && b.swiper && profile.swiper);
    for (const root of [a,b,profile]) { root.swiper.params.speed = 0; root.swiper.autoplay.stop(); }
    a.querySelector('.swiper-button-next').click();
    check('next affects only its image carousel', a.swiper.activeIndex === 1 && b.swiper.activeIndex === 0);
    a.querySelector('.swiper-button-prev').click();
    check('previous returns to first image', a.swiper.activeIndex === 0);
    const bar = document.querySelector('#profiles .ltcc-profiles-filter');
    bar.querySelector('[data-toggle="type-alumni"]').click();
    check('filter hides other categories', document.querySelectorAll('#profiles .ltcc-card-profile-col[hidden]').length === 1);
    check('second profile group unaffected', document.querySelectorAll('#profiles-second .ltcc-card-profile-col[hidden]').length === 0);
    check('filter sets pressed state', bar.querySelector('[data-toggle="type-alumni"]').getAttribute('aria-pressed') === 'true');
    check('legacy deep link retained', location.hash === '#alumni');
    bar.querySelector('button').click();
    check('all restores cards', document.querySelectorAll('#profiles .ltcc-card-profile-col[hidden]').length === 0);
    check('modal moved to body', document.getElementById('demo-profile-1').parentElement === document.body);
    document.querySelector('[data-bs-target="#demo-profile-1"]').click();
    await new Promise(resolve => setTimeout(resolve, 500));
    check('Bootstrap profile modal opens', document.getElementById('demo-profile-1').classList.contains('show'));
    const portrait = document.querySelector('#demo-profile-1 .ltcc-card-profile-modal-image').getBoundingClientRect();
    check('visible modal portrait remains square', portrait.width > 0 && Math.abs(portrait.width - portrait.height) < 1);
    document.querySelector('#demo-profile-1 .btn-close').click();
    await new Promise(resolve => setTimeout(resolve, 500));
    check('Bootstrap profile modal closes', !document.getElementById('demo-profile-1').classList.contains('show'));
    const before = document.querySelectorAll('.ltcc-slider-pause').length;
    LTCC.init(); LTCC.components.init();
    check('reinitialization does not duplicate controls', before === 3 && document.querySelectorAll('.ltcc-slider-pause').length === 3);
    const heights = [...document.querySelectorAll('#profiles .match-height-all')].map(el=>el.getBoundingClientRect().height);
    check('legacy match-height-all equalizes card content', Math.max(...heights) - Math.min(...heights) < 1);
    const pause = a.querySelector('.ltcc-slider-pause');
    const wasPaused = pause.getAttribute('aria-pressed') === 'true';
    pause.click();
    check('pause button toggles state', pause.getAttribute('aria-pressed') === String(!wasPaused));
    if (!wasPaused) check('pause stops automatic advancement', !a.swiper.autoplay.running);
    check('image slides retain automatic widths', a.swiper.params.slidesPerView === 'auto');
    check('no horizontal page overflow', document.documentElement.scrollWidth <= innerWidth);
    check('profile breakpoint respected', profile.swiper.params.slidesPerView === (innerWidth >= 992 ? 3 : innerWidth >= 768 ? 2 : 1));
  } catch(error) { checks.push({ name: error.stack, pass:false }); }
  const pre = document.createElement('pre'); pre.id='test-results'; pre.textContent=JSON.stringify({width:innerWidth,checks,pass:checks.every(c=>c.pass)},null,2); document.body.prepend(pre);
}, 500));
