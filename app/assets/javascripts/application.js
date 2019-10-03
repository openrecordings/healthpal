//= require jquery
//= require rails-ujs
//= require jquery-ui
//= require ahoy
//= require_tree .



// Event tracking
/////////////////////////////////////////////////////////////////////////////////////////////////
ahoy.trackAll();
$('.track').click(function(){
  ahoy.track('$click', {id: this.id, tag: this.previousSibling.nodeName, page: window.location.pathname, class: this.classList})
})

// Utility
/////////////////////////////////////////////////////////////////////////////////////////////////
function log(msg){
  console.log(msg);
}
