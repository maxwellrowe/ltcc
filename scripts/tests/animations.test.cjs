const { test } = require('node:test');
const assert = require('node:assert/strict');
const vm = require('node:vm');
const fs = require('node:fs');
const path = require('node:path');
const source = fs.readFileSync(path.join(__dirname, '../../_resources/js/ltcc-animations.js'), 'utf8');
function element(attrs = {}, classes = [], top = 1000) {
  const list = new Set(classes);
  list.contains = list.has.bind(list); list.remove = list.delete.bind(list);
  return { classList: list, style: { opacity: '', transform: '', clipPath: '' },
    getAttribute: name => attrs[name] ?? null,
    getClientRects: () => [{ top }],
    getBoundingClientRect: () => ({ top, bottom: top + 100 }),
    querySelectorAll: () => [], matches: () => true };
}
function setup(elements, options = {}) {
  const observed = new Map(), calls = [], finishes = [];
  const reduced = { matches: !!options.reduced, addEventListener() {} };
  const window = { innerHeight: 800, IntersectionObserver: function() {}, matchMedia: () => reduced };
  if (!options.noMotion) window.Motion = {
    inView(el, callback) { if (options.observerFailure) throw Error('observer failure'); observed.set(el, callback); },
    animate(el, preset, timing) {
      if (options.animationFailure) throw Error('animation failure');
      calls.push({ el, preset, timing });
      return { then(callback) { finishes.push(callback); }, complete() {} };
    }
  };
  const document = { readyState: 'complete', documentElement: { classList: new Set() }, querySelectorAll: () => elements };
  document.documentElement.classList.contains = () => false;
  vm.runInNewContext(source, { window, document, console: { warn() {} } });
  return { observed, calls, finishes, window };
}
for (const [name, y] of [['fade', undefined], ['fade-up', 24], ['fade-down', -24]]) {
  test(`legacy ${name} reveals once with timing and restores inline styles`, () => {
    const el = element({ 'data-aos': name, 'data-aos-duration': '800', 'data-aos-delay': ' 200ms ' });
    el.style.opacity = '.8';
    const run = setup([el]); assert.ok(el.classList.has('anim-pending'));
    run.observed.get(el)();
    assert.equal(run.calls[0].preset.y?.[0], y);
    assert.equal(run.calls[0].timing.duration, .8); assert.equal(run.calls[0].timing.delay, .2);
    run.finishes[0](); assert.equal(el.style.opacity, '.8'); assert.ok(!el.classList.has('anim-pending'));
    run.window.LTCC.animations.init(); run.observed.get(el)(); assert.equal(run.calls.length, 1);
  });
}
test('new classes override legacy preset and each timing setting', () => {
  const el = element({ 'data-aos': 'fade-down', 'data-aos-duration': '900', 'data-aos-delay': '300' }, ['anim-scroll-fade-up','anim-duration-400','anim-delay-0']);
  const run = setup([el]); run.observed.get(el)();
  assert.equal(run.calls[0].preset.y[0], 24); assert.equal(run.calls[0].timing.duration, .4); assert.equal(run.calls[0].timing.delay, 0);
});
test('invalid legacy names, placeholders and explicit none are never hidden', () => {
  const elements = [element({ 'data-aos':'zoom-in' }), element({ 'data-aos':'[[example]]' }), element({ 'data-aos':'fade' }, ['anim-scroll-none']), element({ 'data-aos':'fade' }, ['anim-scroll-unknown'])];
  const run = setup(elements); assert.equal(run.observed.size, 0);
  for (const el of elements) assert.ok(!el.classList.has('anim-pending'));
});
test('invalid text timings use 600ms duration and zero delay', () => {
  for (const value of ['', '-100', '0.5s', '[[placeholder]]', 'Infinity', '600garbage']) {
    const el = element({ 'data-aos':'fade', 'data-aos-duration':value, 'data-aos-delay':value });
    const run = setup([el]); run.observed.get(el)(); assert.equal(run.calls[0].timing.duration, .6); assert.equal(run.calls[0].timing.delay, 0);
  }
});
test('zero duration is valid and root-element initialization works', () => {
  const el = element({ 'data-aos':'fade', 'data-aos-duration':'0' });
  const run = setup([]); run.window.LTCC.animations.init(el); run.observed.get(el)(); assert.equal(run.calls[0].timing.duration, 0);
});
test('visible content, reduced motion and dependency failures stay readable', () => {
  for (const options of [{ reduced:true }, { noMotion:true }, { observerFailure:true }]) {
    const el = element({ 'data-aos':'fade' }); setup([el],options); assert.ok(!el.classList.has('anim-pending'));
  }
  const el = element({ 'data-aos':'fade' }, [], 100); assert.equal(setup([el]).observed.size,0);
  const failed = element({ 'data-aos':'fade' }); const run = setup([failed], { animationFailure:true }); run.observed.get(failed)(); assert.ok(!failed.classList.has('anim-pending'));
});
test('filtered-out content can be initialized after it becomes visible', () => {
  const el = element({ 'data-aos':'fade' });
  let hidden = true;
  el.getClientRects = () => hidden ? [] : [{ top:1000 }];
  const run = setup([el]); assert.equal(run.observed.size,0);
  hidden = false; run.window.LTCC.animations.init();
  assert.equal(run.observed.size,1); run.observed.get(el)(); assert.equal(run.calls.length,1);
});
