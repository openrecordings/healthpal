$(document).ready(function() {
	if(document.querySelector('#new-org-form, #new-caregiver-form, #switch-user-form')) {
		document.body.addEventListener('ajax:success', function(event) {
			window.location.assign('/');
		})
	}
})
