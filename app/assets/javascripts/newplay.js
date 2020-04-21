if (document.querySelector('#play-view')) {
  var recordingId = null;

  function showSelect(){

  }

  function hideSelect(){
    $('#search-and-select').addClass('collapse');
  }

  function showPlayback(){
    $('#right').css('width', '100px');
  }

  function hidePlayback(){
    $('#right').css('width', '0px');
  }

  $(document).ready(function() {

    showPlayback();

    $('.recording-list-item').click(function(){
      recordingId = $(this).data('recording-id');
      showPlayback();
    })

  })
}
