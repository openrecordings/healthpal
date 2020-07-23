$(document).ready(function () {

	if (document.querySelector('#new-caregiver-form, #switch-user-form')) {
		document.body.addEventListener('ajax:success', function (event) {
			window.location.assign('/');
		})
	}
})
