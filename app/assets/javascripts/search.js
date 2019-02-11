if(document.querySelector('#search-input')) {

  function handleKeyPress(){
    let searchElement = document.getElementById('#search-input');
    log($(searchElement));
  }

  // Listeners
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $('#search-input').keypress(function(event){
    handleKeyPress(event.target);
  })

  // Onload
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $(document).ready(function() {
  });

}
