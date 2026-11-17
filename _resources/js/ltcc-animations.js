/* Scroll reveals. Load the pinned Motion CDN script before this file. */
(() => {
"use strict";
if (!window.Motion) return; // CDN failure leaves all content visible.
const { animate, inView } = window.Motion;
const presets = {
  "anim-scroll-fade": { opacity: [0, 1] },
  "anim-scroll-fade-up": { opacity: [0, 1], y: [24, 0] },
  "anim-scroll-fade-down": { opacity: [0, 1], y: [-24, 0] },
  "anim-scroll-slide-left": { opacity: [1, 1], clipPath: ["inset(0% 0% 0% 100%)", "inset(0% 0% 0% 0%)"] },
  "anim-scroll-slide-right": { opacity: [1, 1], clipPath: ["inset(0% 100% 0% 0%)", "inset(0% 0% 0% 0%)"] },
};
// Read legacy CMS output directly; no AOS library or markup migration needed.
const legacyPresets = new Map([
  ["fade", "anim-scroll-fade"],
  ["fade-up", "anim-scroll-fade-up"],
  ["fade-down", "anim-scroll-fade-down"],
]);
const selector = [...Object.keys(presets).map(name => `.${name}`), "[data-aos]"].join(",");
function presetFor(element) {
  // An explicit new setting (including none/unknown) suppresses legacy fallback.
  const classes = [...element.classList];
  if (classes.includes("anim-scroll-none")) return null;
  const modern = classes.find(name => name.startsWith("anim-scroll-"));
  if (modern) return Object.hasOwn(presets, modern) ? modern : null;
  return legacyPresets.get((element.getAttribute("data-aos") || "").trim()) || null;
}
const initialized = new WeakSet();
const active = new Set();
const pending = new Set();
const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)");

function timingFor(element, setting, fallbackMs) {
  // CMS timing classes use whole milliseconds; Motion expects seconds.
  const prefix = `anim-${setting}-`;
  const token = [...element.classList].find(name =>
    name.startsWith(prefix) && /^\d+$/.test(name.slice(prefix.length)));
  const legacy = (element.getAttribute(`data-aos-${setting}`) || "").trim();
  // Text fields may contain milliseconds or an optional ms suffix. Reject
  // negatives, seconds, arbitrary text and unresolved [[CMS placeholders]].
  const milliseconds = token ? Number(token.slice(prefix.length))
    : /^\d+(?:\.\d+)?(?:ms)?$/i.test(legacy) ? Number(legacy.replace(/ms$/i, "")) : fallbackMs;
  return (Number.isFinite(milliseconds) ? milliseconds : fallbackMs) / 1000;
}

function reveal(element) {
  if (reducedMotion.matches || document.documentElement.classList.contains("no-js") || !pending.has(element)) return;
  const preset = presetFor(element);
  if (!preset) {
    element.classList.remove("anim-pending");
    pending.delete(element);
    return;
  }
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
      duration: timingFor(element, "duration", 600),
      delay: timingFor(element, "delay", 0),
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
    if (initialized.has(element) || !presetFor(element)) return;
    // Filtered-out cards can be initialized when their group becomes visible.
    if (!element.getClientRects().length) return;
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
