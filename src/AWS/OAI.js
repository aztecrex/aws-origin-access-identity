'use strict';


function doNativeRequest(s, cb) {
  setTimeout(function() { cb(s); }, 1000);
}

exports.createOAIImpl = function(callback) {
  return function(request) {
    return function() {
      doNativeRequest(request, function(response) {
        callback(response)();
      });
    }
  }
}
