if(document.querySelector('.user-field-content')){

  // User fields
  ///////////////////////////////////////////////////////////////////////////////////////////////////
  function hideSaveCancel(){
    $('.save, .cancel').hide();
  }

  $('.user-field-content').click(function(event){
    let contentField = event.target;
    let saveLink = $(contentField).parent().find('.save');
    let cancelLink = $(contentField).parent().find('.cancel');
    $(saveLink).show();
    $(cancelLink).show();
  })

  $(document).click(function(event){
    if(!$(event.target).closest('.user-field-content').length){
      hideSaveCancel();
    }
  });

  $('.save').click(function(event){
    hideSaveCancel();
    let userField = $(event.target).closest('.user-field-container').find('.user-field-content:first');
    let recordingId = $(userField).data('recording-id');
    let type = $(userField).data('type');
    let text = $(userField).val();
    $.post('user_field', {type: type, text: text})
  });

  $('.cancel').click(function(event){
    hideSaveCancel();
  });

  // Search
  ///////////////////////////////////////////////////////////////////////////////////////////////////
  function handleQuery(query){
    $('.tag-row').each(function(){
      let rowText = $(this).data('text').toLowerCase();
      if(!(rowText.includes(query))){
        $(this).hide();
      } else {
        $(this).show();
      }
    });
  }

  // Alpha-numeric keys
  $('#search-input').keypress(function(event){
    let inputElement = event.target;
    let query = $(inputElement).val().toLowerCase(); + String.fromCharCode(event.which).toLowerCase();;
    handleQuery(query);
  })

  // Delete/backspace key
  $('#search-input').keyup(function(event){
    if(event.which == 8){
      let inputElement = event.target;
      let query = $(inputElement).val()
      handleQuery(query);
    }
  })
  // Onload
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $(document).ready(function() {
  });
}
