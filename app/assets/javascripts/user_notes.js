$(document).ready(function(){

  // TODO: DRY this up

  $('#new-note-badge').click(function() {
    $(this).hide();
    $('#note-container').show();
    $('#note-header').show();
    $('.best_in_place').click();
  })

  // This is brittle. Relies on view logic show/hiding the new note button to decide on initial
  // visability of note
  if(!$('#new-note-badge').length) {
    $('#note-container').show();
    $('#note-header').show();
  }

  $('#new-provider-badge').click(function() {
    $(this).hide();
    $('#provider-container').show();
    $('#provider-header').show();
    $('.best_in_place').click();
  })

  // This is brittle. Relies on view logic show/hiding the new note button to decide on initial
  // visability of note
  if(!$('#new-provider-badge').length) {
    $('#provider-container').show();
    $('#provider-header').show();
  }

});
