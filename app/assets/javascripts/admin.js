$(document).ready(function () {

	if (document.querySelector('#new-caregiver-form, #switch-user-form')) {
		document.body.addEventListener('ajax:success', function (event) {
			window.location.assign('/');
		})
	}

	if (document.querySelector('#switch-user-form')) {
		$('#user_id').change(function () {
			$(this).blur();
		})
	}
})
