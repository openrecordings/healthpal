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


// If #video-element exists, and has been played since loaded, returns a JSON string representing the time ranges played
function rangesPlayed() {
  let videoElement = document.getElementById('video-element');
  let returnVal = null;
  if (videoElement) {
    let timeRanges = videoElement.played;
    if (timeRanges.length > 0) {
      let ranges = [];
      for (i = 0; i < timeRanges.length; i++) {
        ranges.push(
          {
            start_time: timeRanges.start(i),
            end_time: timeRanges.end(i),
          }
        );
      }
      returnVal = JSON.stringify(ranges);
    }
  }
  return returnVal;
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

  // Log any playback activity when leaving the playback page
  if (document.querySelector('#play-view')) {
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
