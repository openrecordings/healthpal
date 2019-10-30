if(document.querySelector('#menu-container')) {


	function toggleMenuType(mediaQuery) {
		if(mediaQuery.matches){ 
	    console.log('here');
			$('#mobile-menu-button').show();
			$('#menu-container').hide();
		} else {
			$('#mobile-menu-button').hide();
			$('#menu-container').show();
		}
	}
  var mobileWidth = window.matchMedia("(max-width: 500px)");
	toggleMenuType(mobileWidth);
	mobileWidth.addListener(toggleMenuType);

	$('#mobile-menu-button').click(function(){
    $('#menu-container').slideToggle(200);
  });

}
