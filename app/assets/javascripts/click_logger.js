// Log all clicks on elements that have the .log class as Click records via AJAX
$(document).ready(function () {
  // Will include dynamically created elements
  $(document).on('click', '.log', function () {
    console.log('LOGGING');
    $.post('/clicks', {
      recording_id: typeof recordingID === 'undefined' ? null : recordingId,
      element_id: this.id,
      url_when_clicked: window.location.href,
    });
  });
})
