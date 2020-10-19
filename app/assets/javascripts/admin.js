$(document).ready(function () {

  // Initialize tablesorter
  $(function() {
    $('#user-table').tablesorter();
  });

	if (document.querySelector('#new-caregiver-form, #switch-user-form')) {
		document.body.addEventListener('ajax:success', function (event) {
			window.location.assign('/');
		})
	}
})
