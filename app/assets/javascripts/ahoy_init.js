$(document).ready(function() {
  ahoy.trackAll();
  
  // Track all elements with the 'track' class. Needed for clicks on elements that are not <a> or <button>
  $('.track').click(function(){
    ahoy.track('$click', {id: this.id, tag: this.previousSibling.nodeName, page: window.location.pathname, class: this.classList});
  })
});
