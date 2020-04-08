if (document.querySelector('#menu-container')) {
	var mediaQueries = {
		'small': window.matchMedia("(max-width: 500px)"),
		'medium': window.matchMedia("(max-width: 1000px)"),
	}

	$('#menu-container #long').click(function (event) {
		$(event.target).slideToggle(100);
	});

	$(document).ready(function() {

		// $('.menu-item-right').hide();

		mediaQueries.small.addListener(toggleMenuType);
		mediaQueries.medium.addListener(toggleMenuType);
	})

}


	// function toggleMenuType(mediaQuery) {
	// 	if (mediaQuery.matches) {
	// 		$('#mobile-menu-button').show();
	// 		$('#menu-container').hide();
	// 		$('#navbar-right').hide();
	// 	} else {
	// 		$('#mobile-menu-button').hide();
	// 		$('#menu-container').show();
	// 		$('#navbar-right').show();
	// 	}
	// }
