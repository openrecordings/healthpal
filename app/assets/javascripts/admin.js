if (document.querySelector('#admin-table')) {

	function setUserCanAccess(element, newValue) {
		let userId = $(element).data('user-id');
		console.log(userId);
		console.log(newValue);
	}

	$(document).ready(function () {
		$('.user-can-access-true').click(((event) => setUserCanAccess(event.target, true)));
		$('.user-can-access-false').click(((event) => setUserCanAccess(event.target, false)));
	})

}
