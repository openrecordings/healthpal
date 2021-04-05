if (document.querySelector('#play-pause-button')) {
  var playVolume = 1.0;
  var autoScrollDisabled = false;

  function showPage() {
    $('#loader-container').hide();
    let videoElement = document.getElementById('video-element');
    if ($(videoElement).data('is-video')) {
      $('#video-play-view').removeClass('invisible');
      $(videoElement).show();
    } else {
      $('#audio-view, #audio-view-hide-tags').removeClass('invisible');
    }
  }

  function stripeTable() {
    $('.tag-row:visible:odd').addClass('odd-row');
    $('.tag-row:visible:even').addClass('even-row');
  }

  function togglePlayPause() {
    let videoElement = document.getElementById('video-element');
    if (videoElement.paused) {
      videoElement.play();
    }
    else {
      videoElement.pause();
    }
    $('#play-glyph, #pause-glyph, #play-label, #pause-label').toggleClass('invisible');
  }

  // Concept summary
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $('.concept-link').click(function(){
    $('#summary-title-text').text($(this).data('title'));
    $('#summary').html($(this).data('summary'));
    $('#concept-link-text').attr('href', $(this).data('url'));
    $('.summary-overlay').css('visibility', 'visible');
  })

  $('#close-summary').click(function(){
    $('.summary-overlay').css('visibility', 'hidden');
  })

  // Playback control
  /////////////////////////////////////////////////////////////////////////////////////////////////
  function loadAudio() {
    let videoElement = document.getElementById('video-element');
    let recordingId = $(videoElement).data('recording-id');
    videoElement.volume = playVolume;
    skipToTime(0);
  }

  $.arrayIntersect = function (a, b) {
    return $.grep(a, function (i) {
      return $.inArray(i, b) > -1;
    });
  };

  function playerListener() {
    let videoElement = document.getElementById('video-element');
    videoElement.ontimeupdate = function () {
      let currentTime = videoElement.currentTime;
      $('#current-time').text(toMmSs(currentTime));
      skipToTime(currentTime, false);
      updateTableHighlighting(currentTime);
      scrollTable();
    };
  }

  function skipToTime(newTime, updatePlayer = true) {
    let videoElement = document.getElementById('video-element');
    let timeline = $('#timeline');
    let playhead = $('#playhead');
    let progressBar = $('#progress-bar');
    let duration = $(videoElement).prop('duration');
    if (newTime < 0) { newTime = 0 };
    if (newTime > duration) { newTime = duration };
    if (updatePlayer) {
      // Update is driven by UI event - move player time
      videoElement.currentTime = newTime.toString();
    } else {
      // Update is driven by current play time - move playhead
      let timelineWidth = $('#timeline').width()
      let PxPerSec = timelineWidth / duration;
      let newPx = PxPerSec * newTime
      playhead.css({ left: newPx });
      progressBar.css({ width: newPx + 10 });
    }
  }

  function skipToEventPosition(event) {
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
    playhead.css({ left: eventX });
    if (timelinePosition.left + timeline.width() >= eventX) {
      progressBar.css({ width: timelinePosition.left + eventX - 10 });
    }
    videoElement.currentTime = newTime.toString();
  }

  // Search and filtering
  ///////////////////////////////////////////////////////////////////////////////////////////////////
  function updateVisibleRows() {
    let queryString = $('#search-input').val() && $('#search-input').val().toLowerCase();
    let tagTypeIdsShown = [];
    let conceptsShown = [];
    $('.filter-button').each(function () {
      if ($(this).hasClass('filter-on')) {
        tagTypeIdsShown.push($(this).data('tag-type-id'))
      }
    });
    $('.concept-filter').each(function () {
      if ($(this).hasClass('concept-filter-on')) {
        conceptsShown.push($(this).data('concept-text'));
      }
    });
    // Test all tag rows against filters and query string
    $('.tag-row').each(function () {
      let rowTagTypeIds = $(this).data('tag-type-ids');
      if (!tagTypeIdsShown.length || $.arrayIntersect(rowTagTypeIds, tagTypeIdsShown).length) {
        // Category check passed
        let rowConcepts = $(this).data('annotation-concepts');
        if (!conceptsShown.length || $.arrayIntersect(rowConcepts, conceptsShown).length) {
          // Concept check passed
          let rowText = $(this).data('text').toLowerCase();
          if (rowText.includes(queryString) || !queryString) {
            // Search string check passed
            $(this).show();
          } else {
            // Search string check did not pass
            $(this).hide();
          }
        } else {
          // Concept check did not pass
          $(this).hide();
        }
      } else {
        // Category check did not pass
        $(this).hide();
      }
    })
    if ($('.tag-row').not(':hidden').length) {
      $('#empty-result-message').hide();
    } else {
      $('#empty-result-message').show();
    }
  }

  $('.category-has-annotations').click(function () {
    let conceptsContainer = $(this).closest('.filter').find('.concepts-container');
    let svg = $(this).find('.expand-svg');
    let label = $(this).find('.expand-label');
    if (svg.hasClass('rotate-z-90')) {
      svg.removeClass('rotate-z-90');
      label.text('see more');
      conceptsContainer.slideUp('200');
    } else {
      svg.addClass('rotate-z-90');
      label.text('see less');
      conceptsContainer.slideDown('200');
    }
  })

  // Time display, row highlighting
  /////////////////////////////////////////////////////////////////////////////////////////////////
  function toMmSs(seconds) {
    let mm = Math.floor(seconds / 60);
    let ss = parseInt(seconds - mm * 60);
    return `${mm.toString().padStart(2, '0')}:${ss.toString().padStart(2, '0')}`
  }

  function scrollTable() {
    let highlightedCells = document.querySelector('.highlighted-row')
    if (highlightedCells && !autoScrollDisabled) {
      highlightedCells.scrollIntoView({
        behavior: 'smooth',
        block: 'center'
      });
    }
  }

  function updateTableHighlighting(currentTime) {
    $('.tag-row').children().removeClass('highlighted-row');
    let highlightRow = $('.tag-row').filter(function () {
      return $(this).data('start-time') <= currentTime && $(this).data('end-time') >= currentTime
    })
    highlightRow.children().addClass('highlighted-row');
  }

  // Tag Table listeners
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $('.click-to-seek').click(function () {
    let videoElement = document.getElementById('video-element');
    skipToTime($(this).data('start-time'))
    if (videoElement.paused) {
      $('#play-glyph, #pause-glyph, #play-label, #pause-label').toggleClass('invisible');
    }
    videoElement.play();
  })

  $('#tag-table').mouseover(function () {
    autoScrollDisabled = true;
  })

  $('#tag-table').mouseout(function () {
    autoScrollDisabled = false;
  })

  $('.external-link').mouseover(function () {
    let row = $(this).closest('.tag-row');
    row.removeClass('tag-row-hover');
  })

  $('.external-link').mouseout(function () {
    let row = $(this).closest('.tag-row');
    row.addClass('tag-row-hover');
  })


  // Playback control button listeners
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $('#timeline').click(function (event) {
    skipToEventPosition(event);
  })

  $('#playhead').draggable({
    axis: 'x',
    eontainment: '#timeline',
    drag: function (event, ui) {
      skipToEventPosition(event);
    }
  });

  $('#rewind-button').click(function () {
    let videoElement = document.getElementById('video-element');
    skipToTime(0);
  })

  $('#back-button').click(function () {
    let videoElement = document.getElementById('video-element');
    skipToTime(videoElement.currentTime - 10);
  })

  $('#play-pause-button').click(function () {
    togglePlayPause();
  })

  $('#forward-button').click(function () {
    let videoElement = document.getElementById('video-element');
    skipToTime(videoElement.currentTime + 10);
  })

  $('#mute-button').click(function () {
    let videoElement = document.getElementById('video-element');
    if (videoElement.volume > 0) {
      videoElement.volume = 0;
    }
    else {
      videoElement.volume = playVolume;
    }
    $('#mute-glyph, #unmute-glyph, #mute-label, #unmute-label').toggleClass('hidden');
  })

  $('.external-link').click(function (event) {
    event.stopPropagation();
  })

  // Sidebar listeners
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $('#search-input').focusin(function () {
    $('#search-icon').hide()
  })

  $('#search-input').focusout(function () {
    $('#search-icon').show()
  })

  $('#search-input').keyup(function (event) {
    let query = $(this).val();
    if (query.length > 0) {
      $('#close-icon').show();
    } else {
      $('#close-icon').hide();
    }
    updateVisibleRows();
  })

  $('#close-icon').click(function(){
    $('#search-input').val(null);
    $('#close-icon').hide();
    updateVisibleRows();
  })

  $('.concept-filter').click(function () {
    let categoryButton = $(this).closest('.filter').find('.filter-button');
    let categoryGlyph = $(this).closest('.filter').find('.filter-check').find('.check-glyph');
    let siblingConceptFilters = $(this).closest('.filter').find('.concept-filter').not($(this));
    let conceptGlyph = $(this).find('.concept-glyph')
    // Concept was already filtered when clicked
    if ($(this).hasClass('concept-filter-on')) {
      $(this).removeClass('concept-filter-on');
      conceptGlyph.addClass('hidden');
      // No other concepts are currently filtered for this category
      if (!siblingConceptFilters.hasClass('concept-filter-on')) {
        // Turn off filter for entire category
        categoryButton.find('.check-glyph').addClass('hidden');
      }
      // Turning on filter for concept
    } else {
      $(this).addClass('concept-filter-on');
      conceptGlyph.removeClass('hidden');
      // No other concepts are currently filtered for this category
      if (!siblingConceptFilters.hasClass('concept-filter-on')) {
        // Turn on filter for category, but no other concepts
        categoryButton.addClass('filter-on');
        categoryGlyph.removeClass('hidden');
      }
    }
    updateVisibleRows();
  })

  $('.filter-button').click(function () {
    let categoryGlyph = $(this).find('.check-glyph');
    let conceptGlyphs = $(this).closest('.filter').find('.concept-glyph');
    let conceptFilters = $(this).closest('.filter').find('.concept-filter');
    if ($(this).hasClass('filter-on')) {
      $(this).removeClass('filter-on');
      conceptFilters.removeClass('concept-filter-on');
      categoryGlyph.addClass('hidden');
      conceptGlyphs.addClass('hidden');
    } else {
      $(this).addClass('filter-on');
      conceptFilters.addClass('concept-filter-on');
      categoryGlyph.removeClass('hidden');
      conceptGlyphs.removeClass('hidden');
    }
    updateVisibleRows();
  })

  $('#show-all-topics').click(function () {
    $('.tag-row').show();
    $('.check-glyph').addClass('hidden');
    $('#search-input').val('');
  })

  // Onload
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $(document).ready(function () {
    loadAudio();
    stripeTable();
    playerListener();

    let videoElement = document.getElementById('video-element');

    videoElement.oncanplay = function () {
      showPage();
    }

    videoElement.ondurationchange = function () {
      $('#duration').text(toMmSs(videoElement.duration));
    }

    videoElement.onended = function () {
      $('#play-glyph, #pause-glyph, #play-label, #pause-label').toggleClass('invisible');
    }

  });
}
