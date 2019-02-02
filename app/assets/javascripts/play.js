if(document.querySelector('#play-pause-button')) {
  const playVolume = 1.0;

  function loadAudio(){
    let audioElement = document.getElementById('audio-element');
    audioElement.loop = true;
    audioElement.volume = playVolume;
  }

  function registerPlayerListeners(){
    let audioElement = document.getElementById('audio-element');
    audioElement.ontimeupdate = function(){skipToTime(audioElement.currentTime, false)};
    audioElement.oncanplaythrough = function(){
      // TODO Remove. Temporary hack to immediately delete tmp file on server
      $.post('rm_tmp_file', {id: $(audioElement).data('recording-id')});
    }
  }

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

  // Timeline clicks and drags
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $('#timeline').click(function(event){
    skipToEventPosition(event);
  })

  $('#playhead').draggable({
    axis: 'x',
    eontainment: '#timeline',
    drag: function(event, ui){
      skipToEventPosition(event);
    }
  });

  // Playback control button clicks
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $('#rewind-button').click(function(){
    let audioElement = document.getElementById('audio-element');
    skipToTime(0);
  })

  $('#back-button').click(function(){
    let audioElement = document.getElementById('audio-element');
    skipToTime(audioElement.currentTime - 10);
  })

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

  $('#forward-button').click(function(){
    let audioElement = document.getElementById('audio-element');
    skipToTime(audioElement.currentTime + 10);
  })

  $('#mute-button').click(function(){
    let audioElement = document.getElementById('audio-element');
    console.log(audioElement.volume);
    if (audioElement.volume > 0) {
       audioElement.volume = 0;
    }   
    else {
       audioElement.volume = playVolume;
    }
    $('#mute-glyph, #unmute-glyph, #mute-label, #unmute-label').toggleClass('hidden');
  })

  // Onload
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $(document).ready(function() {
    loadAudio();
    registerPlayerListeners();
  });
}
