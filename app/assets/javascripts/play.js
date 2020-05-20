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
    $('#playback').show();
    $('#search-and-select').hide();
  }

  // Creates or replaces the video element
  function loadVideo(recordingId){
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

    // TODO: figure this out
    if($(video).length > 0){
      var recordingId = $(this).data('recording-id');
      showPlayback();
      loadVideo(recordingId);
    }

    $('.recording-list-item').click(function(){
      var recordingId = $(this).data('recording-id');
      showPlayback();
      loadVideo(recordingId);
    })

    $('#show-select').click(function(){
      showSelect();
    })

    // Build the transport
    // Add the logic in play.js.old

  })
}
