if (document.querySelector('form')) {
  $(document).ready(function () {
    $('#file-upload').change(function() {
      let filename = ""
      for (var i = 0, f; f = $(".no-display").prop('files')[i]; i++) {
        filename += f.name + "\n";
      }
      
      $(".no-file").hide();
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
