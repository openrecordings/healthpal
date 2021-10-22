if (document.querySelector('form')) {
  $(document).ready(function () {
    $('#file-upload').change(function() {
      $(".no-file").hide();
      let filename = $(".no-display").prop('files')[0].name;
      $(".chose-file")[0].innerHTML = filename;
      $(".chose-file").show();
    })
    
    $('input[autofocus]').each(function () {
      $(this).attr('placeholder', '');
      $(this).prev().css('visibility', 'visible');
    });

    $('input:text, .email-input, .password-input')
      .filter(function () { return $(this).val() == ''; })
      .filter(function () { return !$(this).attr('autofocus'); })
      .each(function () {
        $(this).prev().css('visibility', 'hidden');
      });

    $('.form-input').focusin(function () {
      $(this).attr('placeholder', '');
      $(this).prev().css('visibility', 'visible');
    });

    $('.form-input').focusout(function () {
      $(this).attr('placeholder', $(this).data('placeholder'));
      if (!$(this).val()) {
        $(this).prev().css('visibility', 'hidden');
      }
    });
  });
}
