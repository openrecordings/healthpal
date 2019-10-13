//= require jquery
//= require rails-ujs
//= require jquery-ui
//= require ahoy
//= require_tree .

$(document).ready(function() {

  // // Event tracking
  // /////////////////////////////////////////////////////////////////////////////////////////////////
  // ahoy.trackAll();

  // // Reset Ahoy cookie on login page
  // /////////////////////////////////////////////////////////////////////////////////////////////////
  // if(window.location.pathname == '/users/sign_in'){
  //   ahoy.reset();
  // };
  // 
  // // Track all elements with the 'track' class. Needed for clicks on elements that are not <a> or <button>
  // $('.track').click(function(){
  //   ahoy.track('$click', {id: this.id, tag: this.previousSibling.nodeName, page: window.location.pathname, class: this.classList});
  // })

  // Utility
  /////////////////////////////////////////////////////////////////////////////////////////////////
  function log(msg){
    console.log(msg);
  }

});
