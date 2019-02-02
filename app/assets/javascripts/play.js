if(document.querySelector('#play-pause-button')) {
  // AJAX load audio data as Base64 TODO stream!
  /////////////////////////////////////////////////////////////////////////////////////////////////
  function loadAudio(){
    let audioElement = document.getElementById('audio-element');
    let getURL = 'send_audio/' + $(audioElement).data('recording-id') 
    $.get(getURL, function(data) {
      let src = 'data:audio/flac;base64,' + data
      $(audioElement).attr('src', src);
    });
    audioElement.loop = true;
  }

  // Audio element ontimeupdate events move the playhead
  function registerPlayerListener(){
    let audioElement = document.getElementById('audio-element');
    audioElement.ontimeupdate = function(){skipToTime(audioElement.currentTime, false)};
  }

  // Expects newTime to be a float
  function skipToTime(newTime, updatePlayer = true){
    let audioElement = document.getElementById('audio-element');
    let timeline = $('#timeline');
    let playhead = $('#playhead');
    let progressBar = $('#progress-bar');
    let duration = $(audioElement).prop('duration');
    if(newTime < 0){newTime = 0 };
    if(newTime > duration){newTime = duration};
    if(updatePlayer){
      // Update is driven by UI event - move player time
      $(audioElement).prop('currentTime', newTime);
    } else {
      // Update is driven by current play time - move playhead
      let timelineWidth = $('#timeline').width()
      let PxPerSec = timelineWidth / duration;
      let newPx = PxPerSec * newTime 
      playhead.css({left: newPx});
      progressBar.css({width: newPx - 10});
    }
  }

  // When the playhead is driving the player
  function skipToEventPosition(event){
    let audioElement = document.getElementById('audio-element');
    let eventX = event.pageX;
    let timeline = $('#timeline');
    let timelinePosition = timeline.position();
    let playhead = $('#playhead');
    let currentTime = $(audioElement).prop('currentTime');
    let duration = $(audioElement).prop('duration');
    let secPerPx = duration / $('#timeline').width();
    let newTime = secPerPx * eventX;
    let progressBar = $('#progress-bar');
    playhead.css({left: eventX});
    if(timelinePosition.left + timeline.width() >= eventX){
      progressBar.css({width: timelinePosition.left + eventX - 10});
    }
    $(audioElement).prop('currentTime', newTime);
  }

  // Progress bar click
  $('#timeline').click(function(event){
    skipToEventPosition(event);
  })

  // Playhead drag
  $('#playhead').draggable({
    axis: 'x',
    eontainment: '#timeline',
    drag: function(event, ui){
      skipToEventPosition(event);
    }
  });

  // Back button click
  $('#back-button').click(function(){
    let audioElement = document.getElementById('audio-element');
    skipToTime(audioElement.currentTime - 10);
  })

  // Forward button click
  $('#forward-button').click(function(){
    let audioElement = document.getElementById('audio-element');
    skipToTime(audioElement.currentTime + 10);
  })

  // Play-pause button 
  $('#play-pause-button').click(function(){
    let audioElement = document.getElementById('audio-element');
    if (audioElement.paused) {
       audioElement.play();
    }   
    else {
       audioElement.pause();
    }
    $('#play-glyph, #pause-glyph, #play-label, #pause-label').toggleClass('hidden');
  })

  // Onload
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $(document).ready(function() {
    loadAudio();
    registerPlayerListener();
  });
}
