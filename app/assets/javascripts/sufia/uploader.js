//= require fileupload/tmpl
//= require fileupload/jquery.iframe-transport
//= require fileupload/jquery.fileupload.js
//= require fileupload/jquery.fileupload-process.js
//= require fileupload/jquery.fileupload-validate.js
//= require fileupload/jquery.fileupload-ui.js
//
/*
 * jQuery File Upload Plugin JS Example
 * https://github.com/blueimp/jQuery-File-Upload
 *
 * Copyright 2010, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 */

(function( $ ){
  'use strict';

  $.fn.extend({
    sufiaUploader: function( options ) {
      // Initialize our jQuery File Upload widget.
      // TODO: get these values from configuration.
      this.fileupload({
        // xhrFields: {withCredentials: true},              // to send cross-domain cookies
        // acceptFileTypes: /(\.|\/)(png|mov|jpe?g|pdf)$/i, // not a strong check, just a regex on the filename
        // limitMultiFileUploadSize: 500000000, // bytes
        limitConcurrentUploads: 6,
        maxNumberOfFiles: 100,
        maxFileSize: 1073741824, // bytes, 1GB
        autoUpload: true,
        url: Routes.sufia_uploads_path({trailing_slash: true}),
        type: 'POST'
      })
      .bind('fileuploadadded', function (e, data) {
        $(e.currentTarget).find('button.cancel').removeClass('hidden');
      });
    }
  });
})(jQuery);
