var random_banner = function() {
    var random_number = Math.floor(Math.random()*(3-1+1)+1);
    var home_header_id = 'home_header_' + random_number;
    $('#home_header').attr("id",home_header_id);
};

$(document).on('turbolinks:load', random_banner);
