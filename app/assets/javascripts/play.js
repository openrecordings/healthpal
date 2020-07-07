if (document.querySelector('#play-view')) {
  // TODO: recordingId should not be global. Works now but will not scale. Each function should fetch it.
  var recordingId = null;
  var playVolume = 1.0;
  var playerPadding = null;
  var playheadRadius = null;
  var lastTime = 0.0;
  var animationDuration = 300;
  var currentNote = null;

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

  // Replace/create the video element and load from src URL
  /////////////////////////////////////////////////////////////////////////////////////////////////
  function loadVideo() {
    if (recordingId == null) {
      console.log('Called loadVideo() but recordingId is null!');
      return;
    }
    $.get(`/get_metadata/${recordingId}`, function (data) {
      if (data) {
        // NOTE: We actually use an audio element for now so that Safari iOS doesn't override the player UI
        $('#video-container').html(`
          <audio id=video-element>
            <source src=${data.url} type="audio/mp3">
          </audio>`
        );
        $('#recording-title').text(data.title);
        $('#edit-recording-title').val(data.title);
        if (data.provider && data.provider.length > 0) {
          $('#recording-provider').text(data.provider);
          $('#edit-recording-provider').val(data.provider);
        }
        $('#recording-date').text(data.date);
        $('#recording-days-ago').text(data.days_ago);
        var videoElement = document.getElementById('video-element');
        videoElement.volume = playVolume;
        skipToTime(0);
        videoElement.ondurationchange = function () {
          $('#duration').text(toMmSs(videoElement.duration));
        }
        videoElement.ontimeupdate = function () {
          let currentTime = videoElement.currentTime;
          let displayTime = toMmSs(currentTime);
          $('#current-time').text(displayTime);
          $('#create-note-text').text(`New note at ${displayTime}`);
          setUiToTime(currentTime);
          if (currentTime == 0) { currentNote = null };
          updateAutoScroll();
        };
        // TODO: Fails if you fast-forward past the end while paused
        videoElement.onended = function () {
          togglePlayPauseButton();
        };
        loadNotes();
      } else {
        console.log(data.error)
      }
    })
  }

  function loadNotes() {
    let notesHeader = $('#notes-header');
    let notesContainer = $('#notes-container');
    let noNotes = $('#no-notes');
    $('.note').remove();
    $('.note-pin').remove();
    $.get(`/get_notes/${recordingId}`, function (data) {
      if (data.error) {
        console.log(data.error);
        return;
      };
      if (data.notes.length == 0) {
        notesHeader.hide();
        notesContainer.hide();
        noNotes.show();
      } else {
        notesHeader.show();
        notesContainer.show();
        noNotes.hide();
        let timelineContainer = $('#timeline-container');
        data.notes.forEach(function (note) {
          notesContainer.append(noteHtml(note))
          timelineContainer.append(notePinHtml(note))
        });
      };
    }).done(function(){
      console.log('here');
      $(window).resize();
    });

    function noteHtml(note) {
      return `
      <div class='note' data-recording-id=${recordingId} data-note-id=${note.id} data-note-at=${note.at}>
        <div class='note-text'>${note.text}</div>
        <div class='note-controls'>
          <span class='play-at'>
            <svg width="17" height="17" fill="rgb(54, 125, 119)" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
              <path id="play" d="M24.8175,16.86432,9.503,25.77667A1,1,0,0,1,8,24.91235V7.08765a1,1,0,0,1,1.503-.86432L24.8175,15.13568A1.00006,1.00006,0,0,1,24.8175,16.86432Z"/>
            </svg>
              <span>Play at ${toMmSs(note.at)}</span>
          </span>
          <span class='edit-note'>
            <svg width="17" height="17" fill="rgb(54, 125, 119)" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
              <path id="pencil" d="M27.414,8.82812l-2.08588,2.08594L21.08588,6.67188l2.08587-2.08594a.99985.99985,0,0,1,1.41425,0l2.828,2.82812A.99986.99986,0,0,1,27.414,8.82812ZM8.08594,19.67188l4.24218,4.24218L23.91406,12.32812,19.67181,8.08594ZM4.27667,27.09863a.50005.50005,0,0,0,.62476.62476l5.92773-2.48023L6.75677,21.1709Z"/>
            </svg>
            <span>
              Edit note
            </span>
          </span>
          <span class='delete-note'>
            <svg width="17" height="17" fill="rgb(54, 125, 119)" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
              <path id="bin" d="M7,26a2.00006,2.00006,0,0,0,2,2H23a2.00006,2.00006,0,0,0,2-2V10H7ZM20,14a1,1,0,0,1,2,0V24a1,1,0,0,1-2,0Zm-5,0a1,1,0,0,1,2,0V24a1,1,0,0,1-2,0Zm-5,0a1,1,0,0,1,2,0V24a1,1,0,0,1-2,0ZM26,6V8H6V6A1,1,0,0,1,7,5h6V4a1,1,0,0,1,1-1h4a1,1,0,0,1,1,1V5h6A1,1,0,0,1,26,6Z"/>
            </svg>
            <span>
              Delete note
            </span>
          </span>
        </div>
      </div>
      `
    }

    function notePinHtml(note) {
      return `
        <span class='note-pin' data-note-id=${note.id} style="left:0px;">
          <svg width="25" height="25" fill="rgb(54, 125, 119)" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
            <path id="book-open-text" d="M25.99994,5h-6a4.99548,4.99548,0,0,0-4,2.00311,4.99548,4.99548,0,0,0-4-2.00311h-6a3.00335,3.00335,0,0,0-3,3V23a3,3,0,0,0,3,3h6a1.25185,1.25185,0,0,1,1.15454.77246A2.00011,2.00011,0,0,0,14.99634,28h2.00708a2.0004,2.0004,0,0,0,1.84241-1.22858A1.24982,1.24982,0,0,1,19.9989,26h6.001a3,3,0,0,0,3-3V8A3.00336,3.00336,0,0,0,25.99994,5Zm-11,19.00049h-.18359A2.99129,2.99129,0,0,0,11.99994,22h-6a1,1,0,0,1-1-1V8a1,1,0,0,1,1-1h6a3,3,0,0,1,3,3Zm12-3.00049a1,1,0,0,1-1,1h-6a2.99128,2.99128,0,0,0-2.81641,2.00049h-.18359V10a3,3,0,0,1,3-3h6a1,1,0,0,1,1,1Zm-14-3.5v1a.5.5,0,0,1-.5.5h-5a.5.5,0,0,1-.5-.5v-1a.5.5,0,0,1,.5-.5h5A.5.5,0,0,1,12.99994,17.5Zm0-4v1a.5.5,0,0,1-.5.5h-5a.5.5,0,0,1-.5-.5v-1a.5.5,0,0,1,.5-.5h5A.5.5,0,0,1,12.99994,13.5Zm0-4v1a.5.5,0,0,1-.5.5h-5a.5.5,0,0,1-.5-.5v-1a.5.5,0,0,1,.5-.5h5A.5.5,0,0,1,12.99994,9.5Zm12,0v1a.5.5,0,0,1-.5.5h-5a.5.5,0,0,1-.5-.5v-1a.5.5,0,0,1,.5-.5h5A.5.5,0,0,1,24.99994,9.5Zm-2,8v1a.5.5,0,0,1-.5.5h-3a.5.5,0,0,1-.5-.5v-1a.5.5,0,0,1,.5-.5h3A.5.5,0,0,1,22.99994,17.5Zm2-4v1a.5.5,0,0,1-.5.5h-5a.5.5,0,0,1-.5-.5v-1a.5.5,0,0,1,.5-.5h5A.5.5,0,0,1,24.99994,13.5Z"/>
          </svg>
        </span>
      `
    }
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
    $('.note').each(function(){
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

  // Autoscroll
  function updateAutoScroll() {
    let currentTime = document.getElementById('video-element').currentTime;
    let notesBeforeNow = sortedNotes().filter(function () { return $(this).data('note-at') <= currentTime });
    let note = notesBeforeNow[notesBeforeNow.length - 1];
    if (note && note != currentNote) {
      currentNote = note;
      note.scrollIntoView({
        behavior: 'smooth',
        block: 'center'
      });
      let notePin = $(`.note-pin[data-note-id="${$(note).data('note-id')}"]`);
      let noteTextDiv = $(note).find('.note-text');
      let textBackroundColor = noteTextDiv.css('background-color');
      noteTextDiv.animate({ backgroundColor: '#ffffed' }, 400).animate({ backgroundColor: textBackroundColor }, 400);
      notePin.find('svg').animate({ backgroundColor: '#ffffd1' }, 400).animate({ backgroundColor: 'white' }, 400);
    }
  }

  function sortedNotes() {
    return $('.note').sort(function (a, b) {
      if ($(a).data('note-at') > $(b).data('note-at')) {
        return 1;
      }
      else if ($(a).data('note-at') < $(b).data('note-at')) {
        return -1;
      }
      else {
        return 0
      }
    });
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

    $(window).resize(function(){
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

    $('#show-select').click(function () {
      showSelectOnly();
      clearMetadataFields();
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
    $('#header-left').click(function () {
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

    // Notes
    //////////////////////
    $(document).on('click', '.note-pin', function () {
      let note = $(`.note[data-note-id="${$(this).data('note-id')}"]`)[0];
      pause();
      note.scrollIntoView({
        behavior: 'smooth',
        block: 'center'
      });
      skipToTime($(note).data('note-at'));
    });

    $(document).on('click', '.play-at', function () {
      playAt($(this).closest('.note').data('note-at'))
    });

    $(document).on('click', '#create-note', function () {
      let noteAt = document.getElementById('video-element').currentTime;
      let form = $('#note-form');
      form.data('note-id', null);
      form.data('note-at', noteAt);
      $('#note-form-title').text(`New note at ${toMmSs(noteAt)}`);
      $('#note-overlay').hide().fadeIn(200);
      $('#note-overlay').css('visibility', 'visible');
    });

    $(document).on('click', '.edit-note', function () {
      let note = $(this).closest('.note');
      let noteAt = note.data('note-at');
      let noteId = note.data('note-id');
      let text = note.find('.note-text').html();
      let form = $('#note-form');
      form.data('note-id', noteId);
      form.data('note-at', noteAt);
      $('#edit-note').text(text);
      $('#note-form-title').text(`Note at ${toMmSs(noteAt)}`);
      $('#note-overlay').hide().fadeIn(200);
      $('#note-overlay').css('visibility', 'visible');
    });

    $(document).on('click', '#note-save', function () {
      let form = $('#note-form');
      let noteId = form.data('note-id');
      let text = $('#edit-note').val();
      let noteAt = form.data('note-at');
      if (noteId) {
        let note = $(`.note[data-note-id=${noteId}]`);
        note.find('.note-text').text(text);
      }
      $.post('/upsert_note', {
        id: recordingId,
        note_id: noteId,
        note_at: noteAt,
        text: text
      }).done(function () {
        $('#note-cancel').click();
        loadNotes();
      });
    });

    $(document).on('click', '.delete-note', function () {
      let note = $(this).closest('.note');
      let noteId = note.data('note-id');
      $(note).slideUp(150);
      $(note).promise().done(function () {
        $(note).remove();
      })
      $.post('/delete_note', {
        id: recordingId,
        note_id: noteId,
      })
    });

  })
}
