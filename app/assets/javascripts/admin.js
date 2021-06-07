if (document.querySelector('#admin-index')) {

	function hideEditor() {
		$('#contact-email-address-display').show();
		$('#open-email-address-editor').show();
		$('#contact-email-address-editor').hide();
	}

	function hideEditableEditor(element) {
		var container = $(element).closest('.editable');
		$(container).find('.editable-editor').hide();
		$(container).find('.open-editable-editor').show();
		$(container).find('.editable-display').show();
	}

	$(document).ready(function () {
		$('#user-table').tablesorter({
			theme: 'tablesorter-custom',
		});

		$('.admin-recording-link').click(function () {
			console.log('yo');
			window.location.assign(`/play/${$(this).data('recording-id')}`);
		})

		if (document.querySelector('#new-caregiver-form, #switch-user-form')) {
			document.body.addEventListener('ajax:success', function (event) {
				window.location.assign('/');
			})
		}

		// Admin email address
		/////////////////////////////////////////////////////////////////////////////////
		$('#open-email-address-editor').click(function () {
			$('#contact-email-address-display').hide();
			$('#open-email-address-editor').hide();
			$('#contact-email-address-editor').show();
		})

		$('#update-contact-email-address').click(function () {
			var orgId = $('#contact-email-address-editor').data('org-id');
			var contactEmailAddress = $('#contact-email-address-value').val();
			$.post('/update_contact_email_address', {
				id: orgId,
				contact_email_address: contactEmailAddress
			});
			$('#contact-email-address-display').text(contactEmailAddress);
			hideEditor();
		})

		$('#cancel-edit-contact-email-address').click(function () {
			hideEditor();
		})

		// Generic editable field
		/////////////////////////////////////////////////////////////////////////////////
		$('.open-editable-editor').click(function () {
			$(this).hide();
			$(this).closest('.editable').find('.editable-display').hide();
			$(this).closest('.editable').find('.editable-editor').show();
		})

		$('.cancel-edit-editable').click(function (event) {
			hideEditableEditor(event.target);
		})

		$('.update-editable').click(function (event) {
			var container = $(this).closest('.editable');
			var editor = $(container).find('.editable-editor');
			var userId = editor.data('user-id');
			var postPath = `/${editor.data('post-path')}`;
			var value = $(container).find('.editable-value').val();
			$.post(postPath, {
				id: userId,
				value: value
			});
			$(container).find('.editable-display').text(value);
			hideEditableEditor(event.target);
		})
	})

}