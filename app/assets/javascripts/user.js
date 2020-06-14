if (document.querySelector('#new-registration-form')) {
  $(document).ready(function () {
    $('#user_timezone').attr('value', Intl.DateTimeFormat().resolvedOptions().timeZone);
  })
}

