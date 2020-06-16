if(document.querySelector('.form-input-container')) {
  $(document).ready(function(){
    $('input[autofocus]').each(function() {
      $(this).attr('placeholder', '');
      $(this).prev().css('visibility', 'visible');
    })

    $('.form-input').focusin(function() {
      console.log('foo');
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
