if (document.querySelector('#admin-table')) {

	function setUserCanAccess(element, newValue) {
		let userId = $(element).data('user-id');
		$.post('/set_can_view_tags', { id: userId, value: newValue }, function (json) {
		}).fail(function (error) {
			console.log('Error setting tag visibility for user')
		});
	}

	$(document).ready(function () {
		$('.user-can-access-true').click(((event) => setUserCanAccess(event.target, true)));
		$('.user-can-access-false').click(((event) => setUserCanAccess(event.target, false)));
	})

}
