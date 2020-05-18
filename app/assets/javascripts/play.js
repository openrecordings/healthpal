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

  $(document).ready(function() {

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
