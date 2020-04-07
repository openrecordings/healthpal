if (document.querySelector('#menu-container')) {
	function toggleMenuType(mediaQuery) {
		if (mediaQuery.matches) {
			$('#mobile-menu-button').show();
			$('#menu-container').hide();
			$('#navbar-right').hide();
		} else {
			$('#mobile-menu-button').hide();
			$('#menu-container').show();
			$('#navbar-right').show();
		}
	}

	$(document).ready(function() {
		var maxSmall = window.matchMedia("(max-width: 500px)");
		var maxMedium = window.matchMedia("(max-width: 1000px)");
		maxSmall.addListener(toggleMenuType);
		maxMedium.addListener(toggleMenuType);

		toggleSmall(maxSm);
		toggleMedium(maxMedium);

		$('#mobile-menu-button').click(function () {
			$('#menu-container').slideToggle(100);
		});
	})

}
