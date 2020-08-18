if (document.querySelector('#menu-container')) {
  $(document).ready(function () {
    function setMenuType(mediaQuery) {
      if (mediaQueries.small.matches) {
        $('#mobile-menu-button').show();
        $('.menu-item-right').hide();
        $('.menu-item-left').hide();
        $('.menu-item-top').show();
        $('.menu-item-bottom').show();
      } else if (mediaQueries.medium.matches) {
        $('#mobile-menu-button').show();
        $('.menu-item-right').hide();
        $('.menu-item-left').show();
        $('.menu-item-top').hide();
        $('.menu-item-bottom').show();
      } else {
        $('#mobile-menu-button').hide();
        $('.menu-item-right').show();
        $('.menu-item-left').show();
        $('#long').hide();
        $('.menu-item-top').hide();
        $('.menu-item-bottom').hide();
      }
    }

    $('#mobile-menu-button').click(function () {
      $('#menu-container #long').slideToggle(100);
    });

    var privileged = $('#nav-container').data('privileged') == true;
    if (privileged) {
      var mediaQueries = {
        'small': window.matchMedia("(max-width: 850px)"),
        'medium': window.matchMedia("(max-width: 1150px)"),
      }
    } else {
      var mediaQueries = {
        'small': window.matchMedia("(max-width: 850px)"),
        'medium': window.matchMedia("(max-width: 0px)"),
      }
    }
    setMenuType(mediaQueries.small);
    setMenuType(mediaQueries.medium);
    mediaQueries.small.addListener(setMenuType);
    mediaQueries.medium.addListener(setMenuType);
    $('body').show();
  })
}
