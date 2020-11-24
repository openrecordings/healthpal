if (document.querySelector('#new-registration-form')) {
  $(document).ready(function () {
    $('#user_timezone').attr('value', Intl.DateTimeFormat().resolvedOptions().timeZone);
  });
}

$(document).ready(function () {
  $('#toggle-locale').click(function () {
    $.ajax({
      async: false,
      type: 'GET',
      url: '/toggle_locale'
    })
    location.reload();
  })
})