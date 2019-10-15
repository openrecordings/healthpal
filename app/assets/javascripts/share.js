// Expects to Jquery-ized email input fields
// Returns a two-element array:
//   [0] true or false (true == both are valid)
//   [1] error message if any
function validateShareForm(firstName, lastName, email1, email2) {
  let regex = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  let invalidReason = null;
  if((email1 != email2) || !regex.test(String(email1).toLowerCase())){
    invalidReason = 'Emails invalid or do not match';
  }
  if(!(firstName.length && lastName.length)){
    invalidReason = 'First and last name are required';
  }
  if(invalidReason){
    return [false, invalidReason];
  } else {
    return [true]
  }
}

$(document).ready(function(){

  // AJAX post to create new share
  // Posts to a Rails REST route for creating a Share
  $('#new-share-submit').click(function(e) {
      e.preventDefault();
      var firstName = $('#first_name_').val(); 
      var lastName = $('#last_name_').val();
      var phoneNumber = $('#phone_number_').val().replace(/\D/g,'');
      var email1 = $('#email_').val();
      var email2 = $('#email2_').val();
      var validationResult = validateShareForm(firstName, lastName, email1, email2);
      if(validationResult[0]){
        $.post('/shares', {first_name: firstName, last_name: lastName, phone_number: phoneNumber, email: email1}, function(json) {
          // Success: refresh the page so that the content reflects the new Share
          location.reload();
        }).fail(function(error) {
          // TODO: Error message to screen
          console.log('Error creating share')
        })
      } else {
        alert(validationResult[1]);
      }
  })

  // When the user clicks the add-new-share button
  $('#open-share-form').click(function() {
    $('#open-share-form-title').remove();
    $(this).remove();
    $('#new-share-form').slideDown();
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
