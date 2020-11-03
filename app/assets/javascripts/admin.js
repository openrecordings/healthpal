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
			$('#contact-email-address-editor').hide();
		}

		$('#open-email-address-editor').click(function () {
			console.log('open');
			$('#contact-email-address-display').hide();
			$('#open-email-address-editor').hide();
			$('#contact-email-address-editor').show();
		})

		$('#update-contact-email-address').click(function () {
			console.log('update');
			var orgId = $('#contact-email-address-editor').data('org-id');
			var contactEmailAddress = $('#contact-email-address-value').val();
			console.log(orgId);
			console.log(contactEmailAddress);
			$.post('/update_contact_email_address', {
				id: orgId,
				contact_email_address: contactEmailAddress
			});
			$('#contact-email-address-display').text(contactEmailAddress);
			hideEditor();
		})

		$('#cancel-edit-contact-email-address').click(function () {
			console.log('cancel');
			hideEditor();
		})
	})

}