if (document.querySelector('form')) {
  $(document).ready(function () {
    $('input[autofocus]').each(function () {
      $(this).attr('placeholder', '');
      $(this).prev().css('visibility', 'visible');
    });

    $('input:text, .email-input')
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
