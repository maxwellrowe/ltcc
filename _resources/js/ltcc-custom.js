/* LTCC theme behavior. Bootstrap 5 must be available by DOM readiness for its controls. */
(() => {
  "use strict";

  // Replace the legacy Modernizr class switch before the page renders.
  document.documentElement.classList.remove("no-js");
  document.documentElement.classList.add("js");

  // Tooltips and popovers are opt-in; other data-bs-* controls use Bootstrap's data API.
  // This is safe to call again after inserting CMS content dynamically.
  function init(root = document) {
    if (!window.bootstrap) {
      // Legacy pages do not yet load Bootstrap 5; the class switch still applies.
      return;
    }
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
