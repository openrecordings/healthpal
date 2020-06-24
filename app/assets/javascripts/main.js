$(document).ready(function() {

  document.body.height = window.innerHeight;
  document.getElementsByTagName('html').height = window.innerHeight;

  isVisible = function(e) {
    return $(e).css('visibility') === 'visible';
  };

  // TODO: This will hide *all* form labels on page, fix
  $('.cancel').click( function(e){
    $(this).closest('.overlay').fadeOut(200);
    $('.form-label').css('visibility', 'hidden');
  });

  // Escape cancels forms
  // TODO: This will trigger the click handler for *all* .cancel elements on page, fix
  $(document).keyup(function(e) {
    if(e.keyCode === 27) $('.cancel').triggerHandler('click');
  });

  $('#dismiss-flash').click(function(){
    $(this).parent().fadeOut();
  })

  $('.phone-number').mask('(000) 000-0000');
  
});
