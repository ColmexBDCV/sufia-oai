  var random_banner = function() {
    var random_number = Math.floor(Math.random()*(3-1+1)+1);
    var home_header_id = 'home_header_' + random_number;
    $('#home_header').attr("id",home_header_id);

    // var footer_height = ($('footer.footer').height() + 30);
    // $('body').css('margin-bottom', footer_height);
    //
    // $(window).resize(function(){
    //   var footer_height = $('footer.footer').height();
    //   $('body').css('margin-bottom', footer_height);
    // });

    $('#material-fields').nestedFields();
    $('#measurement-fields').nestedFields();

    $('.select2-field').select2();
  };

  $(document).on('turbolinks:load', random_banner);
