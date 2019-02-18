if(document.querySelector('#index-view')) {
  function stripeTable(){
    $('tr:odd').addClass('odd-row');
    $('tr:even').addClass('even-row');
  }

  $('.tab').click(function(){
    let userId = $(this).data('user-id');
    $('.tab').removeClass('selected');
    $(this).addClass('selected');
    $('.content').hide();
    $(`[data-user-id=${userId}]`).show();
  })

  $(document).ready(function() {
    stripeTable();
  });
}
