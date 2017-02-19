'use strict';


function doNativeRequest(s, cb) {
  if (s === "Boink")
    setTimeout(function() { cb(new Error("my word!")); }, 500);
  else
    setTimeout(function() { cb(null, s); }, 1000);
}

exports.createOAIImpl = function (cberror) {
  return function (cbsuccess) {
    return function (request) {
      return function () {
        doNativeRequest(request, function(err, succ) {
          if (err)
            cberror(err)();
          else
            cbsuccess(succ)();
        });
      }
    }
  }
}
