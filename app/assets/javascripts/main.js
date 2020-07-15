$(document).ready(function() {

  $('.help-button').click(function(){
    let infoPanel = $(this).children('.info-panel');
    if(infoPanel.css('visibility') == 'hidden'){
      $(this).css('z-index', '20');
      $(infoPanel).css('visibility', 'visible');
      $('.overlay').show();
    } else {
      return
    }
  });

  $('.close-panel').mousedown(function(){
    console.log('foo');
    $('.overlay').hide();
    $('.overlay').promise().done(function(){
      console.log('foo');
      $('.help-button').css('z-index', '1');
      $('.info-panel').css('visibility', 'hidden');
    });
  });


  $('#dismiss-flash').click(function(){
    $(this).parent().fadeOut();
  });

  $('.phone-number').mask('(000) 000-0000');
  
});
