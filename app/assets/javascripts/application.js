//= require jquery
//= require rails-ujs
//= require jquery-ui
//= require ahoy
//= require_tree .



// Event tracking
/////////////////////////////////////////////////////////////////////////////////////////////////
ahoy.trackAll();

// Track all elements with the 'track' class. Needed for clicks on elements that are not <a> or <button>
$('.track').click(function(){
  ahoy.track('$click', {id: this.id, tag: this.previousSibling.nodeName, page: window.location.pathname, class: this.classList});
})

// Destroy any existing Ahoy cookie upon login attempt
$('#login-button').click(function(){
  ahoy.reset();
})


// Utility
/////////////////////////////////////////////////////////////////////////////////////////////////
function log(msg){
  console.log(msg);
}
