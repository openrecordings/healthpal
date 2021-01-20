// Get the current state of the media player if there is one
function playerState() {
  let videoElement = document.getElementById('video-element');
  if (videoElement) {
    // When we get here, the video element has the *new* state, so return the opposite of the new state
    return videoElement.paused ? 'paused' : 'playing';
  } else {
    return null;
  }
}

function _recordingID() {
  return typeof recordingID === 'undefined' ? null : recordingId;
}

function rangesPlayed() {
  return 'TODO';
}

$(document).ready(function () {

  // Log all clicks on elements that have the .log class as Click records via AJAX
  $(document).on('click', '.log', async function () {
    // This is an embarrasing hack to ensure that we "lose" the race with calls to togglePlayPause()
    // Eliminating that race condition is too messy/involved at the time this logger is being written
    await new Promise(r => setTimeout(r, 500));

    $.post('/clicks', {
      recording_id: _recordingID(),
      element_id: this.id,
      url_when_clicked: window.location.href,
      player_state_when_clicked: playerState(),
      time_ranges_played_since_load: rangesPlayed(),
    });
  });

  if (document.querySelector('#play-view')) {
    // Log any playback activity when leaving the playback page
    window.onunload = function () {
      let videoElement = document.getElementById('video-element');
      if (videoElement) {
        $.post('/clicks', {
          recording_id: _recordingID(),
          element_id: this.id,
          url_when_clicked: window.location.href,
          player_state_when_clicked: playerState(),
          time_ranges_played_since_load: rangesPlayed(),
        });
      }
    };
  }

})
