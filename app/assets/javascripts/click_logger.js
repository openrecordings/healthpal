// Log all clicks on elements that have the .log class as Click records vis AJAX
$(document).ready(function () {
  // Will include dynamically created elements
  $(document).on('click', '.log', function () {
    var _recordingId = null;
    if (typeof recordingId !== 'undefined') {
      console.log(`Recording ID: ${recordingId}`);
    }
    $.post('/clicks', {
      recording_id: recordingId,
      element_id: this.id,
      url_when_clicked: window.location.href,
    });
    // console.log('--------------------');
    // console.log(`Element ID: ${this.id}`);
    // console.log(`URL: ${window.location}`);
  });
})
