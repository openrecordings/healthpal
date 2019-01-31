// TODO Put something less brittle in the conditional (?)
if(document.querySelector('#play-pause-button')) {
  let audioElement = document.getElementById('audio-element');

  // AJAX load audio data as Base64
  /////////////////////////////////////////////////////////////////////////////////////////////////
  function loadAudio(){
		let getURL = 'send_audio/' + $('#audio-element').data('recording-id') 
    $.get(getURL, function(data) {
      let src = 'data:audio/flac;base64,' + data
      $('#audio-element').attr('src', src);
    });
  }

  // Playback control buttons
  /////////////////////////////////////////////////////////////////////////////////////////////////
  function registerPlaybackControlHandlers(){
    registerPlayPauseButton();
    registerRewindButton();
    registerMuteButton();
  }

  function registerPlayPauseButton(){
		$('#play-pause-button').click(function(){
			if (audioElement.paused) {
				 audioElement.play();
			}   
			else {
				 audioElement.pause();
			}
			$('#play-glyph, #pause-glyph, #play-label, #pause-label').toggleClass('hidden');
		})
  }

  function registerBackButton(){
  }

  function registerMuteButton(){
  }

  function skipToTimelineClick(){
  }

  // onload
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $(document).ready(function() {
    loadAudio();
    registerPlaybackControlHandlers();

    // Apply Jquery draggable to playhead
    $('#playhead').draggable({
      axis: 'x',
      containment:'parent',
      drag: function(event, ui){
        $('#progress-bar').css({width: event.pageX - 10});
      },
    });

    // Move playhead to click position in timeline
    $('#timeline').click(function(event){
      let timelineWidth = $(this).width();
      let pxFromLeft = event.pageX - this.offsetLeft;
      let proportionOfWidth = pxFromLeft / timelineWidth
      $('#playhead').css({left: event.pageX});
      $('#progress-bar').css({width: event.pageX});
    });
  });

}
