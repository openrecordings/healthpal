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
    $.post('user_field', {id: recordingId, type: type, text: text})
  });

  $('.cancel').click(function(event){
    hideSaveCancel();
  });

  // Search
  ///////////////////////////////////////////////////////////////////////////////////////////////////
  function handleQuery(query){
    log(query);
    $('.tag-row').each(function(){
      let rowText = $(this).data('text').toLowerCase();
      if(!(rowText.includes(query))){
        $(this).hide();
      } else {
        $(this).show();
      }
    });
  }

  $('#search-input').keyup(function(event){
    let query = null;
    let inputElement = event.target;
    if(event.which == 8){
      query = $(inputElement).val()
    } else {
      query = $(inputElement).val().toLowerCase(); + String.fromCharCode(event.which).toLowerCase();;
    }
    handleQuery(query);
  })
  // Onload
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $(document).ready(function() {
  });
}
