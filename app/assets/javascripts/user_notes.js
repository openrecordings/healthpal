$(document).ready(function(){
  $('.editable-badge').click(function() {
    console.log('here');
    $(this).hide();
    $('.editable-container').show();
    $('.editable-header').show();
    $('.best_in_place').click();
  })

  // This is brittle. Relies on view logic show/hiding the new note button to decide on initial
  // visability of the field
  if(!$('.editable-badge').length) {
    $('.editable-container').show();
    $('.editable-header').show();
  }
});
