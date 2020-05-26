if (document.querySelector('#play-view')) {
  var recordingId = null;
  var playVolume = 1.0;

  function showSelect(){
    $('#right').css('flex-grow', '0');
    $('#left').css('flex-grow', '1');
    $('#search-and-select').show();
    $('#right').hide();
  }

  function showPlayback(){
    $('#left').css('flex-grow', '0');
    $('#right').css('flex-grow', '1');
    $('#right').show();
    $('#search-and-select').hide();
  }

  function stripeTable(){
    $('.tag-row:visible:odd').addClass('odd-row');
    $('.tag-row:visible:even').addClass('even-row');
  }

  // Creates or replaces the video element
  // Presumes recordingId is already set correctly
  function loadVideo(){
    $.get(`/video_url/${recordingId}`, function(data){
      if(data.url){
        $('#video-container').html(`
          <video id=video-element>
            <source src=${data.url} type="audio/mp3">
          </video>`
        );
        $('#current-recording-title').html(recordingId);
        $('#spinner').show();
        videoElement.volume = playVolume;
        skipToTime(0);
        videoElement.oncanplay = function(){
          $('#spinner').hide();
        }
        videoElement.ondurationchange = function(){
          $('#duration').text(toMmSs(videoElement.duration));
        }
        videoElement.ontimeupdate = function(){
          let currentTime = videoElement.currentTime;
          $('#current-time').text(toMmSs(currentTime));
          skipToTime(currentTime, false);
          // !!! DISABLED TAG TABLE FUNCTIONS !!!
          // updateTableHighlighting(currentTime);
          // scrollTable();
        };
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