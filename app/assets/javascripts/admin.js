$(document).ready(function() {
	//TODO delete? not used?
	if(document.querySelector('#new-caregiver-form, #switch-user-form')) {
		document.body.addEventListener('ajax:success', function(event) {
			window.location.assign('/');
		})
	}
})
