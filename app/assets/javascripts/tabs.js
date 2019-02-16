if(document.querySelector('#index-view')) {
  $('.tab').click(function(){
    let userId = $(this).data('user-id');
    $('.tab').removeClass('selected');
    $(this).addClass('selected');
    $('.content').hide();
    $(`[data-user-id=${userId}]`).show();
  })

  $(document).ready(function() {
  });
}
