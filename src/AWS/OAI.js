'use strict';

const AWS = require("aws-sdk");
const cloudFront = new AWS.CloudFront();

function doCreateOAI(ref, cb) {
  cloudFront.createCloudFrontOriginAccessIdentity({
    CloudFrontOriginAccessIdentityConfig: {
      CallerReference: ref,
      Comment: ref
    }
  }, function (err, data) {
    if (err)
      cb(JSON.stringify(err));
    else
      cb(null, data);
  });
}

function doGetOAI(id, cb) {
  cloudFront.getCloudFrontOriginAccessIdentity({
    Id: id
  }, function (err, data) {
    if (err)
      cb(JSON.stringify(err));
    else
      cb(null, data);
  });
}

function doListOAIs(prev, cb) {
  prev = prev || {};
  cloudFront.listCloudFrontOriginAccessIdentities({
    Marker: prev.NextMarker
  }, function (err, data) {
    if (err)
      cb(JSON.stringify(err));
    else
      cb(null, data);
  });
}

exports.identity = function(oai) {
  return oai.Id || oai.CloudFrontOriginAccessIdentity.Id;
};

exports.reference = function(oai) {
  return (oai.CloudFrontOriginAccessIdentity &&
    oai.
    CloudFrontOriginAccessIdentity.
    CloudFrontOriginAccessIdentityConfig.
    CallerReference) || "<Unknown>";
};

exports.canonical = function(oai) {
  return  oai.S3CanonicalUserId ||
          oai.CloudFrontOriginAccessIdentity.S3CanonicalUserId;
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

exports.listOAIsImpl = function (cberror) {
  return function (cbsuccess) {
    return function () {
      doListOAIs(null, function(err, succ) {
        if (err)
          cberror(err)();
        else
          cbsuccess(succ)();
      });
    }
  }
}

exports.listMoreOAIsImpl = function (cberror) {
  return function (cbsuccess) {
    return function (oaipage) {
      return function () {
        doListOAIs(oaipage, function(err, succ) {
          if (err)
            cberror(err)();
          else
            cbsuccess(succ)();
        });
      }
    }
  }
}

exports.more = function (oaipage) {
  return !!(oaipage.CloudFrontOriginAccessIdentityList.NextMarker)
}

exports.unpage = function (oaipage) {
  return oaipage.CloudFrontOriginAccessIdentityList.Items
}

exports.showData = function (data) {
  return JSON.stringify(data);
}
