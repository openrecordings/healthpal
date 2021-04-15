if (document.querySelector('#admin-table')) {

	$(document).ready(function () {

		$('.user-can-access-true').click(((event) => setUserCanViewTags(event.target, true)));
		$('.user-can-access-false').click(((event) => setUserCanViewTags(event.target, false)));

		$('.set-can-view-tags').click(function (event) {
			let userId = $(this).data('user-id');
			let newValue = $(this).data('new-value');
			$.post('/set_can_view_tags', { id: userId, value: newValue }, function (json) {
				location.reload();
			}).fail(function (error) {
				console.log('Error setting tag visibility for user');
			});
		})

		$('.set-can-view-tags-editable').click(function (event) {
			console.log('foo');
			let userId = $(this).data('user-id');
			let newValue = $(this).data('new-value');
			console.log(userId);
			console.log(newValue);
			$.post('/set_can_view_tags_editable', { id: userId, value: newValue }, function (json) {
				location.reload();
			}).fail(function (error) {
			  console.log('Error setting editability of tag visibility for user');
			});
		})

	})

}
