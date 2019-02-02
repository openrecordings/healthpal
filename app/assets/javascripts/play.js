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
    // Playhead follows audio element during playback
    audioElement.ontimeupdate = function(event){skipToTime(audioElement.currentTime) }
  }

  // Expects newTime to be a float
  function skipToTime(newTime){
    let audioElement = document.getElementById('audio-element');
    let eventX = event.pageX;
    let timeline = $('#timeline');
    let timelinePosition = timeline.position();
    let playhead = $('#playhead');
    let currentTime = $(audioElement).prop('currentTime');
    let duration = $(audioElement).prop('duration');
    let PxPerSec = $('#timeline').width() / duration;
    let progressBar = $('#progress-bar');
    let newPx = PxPerSec * newTime 
    playhead.css({left: newPx});
    progressBar.css({width: newPx - 10});
  }

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
    containment: '#timeline',
    drag: function(event, ui){
      skipToEventPosition(event);
    }
  });

  $('#back-button').click(function(){
    let audioElement = document.getElementById('audio-element');
    console.log($(audioElement).prop('currentTime'));
    console.log($(audioElement).prop('duration'));
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
  });
}
