// TODO Put something less brittle in the conditional (?)
if(document.querySelector('#play-pause-button')) {

  // AJAX load audio data as Base64
  function loadAudio(){
		let getURL = 'send_audio/' + $('#audio-element').data('recording-id') 
    $.get(getURL, function(data) {
      let src = 'data:audio/flac;base64,' + data
      $('#audio-element').attr('src', src);
    });
  }

  function handleControlEvents(){
    var audioElement = document.getElementById('audio-element');
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

  // onload
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $(document).ready(function() {
    loadAudio();
    handleControlEvents();

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
