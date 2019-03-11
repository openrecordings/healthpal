// Expects to Jquery-ized email input fields
// Returns a two-element array:
//   [0] true or false (true == both are valid)
//   [1] error message if any
function validateEmail(email1, email2) {
  // TODO: Regex email validation
  // For now, just make sure that the two emails are the same
  if(email1 == email2){
    return [true, ''];
  } else {
    return [false, 'Emails do no match!'];
  }
}

$(document).ready(function(){

  // AJAX post to create new share
  // Posts to a Rails REST route for creating a Share
  $('#new-share-submit').click(function(e) {
      e.preventDefault();
      var emailFields = $(this).closest('form').find('input[type=email]');
      var email1 = emailFields.get(0).value;
      var email2 = emailFields.get(1).value;
      var validationResult = validateEmail(email1, email2);
      if(validationResult[0]){
        console.log('Posting to create');
        $.post('/shares', {email: email1}, function(json) {
          // Success: refresh the page so that the content reflects the new Share
          location.reload();
        }).fail(function(error) {
          // TODO: Error message to screen
          console.log('Error creating share')
        })
      } else {
        emailFields.val('');
        alert(validationResult[1]);
      }
  })

  // When the user clicks the add-new-share button
  $('#open-share-form').click(function() {
    $(this).parent().remove();
    $('#new-share-form').show();
  })

  // When the user clicks the stop-sharing button for a user
  // This is a Rails REST route for "deleting" a Share
  $('.revoke-share').click(function(){
    $.ajax({
      url: '/shares/' + $(this).data('share-id'),
      type: 'DELETE',
      success: function(json) {
        // Refresh the page so that the content reflects the revokation
        location.reload();
      },
      error: function(json) {
        // TODO: Error message to screen
        console.log('Error revoking share')
      },
    })
  })

});
