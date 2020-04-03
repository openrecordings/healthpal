if(document.querySelector('.form-input-container')) {
  $(document).ready(function() {

    $('.form-input').focusin(function() {
      $(this).prev().css('visibility', 'visible');
    })

    $('.form-input').focusout(function() {
      $(this).prev().css('visibility', 'hidden');
    })

  })
}
