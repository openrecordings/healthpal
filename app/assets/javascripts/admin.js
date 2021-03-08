if (document.querySelector('#admin-index')) {

	function hideEditor() {
		$('#contact-email-address-display').show();
		$('#open-email-address-editor').show();
		// $('#contact-email-address-editor').css('visibility', 'hidden');
		$('#contact-email-address-editor').hide();
	}

	$(document).ready(function () {
		$('#user-table').tablesorter({
			theme: 'tablesorter-custom',
		});

		$('.recording').click(function(){
			window.location.assign(`/play/${$(this).data('recording-id')}`);
		})

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

		if (document.querySelector('#new-caregiver-form, #switch-user-form')) {
			document.body.addEventListener('ajax:success', function (event) {
				window.location.assign('/');
			})
		}
	})

}