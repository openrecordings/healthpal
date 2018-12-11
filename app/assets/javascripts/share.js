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
  $('#new-share-submit').click(function(e) {
      e.preventDefault();
      var emailFields = $(this).closest('form').find('input[type=email]');
      var email1 = emailFields.get(0).value;
      var email2 = emailFields.get(1).value;
      var validationResult = validateEmail(email1, email2);
      if(validationResult[0]){
        console.log('Posting to create');
        $.post('/shares', {email: email1}, function(json) {
          console.log(json);
        }).fail(function(error) {
          console.log(error.responseJSON.error);
        })
      } else {
        emailFields.val('');
        alert(validationResult[1]);
      }
  })
});
