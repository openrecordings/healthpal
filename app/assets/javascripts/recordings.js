// Call the tag function when tags are selected or unselected
$(document).ready(function() {

  // Register editable recording provider
  $('.edit_provider').editable({
      type: 'text',
      name: 'provider',
      mode: 'inline',
      inputclass: 'editable-input'
  });

});

