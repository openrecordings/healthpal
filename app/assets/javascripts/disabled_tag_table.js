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
