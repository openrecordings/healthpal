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

  // Update playhead position
  /////////////////////////////////////////////////////////////////////////////////////////////////
  // function startPolling(){
  //   pollingTimer = setInterval(poll, 50);
  // }

  // function stopPolling(){
  //   clearInterval(pollingTimer);
  // }

  // function pollCurrentTime(){

  // }

  // Playback controls
  /////////////////////////////////////////////////////////////////////////////////////////////////
  function registerListeners() {
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

    // Progress bar click
    $('#timeline').click(function(event){
      console.log('here');
      let audioElement = document.getElementById('audio-element');
      let currentTime = $(audioElement).prop('currentTime');
      let duration = $(audioElement).prop('duration');
      let pxPerSec = $('#timeline').width() / duration;
      let newTime = pxPerSec * (currentTime / duration);
      $('#playhead').css({left: event.pageX});
      $('#progress-bar').css({width: event.pageX});
      $(audioElement).prop('currentTime', newTime);
    })

    // Register progress bar with Jquery.draggable 
    $('#playhead').draggable({
      axis: 'x',
      containment:'parent',
      drag: function(event, ui){
        $('#progress-bar').css({width: event.pageX - 10});
      },
    });
  }

  // Onload
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $(document).ready(function() {
    loadAudio();
    registerListeners();
  });

}
