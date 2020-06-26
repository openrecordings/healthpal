if (document.querySelector('#play-view')) {
  // TODO: recordingId should not be global. Works now but will not scale. Each function should fetch it.
  var recordingId = null;
  var playVolume = 1.0;
  var playerPadding = null;
  var playheadRadius = null;
  var lastTime = 0.0;
  var animationDuration = 300;

  // Selection/playback pane visibility
  /////////////////////////////////////////////////////////////////////////////////////////////////
  function showSelectOnly(){
    $('#left').css({'transform': 'scaleX(1)'});
    $('#left').css({'min-width': '100%'});
    $('#right').css({'transform': 'scaleX(0)'});
    $('#right').css({'min-width': '0'});
  }

  function showPlaybackOnly(){
    $('#left').css({'transform': 'scaleX(0)'});
    $('#left').css({'min-width': '0'});
    $('#right').css({'transform': 'scaleX(1)'});
    $('#right').css({'min-width': '100%'});
  }

  function clearMetadataFields(){
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
    $.get(`/get_metadata/${recordingId}`, function(data) {
      if(data) {
        // NOTE: We actually use an audio element for now so that Safari iOS doesn't override the player UI
        $('#video-container').html(`
          <audio id=video-element>
            <source src=${data.url} type="audio/mp3">
          </audio>`
        );
        $('#recording-title').text(data.title);
        $('#edit-recording-title').val(data.title);
        if(data.provider && data.provider.length > 0){
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
          // !!! DISABLED TAG TABLE FUNCTIONS !!!
          // updateTableHighlighting(currentTime);
          // scrollTable();
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

  function loadNotes(){
    let notesHeader = $('#notes-header');
    let notesContainer = $('#notes-container');
    let noNotes = $('#no-notes');
    $('.note').remove();
    $.get(`/get_notes/${recordingId}`, function(data){
      if(data.error){
        console.log(data.error);
        return;
      };
      if(data.notes.length == 0){
        notesHeader.hide();
        notesContainer.hide();
        noNotes.show();
      } else {
        notesHeader.show();
        notesContainer.show();
        noNotes.hide();
        data.notes.forEach(function(note){
          notesContainer.append(noteHtml(note))
        });
      };
    });

    function noteHtml(note){
      return `
      <div class='note' data-recording-id=${recordingId} data-note-id=${note.id} data-note-at=${note.at}>
        <div class='note-text'>${note.text}</div>
        <div class='note-controls'>
          <span class='play-at'>
            <svg width="17" height="17" fill="rgb(54, 125, 119)" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
              <path id="play" d="M24.8175,16.86432,9.503,25.77667A1,1,0,0,1,8,24.91235V7.08765a1,1,0,0,1,1.503-.86432L24.8175,15.13568A1.00006,1.00006,0,0,1,24.8175,16.86432Z"/>
            </svg>
              <span>
              Play at ${toMmSs(note.at)}
            </span>
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
    togglePlayPauseButton();
  }

  function togglePlayPauseButton(){
    $('#play-glyph, #pause-glyph, #play-label, #pause-label').toggleClass('hidden');
  }
  
  function skipToTime(newTime){
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
    let PxPerSec = timelineWidth / duration;
    let animationDuration = '0';
    // A crude way to avoid async animations getting mucked up when skipping around in the recording
    if(Math.abs(timeDelta) < 1.0){ animationDuration = timeDelta };
    lastTime = newTime;
    playhead.css('transition-duration', `${animationDuration}s`);
    progressBar.css('transition-duration', `${animationDuration}s`);
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
    $('#header-left').click(function(){
      $('#metadata-overlay').hide().fadeIn(200);
      $('#metadata-overlay').css('visibility', 'visible');
    });

    $('#metadata-save').click(function(){
      let title = $('#edit-recording-title').val();
      let provider = $('#edit-recording-provider').val();
      if(title.length === 0){
        alert('Recording name is required');
        return;
      }
      let selectDiv = $(`.recording-list-item[data-recording-id=${recordingId}]`)
      let selectDivTitle = $(selectDiv).find('.recording-title');
      $('#recording-title').text(title);
      $(selectDivTitle).text(title);
      if(provider.length > 0){
        let selectDivProvider = $(selectDiv).find('.recording-provider');
        $('#recording-provider').text(provider);
        $(selectDivProvider).text(provider);
      } else {
        provider = null;
      }
      $.post('/update_metadata', {id: recordingId, title: title, provider: provider});
      $('#metadata-cancel').click();
    });

    // Notes
    //////////////////////
    $(document).on('click', '.play-at',function(){ 
      playAt($(this).closest('.note').data('note-at'))
    });

    $(document).on('click', '.edit-note',function(){ 
      let note = $(this).closest('.note');
      let noteAt = note.data('note-at');
      let noteId = note.data('note-id');
      let text = note.find('.note-text').html();
      console.log(text);
      let form = $('#note-form');
      form.data('note-id', noteId);
      form.data('note-at', noteAt);
      $('#edit-note').text(text);
      $('#note-form-title').text(`Note at ${toMmSs(noteAt)}`);
      $('#note-overlay').hide().fadeIn(200);
      $('#note-overlay').css('visibility', 'visible');
    });

    $(document).on('click', '#note-save',function(){ 
      let form = $('#note-form');
      let noteId = form.data('note-id');
      let text = $('#edit-note').val();
      let note = $(`.note[data-note-id=${noteId}]`);
      let noteAt = form.data('note-at');
      note.find('.note-text').text(text);
      $.post('/upsert_note', {
        id: recordingId,
        note_id: noteId,
        note_at: noteAt,
        text: text
      });
      $('#note-cancel').click();
    });

    $(document).on('click', '.delete-note',function(){ 
      let note = $(this).closest('.note');
      let noteId = note.data('note-id');
      $(note).remove();
      // TODO: Ajax delete note
    });

  })
}
