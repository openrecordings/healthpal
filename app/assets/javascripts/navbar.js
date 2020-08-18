if (document.querySelector('#menu-container')) {
  function setMenuType(mediaQuery) {
    if (mediaQueries.small.matches) {
      $('#mobile-menu-button').show();
      $('#menu-left').hide();
      $('#menu-right').hide();
      $('#menu-top').show();
      $('#menu-bottom').show();
    } else {
      $('#long').hide();
      $('#mobile-menu-button').hide();
      $('#menu-left').show();
      $('#menu-right').show();
      $('#menu-top').hide();
      $('#menu-bottom').hide();
    }
  }

  var privileged = $('#nav-container').data('privileged') == true;
  if (privileged) {
    var mediaQueries = {
      'small': window.matchMedia("(max-width: 910px)"),
    }
  } else {
    var mediaQueries = {
      'small': window.matchMedia("(max-width: 850px)"),
    }
  }

  $('#mobile-menu-button').click(function () {
    $('#menu-container #long').slideToggle(100);
  });

  $(document).ready(function () {
    setMenuType(mediaQueries.small);
    $('body').show();
    mediaQueries.small.addListener(setMenuType);
  })
}
