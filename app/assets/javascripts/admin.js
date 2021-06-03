if (document.querySelector('#admin-index')) {

	function hideEditor() {
		$('#contact-email-address-display').show();
		$('#open-email-address-editor').show();
		$('#contact-email-address-editor').hide();
	}

	function hideRedcapIdEditor(element) {
		var container = $(element).closest('.redcap-id');
		$(container).find('.redcap-id-editor').hide();
		$(container).find('.open-redcap-id-editor').show();
		$(container).find('.redcap-id-display').show();
	}

	$(document).ready(function () {
		$('#user-table').tablesorter({
			theme: 'tablesorter-custom',
		});

		$('.admin-recording-link').click(function () {
			console.log('yo');
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

		$('.open-redcap-id-editor').click(function () {
			$(this).hide();
			$(this).closest('.redcap-id').find('.redcap-id-display').hide();
			$(this).closest('.redcap-id').find('.redcap-id-editor').show();
		})

		$('.cancel-edit-redcap-id').click(function (event) {
			hideRedcapIdEditor(event.target);
		})

		$('.update-redcap-id').click(function (event) {
			var container = $(this).closest('.redcap-id');
			var userId = $(container).find('.redcap-id-editor').data('user-id');
			var redcapId = $(container).find('.redcap-id-value').val();
			$.post('/update_redcap_id', {
				id: userId,
				redcap_id: redcapId
			});
			$('.redcap-id-display').text(redcapId);
			hideRedcapIdEditor(event.target);
		})

		if (document.querySelector('#new-caregiver-form, #switch-user-form')) {
			document.body.addEventListener('ajax:success', function (event) {
				window.location.assign('/');
			})
		}
	})

}