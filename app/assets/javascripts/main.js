$(document).ready(function() {

  $('#dismiss-flash').click(function(){
    $(this).parent().fadeOut();
  })

  $('.phone-number').mask('(000) 000-0000');
  
});
