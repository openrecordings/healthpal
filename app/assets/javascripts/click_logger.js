// Get the current state of the media player if there is one
function isPlaying() {
  let videoElement = document.getElementById('video-element');
  if (videoElement) {
    // When we get here, the video element has the *new* state, so return the opposite of the new state
    return !videoElement.paused;
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
    var _isPlaying;

    if (this.id == 'play-pause-button') {
      // Toggling play/pause. Wait to lose the race condition with togglePlayPause(), then look at player state
      // TODO: Eliminate race condition
      await new Promise(r => setTimeout(r, 300));
      _isPlaying = !isPlaying();
    } else {
      _isPlaying = isPlaying();
    }

    console.log(_isPlaying ? 'playing' : 'paused');

    $.post('/clicks', {
      recording_id: _recordingID(),
      element_id: this.id,
      url_when_clicked: window.location.href,
      player_state_when_clicked: _isPlaying ? 'playing' : 'paused',
      ranges_played_since_load: rangesPlayed(),
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
          ranges_played_since_load: rangesPlayed(),
        });
      }
    };
  }

})
