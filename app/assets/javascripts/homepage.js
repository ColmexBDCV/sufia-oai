  var random_banner = function() {
    var random_number = Math.floor(Math.random()*(3-1+1)+1);
    var home_header_id = 'home_header_' + random_number;
    $('#home_header').attr("id",home_header_id);

    $('#material-fields').nestedFields();
    $('#measurement-fields').nestedFields();

    $('.select2-field').select2();

    var footer_height = $('footer.footer').height();
    $('body').css('margin-bottom', footer_height);

    $(window).resize(function(){
      var footer_height = $('footer.footer').height();
      $('body').css('margin-bottom', footer_height);
    });
  };

  $(document).on('turbolinks:load', random_banner);
