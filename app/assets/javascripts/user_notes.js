$(document).ready(function(){

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

});
