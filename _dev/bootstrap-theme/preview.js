/* Behaviors specific to the theme reference; not loaded on the public site. */
(() => {
  "use strict";
  const form = document.getElementById("preview-form");
  const status = document.getElementById("form-status");
  form.addEventListener("submit", (event) => {
    event.preventDefault();
    form.classList.add("was-validated");
    const valid = form.checkValidity();
    status.textContent = valid ? "Validation passed. No information was sent." : "Complete the required name and email fields.";
    if (!valid) form.querySelector(":invalid").focus();
  });
  form.addEventListener("reset", () => {
    form.classList.remove("was-validated");
    status.textContent = "";
  });
})();
