'use strict';

const AWS = require("aws-sdk");
var cloudfront = new AWS.CloudFront();

function doNativeRequest(clid, cb) {
  const cf = new AWS.CloudFront();
  cf.createCloudFrontOriginAccessIdentity({
    CloudFrontOriginAccessIdentityConfig: {
      CallerReference: clid,
      Comment: "Created from Purescript Lambda Booyah"
    }
  }, function (err, data) {
    if (err)
      cb(JSON.stringify(err));
    else
      cb(null, JSON.stringify(data));
  });
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
