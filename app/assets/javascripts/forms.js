if(document.querySelector('form')) {
  $(document).ready(function(){
    $('input[autofocus]').each(function() {
      $(this).attr('placeholder', '');
      $(this).prev().css('visibility', 'visible');
    })

    $('.form-input').focusin(function() {
      $(this).attr('placeholder', '');
      $(this).prev().css('visibility', 'visible');
    })

    $('.form-input').focusout(function() {
      $(this).attr('placeholder', $(this).data('placeholder'));
      if( !$(this).val() ) {
        $(this).prev().css('visibility', 'hidden');
      }
    })

  })
}
