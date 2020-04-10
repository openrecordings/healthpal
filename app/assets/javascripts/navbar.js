if (document.querySelector('#menu-container')) {
  var mediaQueries = {
    'small': window.matchMedia("(max-width: 910px)"),
    'medium': window.matchMedia("(max-width: 1340px)"),
  }

  function setMenuType(mediaQuery){
	console.log('foo');
    if(mediaQueries.small.matches){
      $('#mobile-menu-button').show();
      $('.menu-item-right').hide();
      $('.menu-item-left').hide();
    } else if(mediaQueries.medium.matches){
      $('#mobile-menu-button').show();
      $('.menu-item-right').hide();
      $('.menu-item-left').show();
    } else {
      $('#mobile-menu-button').hide();
      $('.menu-item-right').show();
      $('.menu-item-left').show();
  	}
  }

  $('#mobile-menu-button').click(function() {
    console.log('foo');
    $('#menu-container #long').slideToggle(100);
  });

  $(document).ready(function() {
	setMenuType(mediaQueries.small);
	setMenuType(mediaQueries.medium);
    mediaQueries.small.addListener(setMenuType);
    mediaQueries.medium.addListener(setMenuType);
  })
}
