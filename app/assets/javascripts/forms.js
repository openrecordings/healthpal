if (document.querySelector('form')) {
  $(document).ready(function () {
    $('input[autofocus]').each(function () {
      $(this).attr('placeholder', '');
      $(this).prev().css('visibility', 'visible');
    });

    $('input:text')
      .filter(function () { return $(this).val() == ''; })
      .filter(function () { return !$(this).attr('autofocus'); })
      .each(function () {
        console.log(this);
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
