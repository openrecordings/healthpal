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
  }

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

  function skipToTime(event){
    let audioElement = document.getElementById('audio-element');
    let clickX = event.pageX;
    let currentTime = $(audioElement).prop('currentTime');
    let duration = $(audioElement).prop('duration');
    let secPerPx = duration / $('#timeline').width();
    let newTime = secPerPx * clickX;
    $('#playhead').css({left: clickX});
    $('#progress-bar').css({width: clickX});
    $(audioElement).prop('currentTime', newTime);
  }

  // Progress bar click
  $('#timeline').click(function(event){
    skipToTime(event);
  })

  // Playhead drag
  $('#playhead').draggable({
    axis: 'x',
    containment:'parent',
    drag: function(event, ui){
      $('#progress-bar').css({width: event.pageX - 10});
    },
    stop: function(event, ui){
      skipToTime(event);
    }
  });

  // Onload
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $(document).ready(function() {
    loadAudio();
  });
}
