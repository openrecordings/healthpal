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

    // showPlayback();

    $('.recording-list-item').click(function(){
      recordingId = $(this).data('recording-id');
      showPlayback();
    })

    $('#show-select').click(function(){
      showSelect();
    })

  })
}
