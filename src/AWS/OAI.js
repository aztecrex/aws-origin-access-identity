'use strict';

const AWS = require("aws-sdk");
var cloudfront = new AWS.CloudFront();

function doCreateOAI(ref, cb) {
  const cf = new AWS.CloudFront();
  cf.createCloudFrontOriginAccessIdentity({
    CloudFrontOriginAccessIdentityConfig: {
      CallerReference: ref,
      Comment: "Created from Purescript Lambda Booyah"
    }
  }, function (err, data) {
    if (err)
      cb(JSON.stringify(err));
    else
      cb(null, data);
  });
}

function doGetOAI(id, cb) {
  const cf = new AWS.CloudFront();
  cf.getCloudFrontOriginAccessIdentity({
    Id: id
  }, function (err, data) {
    if (err)
      cb(JSON.stringify(err));
    else
      cb(null, data);
  });
}

exports.identity = function(oai) {
  return oai.CloudFrontOriginAccessIdentity.Id;
};

exports.reference = function(oai) {
  return oai.
    CloudFrontOriginAccessIdentity.
    CloudFrontOriginAccessIdentityConfig.
    CallerReference;
};

exports.canonical = function(oai) {
  return oai.CloudFrontOriginAccessIdentity.S3CanonicalUserId;
};

exports.createOAIImpl = function (cberror) {
  return function (cbsuccess) {
    return function (reference) {
      return function () {
        doCreateOAI(reference, function(err, succ) {
          if (err)
            cberror(err)();
          else
            cbsuccess(succ)();
        });
      }
    }
  }
}

exports.getOAIImpl = function (cberror) {
  return function (cbsuccess) {
    return function (identity) {
      return function () {
        doGetOAI(identity, function(err, succ) {
          if (err)
            cberror(err)();
          else
            cbsuccess(succ)();
        });
      }
    }
  }
}
