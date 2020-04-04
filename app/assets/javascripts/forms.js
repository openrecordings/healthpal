if(document.querySelector('.form-input-container')) {
  $(document).ready(function(){
    $('input[autofocus]').first().prev().css('visibility', 'visible');

    $('.form-input').focusin(function() {
      $(this).prev().css('visibility', 'visible');
    })

    $('.form-input').focusout(function() {
      $(this).prev().css('visibility', 'hidden');
    })

  })
}
