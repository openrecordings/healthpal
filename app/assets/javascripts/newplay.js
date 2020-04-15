if (document.querySelector('#play-view')) {
  var recordingId = null;

  function showSelect(){

  }

  function hideSelect(){
    console.log('foo');
    $('#search-and-select').animate({
      width: '50px'
    })
  }

  function showPlayback(){

  }

  function hidePlayback(){

  }

  $(document).ready(function() {
    hideSelect();

    $('.recording-list-item').click(function(){
      recordingId = $(this).data('recording-id');
      showPlayback();
    })

  })
}
