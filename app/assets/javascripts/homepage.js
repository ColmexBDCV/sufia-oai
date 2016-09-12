  var random_banner = function() {
    var random_number = Math.floor(Math.random()*(3-1+1)+1);
    var background_image = 'banner' + random_number + '.png';
    $('#home_header').css('background-image', "url(/assets/" + background_image + ")");
  };

  $(document).on('turbolinks:load', random_banner);
