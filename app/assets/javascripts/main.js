$(document).ready(function() {

  document.body.height = window.innerHeight;
  document.getElementsByTagName('html').height = window.innerHeight;

  // TODO: on Safari iOS and maybe others, if ESC is used to dispose the form,
  //       and a text input field has focus, the blinking cursor will remain
  //       after the form is hidden.
  $('.cancel').click( function(e){
    $(this).closest('.overlay').fadeOut(200).then(css('visibility', 'hidden'));
    // TODO: This will hide *all* form labels on page, fix
    $('.form-label').css('visibility', 'hidden');
  });

  // Escape cancels forms
  $(document).keyup( function(e) {
    if(e.keyCode === 27) $('.cancel').triggerHandler('click');
  });

  $('#dismiss-flash').click(function(){
    $(this).parent().fadeOut();
  })

  $('.phone-number').mask('(000) 000-0000');
  
});
