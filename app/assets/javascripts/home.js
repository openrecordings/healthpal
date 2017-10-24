// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  $(".tablesorter").each(function(index, value) {
    $(this).tablesorter({sortList: [[$(this).data("sort-column"), $(this).data("sort-desc")]]});
  });
});
