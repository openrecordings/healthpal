if (document.querySelector('#play-view')) {

  var recordingId = null;

  function showSelect(){
    $('#right').css('flex-grow', '0');
    $('#left').css('flex-grow', '1');
    $('#search-and-select').show();
    $('#playback').hide();
  }

  function showPlayback(){
    $('#left').css('flex-grow', '0');
    $('#right').css('flex-grow', '1');
    $('#right').show();
    $('#search-and-select').hide();
  }

  // Creates or replaces the video element
  // Presumes recordingId is already set correctly
  // TODO: Trun off controls
  function loadVideo(){
    $.get(`/video_url/${recordingId}`, function(data){
      if(data.url){
        $('#video-element').html(`
          <video id=video-player controls>
            <source src=${data.url} type="audio/mp3">
          </video>`
        );
      } else {
        console.log(data.error)
      }
    })
  }

  $(document).ready(function() {
    recordingId = $('#play-view').data('initial-recording-id');

    if(recordingId != null){
      loadVideo();
      showPlayback();
    }

    $('.recording-list-item').click(function(){
      recordingId = $(this).data('recording-id');
      loadVideo();
      showPlayback();
    })

    $('#show-select').click(function(){
      showSelect();
    })

    // Build the transport
    // Add the logic in play.js.old

  })
}
