// Expects to Jquery-ized email input fields
// Returns a two-element array:
//   [0] true or false (true == both are valid)
//   [1] error message if any
function validateEmails(emailFields) {
  // TODO: Regex email validation
  // For now, just make sure that the two emails are the same
  email1 = emailFields.get(0).value;
  email2 = emailFields.get(1).value;
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
      var validationResult = validateEmails(emailFields);
      if(validationResult[0]){
        console.log('yep');
      } else {
        console.log(validationResult[1]);
      }
  })
});
