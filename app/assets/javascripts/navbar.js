if (document.querySelector('#menu-container')) {
  $(document).ready(function () {
    function setMenuType(mediaQuery) {
      if (mediaQueries.small.matches) {
        $('#mobile-menu-button').show();
        $('#menu-right').hide();
        $('#menu-left').hide();
        $('#menu-top').show();
        $('#menu-bottom').show();
      } else if (mediaQueries.medium.matches) {
        $('#mobile-menu-button').show();
        $('#menu-right').hide();
        $('#menu-left').show();
        $('#menu-top').hide();
        $('#menu-bottom').show();
      } else {
        $('#mobile-menu-button').hide();
        $('#menu-right').show();
        $('#menu-left').show();
        $('#long').hide();
        $('#menu-top').hide();
        $('#menu-bottom').hide();
      }
    }

    $('#mobile-menu-button').click(function () {
      $('#menu-container #long').slideToggle(100);
    });

    var privileged = $('#nav-container').data('privileged') == true;
    if (privileged) {
      var mediaQueries = {
        'small': window.matchMedia("(max-width: 840px)"),
        'medium': window.matchMedia("(max-width: 1150px)"),
      }
    } else {
      var mediaQueries = {
        'small': window.matchMedia("(max-width: 450px)"),
        'medium': window.matchMedia("(max-width: 840px)"),
      }
    }
    setMenuType(mediaQueries.small);
    setMenuType(mediaQueries.medium);
    mediaQueries.small.addListener(setMenuType);
    mediaQueries.medium.addListener(setMenuType);
    $('body').css('visibility', 'visible');
  })
}
