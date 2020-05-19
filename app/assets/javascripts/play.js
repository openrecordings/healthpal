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

  // Expects data-recording-id to hold a valid recording ID
  function insertVideo(){
    var recordingId = $('#play-view').data('recording-id')
    if(recordingId != null){
      $.ajax({
        url: '/video_url',
        data: recordingId,
        success: function() {
          $('#video-element').html(`
            <video controls>
              <source src=${data.url} type="audio/mp3">
            </video>`
          );
        },
        error: console.log('Error loading recording')
      });
    }
  }


  $(document).ready(function() {

    // TODO: Run onload only if data-recording-id is not null
    //       Run if data-recording-id gets set, e.g., selecting a recording
    insertVideo();

    // - Management of the video element
    //   - add it via JS if data-recording-id is not null on load
    //     plan 1: Have Rails generate the HTML
    //     plan 2: Add the HTML from here (just fetch the media URL via AJAX)
    //   - create it when a recording is selected if data-recording-id is initially null
    //   - replace the src when a new recording is selected
    // - Build the transport
    // - Add the logic in play.js.old

    $('.recording-list-item').click(function(){
      recordingId = $(this).data('recording-id');
      showPlayback();
    })

    $('#show-select').click(function(){
      showSelect();
    })

  })
}
