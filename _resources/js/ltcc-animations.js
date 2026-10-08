/* Scroll reveals. Load the pinned Motion CDN script before this file. */
(() => {
"use strict";
if (!window.Motion) return; // CDN failure leaves all content visible.
const { animate, inView } = window.Motion;
const presets = {
  "anim-scroll-fade": { opacity: [0, 1] },
  "anim-scroll-fade-up": { opacity: [0, 1], y: [24, 0] },
  "anim-scroll-slide-left": { opacity: [1, 1], clipPath: ["inset(0% 0% 0% 100%)", "inset(0% 0% 0% 0%)"] },
  "anim-scroll-slide-right": { opacity: [1, 1], clipPath: ["inset(0% 100% 0% 0%)", "inset(0% 0% 0% 0%)"] },
};
const selector = Object.keys(presets).map(name => `.${name}`).join(",");
const initialized = new WeakSet();
const active = new Set();
const pending = new Set();
const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)");

function delayFor(element) {
  // Any nonnegative integer suffix is accepted; use one delay class per element.
  const token = [...element.classList].find(name => /^anim-delay-\d+$/.test(name));
  return token ? Number(token.slice("anim-delay-".length)) / 1000 : 0;
}

function reveal(element) {
  if (reducedMotion.matches || document.documentElement.classList.contains("no-js") || !pending.has(element)) return;
  const preset = Object.keys(presets).find(name => element.classList.contains(name));
  const original = { opacity: element.style.opacity, transform: element.style.transform, clipPath: element.style.clipPath };
  let animation;
  const restore = () => {
    element.classList.remove("anim-pending");
    pending.delete(element);
    element.style.opacity = original.opacity;
    element.style.transform = original.transform;
    element.style.clipPath = original.clipPath;
    active.delete(finish);
  };
  const finish = () => {
    animation?.complete();
    restore();
  };
  try {
    animation = animate(element, presets[preset], {
      duration: 0.6,
      delay: delayFor(element),
      ease: [0.22, 1, 0.36, 1],
    });
    active.add(finish);
    animation.then(restore);
  } catch (error) {
    restore(); // Content remains readable if animation setup fails.
    console.warn("LTCC animation could not start:", error);
  }
}

function init(root = document) {
  if (document.documentElement.classList.contains("no-js") || !("IntersectionObserver" in window)) return;
  const elements = [...root.querySelectorAll(selector)];
  if (root.matches?.(selector)) elements.unshift(root);
  elements.forEach(element => {
    if (initialized.has(element)) return;
    initialized.add(element);
    // Leave already-visible content alone: late CDN loading must not hide it.
    const bounds = element.getBoundingClientRect();
    if (reducedMotion.matches || (bounds.top < window.innerHeight && bounds.bottom > 0)) return;
    pending.add(element);
    element.classList.add("anim-pending");
    // No exit callback: Motion observes each element only until its first reveal.
    // Wait until content reaches 80px above the viewport bottom.
    try {
      inView(element, () => { reveal(element); }, {
      amount: "some",
      margin: "0px 0px -80px 0px",
      });
    } catch (error) {
      element.classList.remove("anim-pending");
      pending.delete(element);
      console.warn("LTCC animation observer could not start:", error);
    }
  });
}

reducedMotion.addEventListener("change", () => {
  if (reducedMotion.matches) {
    [...active].forEach(finish => finish());
    pending.forEach(element => element.classList.remove("anim-pending"));
    pending.clear();
  }
});
window.LTCC = window.LTCC || {};
window.LTCC.animations = { init };
if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", () => init(), { once: true });
} else {
  init();
}

})();
