if (document.querySelector('#play-view')) {
  var recordingId = null;

  function showSelect(){

  }

  function hideSelect(){
    $('#search-and-select').addClass('collapse');
  }

  function showPlayback(){

  }

  function hidePlayback(){
    $('#playback').addClass('collapse');
    $('#notes').addClass('collapse');
    $('#transport').addClass('collapse');
  }

  $(document).ready(function() {

    // hideSelect();

    $('.recording-list-item').click(function(){
      recordingId = $(this).data('recording-id');
      showPlayback();
    })

  })
}
