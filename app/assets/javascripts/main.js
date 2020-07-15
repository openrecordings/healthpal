$(document).ready(function() {

  $('.help-button').click(function(){
    let infoPanel = $(this).children('.info-panel');
    if(infoPanel.css('visibility') == 'hidden'){
      $(this).css('z-index', '20');
      $(infoPanel).hide().css('visibility', 'visible').fadeIn(100);
      $('.overlay').fadeIn(100);
    } else {
      return
    }
  });

  $('.close-panel').mousedown(function(){
    $('.overlay').fadeOut(100);
    $('.help-button').css('z-index', '1');
    $('.info-panel').fadeOut(100).css('visibility', 'hidden').show();
  });


  $('#dismiss-flash').click(function(){
    $(this).parent().fadeOut();
  });

  $('.phone-number').mask('(000) 000-0000');
  
});
