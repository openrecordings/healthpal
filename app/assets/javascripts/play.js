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

  // onload
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $(document).ready(function() {
    loadAudio();

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
