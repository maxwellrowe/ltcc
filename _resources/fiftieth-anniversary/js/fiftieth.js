document.addEventListener('DOMContentLoaded', function () {
  const nav = document.querySelector('.fifty-landing-page');
  if (!nav) return;

  nav.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      const target = document.querySelector(this.getAttribute('href'));
      if (target) {
        e.preventDefault();
        target.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      }
    });
  });
});

// Move modals to closing body
$(document).ready(function () {
  $('.modal').each(function () {
    $(this).appendTo('body');
  });
});