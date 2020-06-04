$(document).ready(function() {

  document.body.height = window.innerHeight;
  document.getElementsByTagName('html').height = window.innerHeight;

  $('#dismiss-flash').click(function(){
    $(this).parent().fadeOut();
  })

  $('.phone-number').mask('(000) 000-0000');
  
});
