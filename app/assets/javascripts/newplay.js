if (document.querySelector('#play-view')) {
  var recordingId = null;

  function showSelect(){

  }

  function showPlayback(){
    $('#left').css('flex-grow', '0');
    $('#right').css('flex-grow', '1');
    $('#playback').fadeIn();
    $('#search-and-select').hide();
    $('#select-collapsed').fadeIn();
  }

  $(document).ready(function() {

    // showPlayback();

    $('.recording-list-item').click(function(){
      recordingId = $(this).data('recording-id');
      showPlayback();
    })

  })
}
