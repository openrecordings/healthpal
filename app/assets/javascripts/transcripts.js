// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// Call the server to update tags in the db
function tag(uid, label, on) {
  $.get("/utterances/" + uid + (on? "/":"/un") + "set_tag/"+label, function(data) {
    // TODO: Do something with tagging return value - (report errors or synchronize tags)
  });
}


// Call the tag function when tags are selected or unselected
$(document).ready(function() {
  $(".tagger").on("select2:select", function (e) {
    tag($(this).attr("utterance"), e.params.data.text, true);
  });
  $(".tagger").on("select2:unselect" , function (e) {
    tag($(this).attr("utterance"), e.params.data.text, false);
  });

  // Register editable utterance text
  $('.edit_utterance').editable({
      type: 'text',
      name: 'text',
      mode: 'inline',
      inputclass: 'editable-input'
  });

});
