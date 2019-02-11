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
	$.post('user_field', {type: type, text: text}, function(data){
    log(data);
  })
});

$('.cancel').click(function(event){
  hideSaveCancel();
});
