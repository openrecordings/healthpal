if (document.querySelector('#play-view')) {
  var recordingId = null;
  var playVolume = 1.0;
  var playerPadding = null;
  var playheadRadius = null;
  var lastTime = 0.0;
  var animationDuration = 300;
  var currentNote = null;

  // TODO: rewrite the entire application with a declaritive UI

  // Selection/playback pane visibility
  /////////////////////////////////////////////////////////////////////////////////////////////////
  function showSelectOnly() {
    $('#left').css({ 'transform': 'scaleX(1)' });
    $('#left').css({ 'min-width': '100%' });
    $('#right').css({ 'transform': 'scaleX(0)' });
    $('#right').css({ 'min-width': '0' });
  }

  function showPlaybackOnly() {
    $('#left').css({ 'transform': 'scaleX(0)' });
    $('#left').css({ 'min-width': '0' });
    $('#right').css({ 'transform': 'scaleX(1)' });
    $('#right').css({ 'min-width': '100%' });
  }

  function clearMetadataFields() {
    $('#recording-title').text('');
    $('#edit-recording-title').val('');
    $('#recording-provider').text($('#edit-recording-provider').attr('placeholder'));
    $('#edit-recording-provider').val('');
  }

  function showPlayer() {
    $('#recording-is-not-processed').hide();
    $('#player-container').show();
  }

  function hidePlayer() {
    $('#player-container').hide();
    $('#recording-is-not-processed').show();
  }

  // Replace/create the video element and load from src URL
  /////////////////////////////////////////////////////////////////////////////////////////////////
  function loadVideo() {
    if (recordingId == null) {
      console.log('Called loadVideo() but recordingId is null!');
      return;
    }
    $.get(`/get_metadata/${recordingId}`).done(function (data) {
      if (data.error) {
        console.log(data.error);
        return;
      } else {
        if (data.is_processed) {
          // NOTE: We actually use an audio element for now so that Safari iOS doesn't override the player UI
          // $('#video-container').html(`
          //   <video id="video-element">
          //     <source src="">
          //   </video>`
          // );
          $('#video-container').html(`
            <video id="video-element"">
              <source src=${data.url} type="video/mp4">
            </video>`
          );
          $('#recording-title').text(data.title);
          $('#edit-recording-title').val(data.title);
          if (data.provider && data.provider.length > 0) {
            $('#recording-provider').text(data.provider);
            $('#edit-recording-provider').val(data.provider);
          };
          $('#recording-date').text(data.date);
          $('#recording-days-ago').text(data.days_ago);
          let videoElement = document.getElementById('video-element');
          videoElement.load();
          videoElement.volume = playVolume;
          videoElement.ondurationchange = function () {
            $('#duration').text(toMmSs(videoElement.duration));
            loadNotes();
            skipToTime(0);
          };
          videoElement.ontimeupdate = function () {
            let currentTime = videoElement.currentTime;
            let displayTime = toMmSs(currentTime);
            $('#current-time').text(displayTime);
            $('#create-note-time').text(displayTime);
            setUiToTime(currentTime);
            if (currentTime == 0) { currentNote = null };
            updateAutoScroll();
          };
          // Can't simply togglePlayPause() because we may have been playing or not when
          // onended was triggered (can fast-forward to end while paused)
          videoElement.onended = function () {
            $('#pause-glyph, #pause-label').addClass('hidden');
            $('#play-glyph, #play-label').removeClass('hidden');
          };
          showPlayer();
        } else {
          hidePlayer();
        }
      }
    });
  }

  // Playback utilities
  /////////////////////////////////////////////////////////////////////////////////////////////////
  function pause() {
    let videoElement = document.getElementById('video-element');
    if (!videoElement.paused) { togglePlayPause() };
  }

  function togglePlayPause() {
    let videoElement = document.getElementById('video-element');
    if (videoElement.paused) {
      videoElement.play();
    }
    else {
      videoElement.pause();
    }
    togglePlayPauseButton();
  }

  function togglePlayPauseButton() {
    $('#play-glyph, #pause-glyph, #play-label, #pause-label').toggleClass('hidden');
  }

  function skipToTime(newTime) {
    let videoElement = document.getElementById('video-element');
    videoElement.currentTime = newTime.toString();
  }

  function skipToEventPosition(event) {
    let playhead = $('#playhead');
    let videoElement = document.getElementById('video-element');
    let duration = $(videoElement).prop('duration');
    let timeline = $('#timeline');
    let timelineWidth = timeline.width();
    let eventPx = event.pageX - playerPadding;
    let secPerTimelinePx = duration / timelineWidth;
    let newTime = secPerTimelinePx * eventPx;
    skipToTime(newTime);
    setUiToTime(newTime);
  }

  function setUiToTime(newTime) {
    let videoElement = document.getElementById('video-element');
    let duration = $(videoElement).prop('duration');
    if (newTime < 0) { newTime = 0 };
    if (newTime > duration) { newTime = duration };
    let timeDelta = newTime - lastTime
    let timeline = $('#timeline');
    let playhead = $('#playhead');
    let progressBar = $('#progress-bar');
    let timelineWidth = timeline.width();
    let pxPerSec = timelineWidth / duration;
    let animationDuration = '0';
    // A crude way to avoid async animations getting mucked up when skipping around in the recording
    if (Math.abs(timeDelta) < 1.0) { animationDuration = timeDelta };
    lastTime = newTime;
    playhead.css('transition-duration', `${animationDuration}s`);
    progressBar.css('transition-duration', `${animationDuration}s`);
    let newPlayheadPx = pxPerSec * newTime - playheadRadius;
    if (newPlayheadPx < 0) { newPlayheadPx = 0 };
    if (newPlayheadPx > timelineWidth - 2 * playheadRadius) { newPlayheadPx = timelineWidth - 2 * playheadRadius };
    playhead.css({ left: newPlayheadPx });
    progressBar.css({ width: newPlayheadPx });
    $('.note').each(function () {
      let notePin = $(`.note-pin[data-note-id="${$(this).data('note-id')}"]`);
      let pinLeftPx = $(this).data('note-at') * pxPerSec - playheadRadius - 2;
      if (pinLeftPx < 0) { pinLeftPx = 0 };
      if (pinLeftPx > timelineWidth - 2 * playheadRadius) { pinLeftPx = timelineWidth - 2 * playheadRadius };
      notePin.css('left', pinLeftPx);
    });
  }

  function toMmSs(seconds) {
    let mm = Math.floor(seconds / 60);
    let ss = parseInt(seconds - mm * 60);
    return `${mm.toString().padStart(2, '0')}:${ss.toString().padStart(2, '0')}`
  }

  function playAt(seconds) {
    let videoElement = document.getElementById('video-element');
    skipToTime(seconds);
    if (videoElement.paused) {
      togglePlayPause();
    }
  }

  $(document).ready(function () {
    // Initialization
    /////////////////////////////////////////////////////////////////////////////////////////////////
    recordingId = $('#play-view').data('initial-recording-id');
    if (recordingId != null) {
      loadVideo();
      showPlaybackOnly(0);
    }

    // Setting this to some fixed height after page load results in proper overfow scroll behavior
    $('#select').css('height', '100px');

    playerPadding = parseInt($('#player-container').css('padding-left'), 10);
    playheadRadius = $('#playhead').width() / 2;

    $(window).resize(function () {
      if (recordingId != null) {
        let videoElement = document.getElementById('video-element');
        if ($(videoElement).length > 0) {
          setUiToTime(videoElement.currentTime);
        }
      }
    });

    // Listeners
    /////////////////////////////////////////////////////////////////////////////////////////////////

    // Select
    //////////////////////
    $('.recording-list-item').click(function () {
      recordingId = $(this).data('recording-id');
      loadVideo();
      showPlaybackOnly();
    })

    $('#toolbar, #show-select').click(function () {
      showSelectOnly();
      clearMetadataFields();
      skipToTime(0.0);
      pause();
    })

    // Player
    //////////////////////
    $('#timeline').click(function (event) {
      skipToEventPosition(event);
    })

    $('#playhead').draggable({
      axis: 'x',
      containment: '#timeline',
      drag: function (event, ui) {
        skipToEventPosition(event);
      }
    });

    $('#rewind-button').click(function () {
      let videoElement = document.getElementById('video-element');
      skipToTime(0);
    })

    $('#back-button').click(function () {
      let videoElement = document.getElementById('video-element');
      skipToTime(videoElement.currentTime - 10);
    })

    $('#play-pause-button').click(function () {
      togglePlayPause();
    })

    $('#forward-button').click(function () {
      let videoElement = document.getElementById('video-element');
      skipToTime(videoElement.currentTime + 10);
    })

    $('#mute-button').click(function () {
      let videoElement = document.getElementById('video-element');
      if (videoElement.volume > 0) {
        videoElement.volume = 0;
      }
      else {
        videoElement.volume = playVolume;
      }
      $('#mute-glyph, #unmute-glyph, #mute-label, #unmute-label').toggleClass('hidden');
    })

    // Metadata
    //////////////////////
    $('#edit-recording-metadata').click(function () {
      $('#metadata-overlay').hide().fadeIn(200);
      $('#metadata-overlay').css('visibility', 'visible');
    });

    $('#metadata-save').click(function () {
      let title = $('#edit-recording-title').val();
      let provider = $('#edit-recording-provider').val();
      if (title.length === 0) {
        alert('Recording name is required');
        return;
      }
      let selectDiv = $(`.recording-list-item[data-recording-id=${recordingId}]`)
      let selectDivTitle = $(selectDiv).find('.recording-title');
      $('#recording-title').text(title);
      $(selectDivTitle).text(title);
      if (provider.length > 0) {
        let selectDivProvider = $(selectDiv).find('.recording-provider');
        $('#recording-provider').text(provider);
        $(selectDivProvider).text(provider);
      } else {
        provider = null;
      }
      $.post('/update_metadata', { id: recordingId, title: title, provider: provider });
      $('#metadata-cancel').click();
    });

  })
}
