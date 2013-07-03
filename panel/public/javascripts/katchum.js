$(window).on('load', function() {

  $('.btn[href="#changePassword"]').on('click', function() {
    username = $(this).parents('tr').find('.username').text();
    action = $('#changePassword').attr('action');

    $('#changePassword').attr('action', action.replace('username', username));
  });

  $('#changePassword button').on('click', function() {
    $(this).button('loading');
    $('#changePassword').modal('hide');
    return false;
  });

  $('#changePassword').on('hidden.bs.modal', function() {
    $(this).submit();
  });

});