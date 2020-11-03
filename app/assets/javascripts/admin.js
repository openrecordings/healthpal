if (document.querySelector('#admin-index')) {
	$(document).ready(function () {


		// Initialize tablesorter
		$(function () {
			$('#user-table').tablesorter();
		});

		if (document.querySelector('#new-caregiver-form, #switch-user-form')) {
			document.body.addEventListener('ajax:success', function (event) {
				window.location.assign('/');
			})
		}

		function hideEditor() {
			$('#contact-email-address-display').show();
			$('#open-email-address-editor').show();
			$('#update-contact-email-address').hide();
		}

		$('#open-email-address-editor').click(function () {
			console.log('open');
			$('#contact-email-address-display').hide();
			$('#open-email-address-editor').hide();
			$('#update-contact-email-address').show();
		})

		$('#update-contact-email-address').click(function () {
			console.log('update');
			var orgId = $('#update-contact-email-address').data('org-id');
			var contactEmailAddress = $('#contact-email-address-value').val();
			$.post('/update_contact_email_address', { id: orgId, contact_email_address: contactEmailAddress })
			hideEditor();
		})

		$('#cancel-edit-contact-email-address').click(function () {
			console.log('cancel');
			hideEditor();
		})
	})

}