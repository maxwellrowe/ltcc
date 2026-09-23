// Animations
AOS.init({
	duration: 1000,
	easing: 'ease-out-cubic',
	offset: 100,
	once: true,
	disable: function() {
		return window.innerWidth < 992;
	}
});

// AOS Fix for under 992px -- implemented bc animations were not firing on resize nor load of 992px
function addClassIfBelow992() {
  if ($(window).width() < 992) {
    $('.aos-init').addClass('aos-animate');
  }
}
$(window).on('load resize', addClassIfBelow992);

// Match Height Utility
$(document).ready(function() {
	$('.match-height-row').matchHeight({
		byRow: true,
	});
	$('.match-height-all').matchHeight({
		byRow: false,
	});
});

// Image Carousel
$(document).ready(function() {
	$('.ltcc-image-swiper').each(function( slider, index, arr) {
		var swiper = new Swiper(this, {
			slidesPerView: "auto",
			centeredSlides: false,
			spaceBetween: 30,
			loop: true,
			speed: 500,
			lazy: true,
			zoom: true,
			watchOverflow: true,
			autoplay: {
				delay: 4000,
				pauseOnMouseEnter: true,
			},
			navigation: {
				nextEl: ".swiper-button-next",
				prevEl: ".swiper-button-prev",
			}
		});
	});
	
	$('.ltcc-profile-swiper').each(function( slider, index, arr) {
		var swiper = new Swiper(this, {
			slidesPerView: 1,
			spaceBetween: 30,
			breakpoints: {
				768: {
				  slidesPerView: 2,
				},
				1024: {
				  slidesPerView: 3,
				},
			},
			centeredSlides: false,
			loop: true,
			speed: 500,
			lazy: true,
			zoom: true,
			watchOverflow: true,
			autoplay: {
				delay: 4000,
				pauseOnMouseEnter: true,
			},
			navigation: {
				nextEl: ".swiper-button-next",
				prevEl: ".swiper-button-prev",
			}
		});
	});
});

// Profiles
$(document).ready(function () {
  const $buttons = $(".ltcc-profiles-filter button");
  const $items = $(".ltcc-card-profile-col");

  function filterCards(filterClass) {
    // Hide all with visibility hidden (not display: none)
    $items.css("display", "none");

    if (!filterClass) {
      $items.css("display", "block");
    } else {
      $items.each(function () {
        const $el = $(this);
        if ($el.hasClass(filterClass)) {
          $el.css("display", "block");
        }
      });
    }

    // Re-initialize AOS
    AOS.refreshHard(); // Ensures AOS recalculates positions
  }

  $buttons.on("click", function (e) {
    e.preventDefault();

    const $btn = $(this);
    const filter = $btn.data("toggle");

    $buttons.removeClass("active");
    $btn.addClass("active");

    if (!filter) {
      filterCards(null);
      history.replaceState(null, null, " ");
    } else {
      filterCards(filter);
      history.replaceState(null, null, "#" + filter.replace("type-", ""));
    }
  });

  // Load from hash on page load
  const hash = window.location.hash.substring(1);
  if (hash === "alumni" || hash === "influential") {
    const $targetBtn = $buttons.filter(`[data-toggle="type-${hash}"]`);
    if ($targetBtn.length) $targetBtn.trigger("click");
  } else {
    AOS.refreshHard(); // Initial load
  }
});