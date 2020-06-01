if (document.querySelector('#play-view')) {
  var recordingId = null;
  var playVolume = 1.0;
  var playerPadding = null;
  var playheadRadius = null;
  var lastTime = 0.0;

  // Selection/playback pane visibility
  /////////////////////////////////////////////////////////////////////////////////////////////////
  function showSelect() {
    $('#right').css('flex-grow', '0');
    $('#left').css('flex-grow', '1');
    $('#search-and-select').show();
    $('#right').hide();
  }

  function showPlayback() {
    $('#left').css('flex-grow', '0');
    $('#right').css('flex-grow', '1');
    $('#right').show();
    $('#search-and-select').hide();
  }

  // Replace/create the video element and load from src URL
  /////////////////////////////////////////////////////////////////////////////////////////////////
  function loadVideo() {
    if (recordingId == null) {
      console.log('Called loadVideo() but recordingId is null!');
      return
    }
    $.get(`/video_url/${recordingId}`, function (data) {
      if (data.url) {
        $('#video-container').html(`
          <video id=video-element>
            <source src=${data.url} type="audio/mp3">
          </video>`
        );

        $('#current-recording-title').html(recordingId);
        var videoElement = document.getElementById('video-element');
        videoElement.volume = playVolume;
        skipToTime(0);

        // TODO
        // $('#spinner').show();
        // videoElement.oncanplay = function(){
        //   $('#spinner').hide();
        // }

        videoElement.ondurationchange = function () {
          $('#duration').text(toMmSs(videoElement.duration));
        }
        videoElement.ontimeupdate = function () {
          let currentTime = videoElement.currentTime;
          $('#current-time').text(toMmSs(currentTime));
          setUiToTime(currentTime);

          // !!! DISABLED TAG TABLE FUNCTIONS !!!
          // updateTableHighlighting(currentTime);
          // scrollTable();

        };
        videoElement.onended = function () {
          $('#play-glyph, #pause-glyph, #play-label, #pause-label').toggleClass('invisible');
        }
      } else {
        console.log(data.error)
      }
    })
  }

  // Playback utilities
  /////////////////////////////////////////////////////////////////////////////////////////////////
  function togglePlayPause() {
    let videoElement = document.getElementById('video-element');
    if (videoElement.paused) {
      videoElement.play();
    }
    else {
      videoElement.pause();
    }
    $('#play-glyph, #pause-glyph, #play-label, #pause-label').toggleClass('invisible');
  }
  
  function skipToTime(newTime){
    console.log('to time');
    let videoElement = document.getElementById('video-element');
    videoElement.currentTime = newTime.toString();
  }

  function skipToEventPosition(event) {
    console.log('to event');
    let playhead = $('#playhead');
    let videoElement = document.getElementById('video-element');
    let duration = $(videoElement).prop('duration');
    let timeline = $('#timeline');
    let timelineWidth = timeline.width();
    let eventPx = event.pageX - playerPadding;
    let secPerTimelinePx = duration / timelineWidth;
    let newTime = secPerTimelinePx * eventPx;
    skipToTime(newTime);
    setUiToTime(newTime, false);
  }

  function setUiToTime(newTime, animate=true) {
    console.log('set ui');
    let videoElement = document.getElementById('video-element');
    let duration = $(videoElement).prop('duration');
    if (newTime < 0) { newTime = 0 };
    if (newTime > duration) { newTime = duration };
    let timeline = $('#timeline');
    let playhead = $('#playhead');
    let progressBar = $('#progress-bar');
    let timelineWidth = timeline.width();
    let PxPerSec = timelineWidth / duration;
    let animationDuration = '0';
    if(animate){ animationDuration = newTime - lastTime; }
    console.log(animationDuration);
    lastTime = newTime;
    playhead.css('transition-duration', `${animationDuration}s`);
    let newPlayheadPx = PxPerSec * newTime - playheadRadius;
    if (newPlayheadPx < 0) { newPlayheadPx = 0 };
    if (newPlayheadPx > timelineWidth - 2 * playheadRadius) { newPlayheadPx = timelineWidth - 2 * playheadRadius };
    playhead.css({ left: newPlayheadPx });
    progressBar.css({ width: newPlayheadPx });
  }

  function toMmSs(seconds) {
    let mm = Math.floor(seconds / 60);
    let ss = parseInt(seconds - mm * 60);
    return `${mm.toString().padStart(2, '0')}:${ss.toString().padStart(2, '0')}`
  }

  $(document).ready(function () {
    // Initialization
    /////////////////////////////////////////////////////////////////////////////////////////////////
    playerPadding = parseInt($('#player-container').css('padding-left'), 10);
    playheadRadius = $('#playhead').width() / 2;
    recordingId = $('#play-view').data('initial-recording-id');
    if (recordingId != null) {
      loadVideo();
      showPlayback();
    }

    // Listeners
    /////////////////////////////////////////////////////////////////////////////////////////////////
    $('.recording-list-item').click(function () {
      recordingId = $(this).data('recording-id');
      loadVideo();
      showPlayback();
    })

    $('#show-select').click(function () {
      showSelect();
    })

    $('#timeline').click(function (event) {
      skipToEventPosition(event);
    })

    $('#playhead').draggable({
      axis: 'x',
      eontainment: '#timeline',
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
  })
}