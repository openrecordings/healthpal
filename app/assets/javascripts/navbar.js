if(document.querySelector('#menu-container')) {


	function toggleMenuType(mediaQuery) {
		if(mediaQuery.matches){ 
			$('#mobile-menu-button').show();
			$('#menu-container').hide();
      $('#navbar-right-big').hide();
      $('#navbar-right-small').show();
		} else {
			$('#mobile-menu-button').hide();
			$('#menu-container').show();
      $('#navbar-right-small').hide();
      $('#navbar-right-big').show();
		}
	}
  var mobileWidth = window.matchMedia("(max-width: 500px)");
	toggleMenuType(mobileWidth);
	mobileWidth.addListener(toggleMenuType);

	$('#mobile-menu-button').click(function(){
    $('#menu-container').slideToggle(200);
  });

}
