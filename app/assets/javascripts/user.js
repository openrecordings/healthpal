if (document.querySelector('#new-registration-form')) {
  $(document).ready(function () {
    $('#user_timezone').attr('value', Intl.DateTimeFormat().resolvedOptions().timeZone);
  });
}

$(document).ready(function () {
  // Setting locale for next request and user preference in db
  // Works because we have only two languages at present
  // Update if > 2 languages
  $('#toggle-locale').click(function () {
    const newLocale = $('body').data('locale') == 'en' ? 'es' : 'en';
    console.log('foo');
    $.ajax({
      async: false,
      type: 'POST',
      url: '/set_locale_cookie',
      data: { 'locale': newLocale }
    });
    location.reload();
  });
})