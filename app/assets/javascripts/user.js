if (document.querySelector('#new-registration-form')) {
  $(document).ready(function () {
    $('#user_timezone').attr('value', Intl.DateTimeFormat().resolvedOptions().timeZone);
  });
}

$(document).ready(function () {
  // Setting persisted user preference for locale
  $('#toggle-locale').click(function () {
    $.ajax({
      async: false,
      type: 'GET',
      url: '/toggle_locale'
    })
    location.reload();
  })

  // Setting locale for next request (for unauthenticated pages)
  // Works because we have only two languages at present
  // Update if > 2 languages
  $('#toggle-locale-signin').click(function () {
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