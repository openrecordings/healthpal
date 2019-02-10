$('.user_field_label').click(function(event){
  log('here');
  let label = event.target;
  let content = $(label).siblings('.user_field_content:first');
  $(label).hide();
  $(content).show();
})
