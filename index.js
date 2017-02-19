"use strict";

const Handler = require('./output/Handler')

exports.handler = function(data, context) {
  Handler.handler(context)(data)();
};
