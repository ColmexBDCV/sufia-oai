// $(document).on('turbolinks:load', initFileBrowser);

function initFileBrowser() {
  // Import directory location browser init
  $('#import_file_browser').fileTree({
    script: Routes.browse_imports_path(),
    expandSpeed: 500,
    collapseSpeed: 500,
    multiFolder: false,
    folderCallback: function(file) {
      $('#import_server_import_location_name').val(file);
    },
    errorCallback: function(file, el) {
      $('#import_server_import_location_name').val( $(el).parent().attr('rel') );
    }
  });
}

function startImportProgressBar(import_id) {
  var refreshInterval = setInterval(function() {
    $.getJSON(Routes.import_path(import_id), function(data) {
      var pct = parseInt(data.percent_records_imported);
      $('.progress-bar').attr('aria-valuenow', pct).css('width', pct+'%').text(pct+'%');

      if (pct >= 100) {
        setTimeout(function() {
          clearInterval(refreshInterval);
          window.location.reload();
        }, 1500);
      }
    });
  }, 5000);
}

function startUndoProgressCheck(import_id) {
  var checkInterval = setInterval(function() {
    $.getJSON(Routes.import_path(import_id), function(data) {
      if (data.status != 'reverting') {
        clearInterval(checkInterval);
        window.location.reload();
      }
    });
  }, 3000);
}

$(document).ready(function () {
  $(".select").select2()
  $(".owl-carousel").owlCarousel({
    navigation : true, // Show next and prev buttons
    itemsDesktop : [1199,3],
      itemsDesktopSmall : [979,3],
    singleItem:true
  })
})
