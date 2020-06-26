$(document).ready(function() {

  document.body.height = window.innerHeight;
  document.getElementsByTagName('html').height = window.innerHeight;

  $('textarea').autoResize();

  isVisible = function(e) {
    return $(e).css('visibility') === 'visible';
  };
  $('#dismiss-flash').click(function(){
    $(this).parent().fadeOut();
  })

  $('.phone-number').mask('(000) 000-0000');

  $('.modal-cancel').click(function(e){
    let overlay = $(this).closest('.overlay');
    let formLabels = overlay.find('.form-label');
    $(overlay).fadeOut(200);
    $(formLabels).css('visibility', 'hidden');
  });

  // Keyboard support for disposing and saving overlay forms
  $(document).keyup(function(e) {
    if(e.keyCode === 27) $('.modal-cancel:visible').trigger('click');
    if(e.keyCode === 13) $('.modal-save:visible').trigger('click');
  });
  
});
