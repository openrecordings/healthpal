if (document.querySelector('#play-view')) {
  var recordingId = null;
  var playVolume = 1.0;

  // Select/playback pane visibility
  /////////////////////////////////////////////////////////////////////////////////////////////////
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

  // Replace/create the video element and load from src URL
  /////////////////////////////////////////////////////////////////////////////////////////////////
  function loadVideo(){
    if(recordingId == null){
      console.log('Called loadVideo() but recordingId is null!');
      return
    }
    $.get(`/video_url/${recordingId}`, function(data){
      if(data.url){
        $('#video-container').html(`
          <video id=video-element>
            <source src=${data.url} type="audio/mp3">
          </video>`
        );
        $('#current-recording-title').html(recordingId);
        $('#spinner').show();
        var videoElement = document.getElementById('video-element');
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
        videoElement.onended = function(){
          $('#play-glyph, #pause-glyph, #play-label, #pause-label').toggleClass('invisible');
        }
      } else {
        console.log(data.error)
      }
    })
  }

  // Playback utilities
  /////////////////////////////////////////////////////////////////////////////////////////////////
  function togglePlayPause(){
    let videoElement = document.getElementById('video-element');
    if (videoElement.paused) {
       videoElement.play();
    }   
    else {
       videoElement.pause();
    }
    $('#play-glyph, #pause-glyph, #play-label, #pause-label').toggleClass('invisible');
  }

  function skipToTime(newTime, updatePlayer = true){
    let videoElement = document.getElementById('video-element');
    let timeline = $('#timeline');
    let playhead = $('#playhead');
    let progressBar = $('#progress-bar');
    let duration = $(videoElement).prop('duration');
    if(newTime < 0){newTime = 0 };
    if(newTime > duration){newTime = duration};
    if(updatePlayer){
      // Update is driven by UI event - move player time
      videoElement.currentTime = newTime.toString();
    } else {
      // Update is driven by current play time - move playhead
      let timelineWidth = $('#timeline').width()
      let PxPerSec = timelineWidth / duration;
      let newPx = PxPerSec * newTime 
      playhead.css({left: newPx});
      progressBar.css({width: newPx + 10});
    }
  }

  function skipToEventPosition(event){
    let videoElement = document.getElementById('video-element');
    let eventX = event.pageX - 50;
    let timeline = $('#timeline');
    let timelinePosition = timeline.position();
    let playhead = $('#playhead');
    let currentTime = $(videoElement).prop('currentTime');
    let duration = $(videoElement).prop('duration');
    let secPerPx = duration / $('#timeline').width();
    let newTime = secPerPx * eventX;
    let progressBar = $('#progress-bar');
    playhead.css({left: eventX});
    if(timelinePosition.left + timeline.width() >= eventX){
      progressBar.css({width: timelinePosition.left + eventX - 10});
    }
    videoElement.currentTime = newTime.toString();
  }

  function toMmSs(seconds){
    let mm = Math.floor(seconds / 60);
    let ss = parseInt(seconds - mm * 60);
    return `${mm.toString().padStart(2,'0')}:${ss.toString().padStart(2,'0')}`
  }

  // Playback control element listeners
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $('#timeline').click(function(event){
    skipToEventPosition(event);
  })

  $('#playhead').draggable({
    axis: 'x',
    eontainment: '#timeline',
    drag: function(event, ui){
      skipToEventPosition(event);
    }
  });

  $('#rewind-button').click(function(){
    let videoElement = document.getElementById('video-element');
    skipToTime(0);
  })

  $('#back-button').click(function(){
    let videoElement = document.getElementById('video-element');
    skipToTime(videoElement.currentTime - 10);
  })

  $('#play-pause-button').click(function(){
    togglePlayPause();
  })

  $('#forward-button').click(function(){
    let videoElement = document.getElementById('video-element');
    skipToTime(videoElement.currentTime + 10);
  })

  $('#mute-button').click(function(){
    let videoElement = document.getElementById('video-element');
    if (videoElement.volume > 0) {
       videoElement.volume = 0;
    }   
    else {
       videoElement.volume = playVolume;
    }
    $('#mute-glyph, #unmute-glyph, #mute-label, #unmute-label').toggleClass('hidden');
  })

  // !!! DISABLED TAG TABLE FUNCTIONS !!!
  /////////////////////////////////////////////////////////////////////////////////////////////////
  // function stripeTable(){
  //   $('.tag-row:visible:odd').addClass('odd-row');
  //   $('.tag-row:visible:even').addClass('even-row');
  // }
  //
  // function scrollTable() {
  //   let highlightedCells = document.querySelector('.highlighted-row')
  //   if(highlightedCells && !autoScrollDisabled){
  //       highlightedCells.scrollIntoView({
  //       behavior: 'smooth',
  //       block: 'center'
  //     });
  //   }
  // }
  //
  // function updateTableHighlighting(currentTime){
  //   $('.tag-row').children().removeClass('highlighted-row');
  //   let highlightRow = $('.tag-row').filter(function(){
  //     return $(this).data('start-time') <= currentTime && $(this).data('end-time') >= currentTime
  //   })
  //   highlightRow.children().addClass('highlighted-row');
  // }
  //
  // $('.click-to-seek').click(function(){
  //   let videoElement = document.getElementById('video-element');
  //   skipToTime($(this).data('start-time'))
  //   if(videoElement.paused){
  //     $('#play-glyph, #pause-glyph, #play-label, #pause-label').toggleClass('invisible');
  //   }
  //   videoElement.play();
  // })
  //
  // $('#tag-table').mouseover(function(){
  //   autoScrollDisabled = true;
  // })
  //
  // $('#tag-table').mouseout(function(){
  //   autoScrollDisabled = false;
  // })
  //
  // $('.external-link').click(function(event) {
  //   event.stopPropagation();
  // })

  // !!! DISABLED SEARCH AND FILTER FUNCTIONS !!!
  /////////////////////////////////////////////////////////////////////////////////////////////////
  // $('.filter-button').click(function(){
  //   $(this).toggleClass('filter-on');
  //   $(this).find('.check-glyph').toggleClass('hidden');
  //   updateVisibleRows();
  // })
  //
  // $('#show-all-topics').click(function(){
  //   $('.tag-row').show();
  //   $('.check-glyph').addClass('hidden');
  //   $('#search-input').val('');
  // })
  //
  // $('#search-input').keyup(function(event){
  //   updateVisibleRows();
  // })
  //
  // function updateVisibleRows(){
  //   let queryString = $('#search-input').val() && $('#search-input').val().toLowerCase();
  //   let tagTypeIdsShown = [];
  //   $('.filter-button').each(function(){
  //     if($(this).hasClass('filter-on')){
  //       tagTypeIdsShown.push($(this).data('tag-type-id') )
  //     }
  //   })
  //   // Test all tag rows against filters and query string
  //   $('.tag-row').each(function(){
  //     let rowTagTypeIds = $(this).data('tag-type-ids');
  //     if(!tagTypeIdsShown.length || $.arrayIntersect(rowTagTypeIds, tagTypeIdsShown).length){
  //       // Filter check passed
  //       let rowText = $(this).data('text').toLowerCase();
  //       if(rowText.includes(queryString) || !queryString){
  //         // Search string check passed
  //         $(this).show();
  //       } else {
  //         // Search string check did not pass
  //         $(this).hide();
  //       }
  //     } else {
  //       // Filter check did not pass
  //       $(this).hide();
  //     }
  //   })
  //   if($('.tag-row').not(':hidden').length){
  //     $('#empty-result-message').hide();
  //   } else {
  //     $('#empty-result-message').show();
  //   }
  // }
  //
  // $.arrayIntersect = function(a, b)
  // {
  //   return $.grep(a, function(i)
  //   {
  //     return $.inArray(i, b) > -1;
  //   });
  // };

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