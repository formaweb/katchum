$(window).on('load', function() {

  $('#changePassword button').on('click', function() {
    $(this).button('loading');
    $('#changePassword').modal('hide');
    return false;
  });

  $('#changePassword').on('hidden.bs.modal', function() {
    $(this).submit();
  });

});