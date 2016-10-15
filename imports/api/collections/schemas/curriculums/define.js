
//Regular Expressions

define = {};

define.imageFileRegEx = /^[A-Za-z0-9]+\.(?:jpg|jpeg|png)$/;
define.videoFileRegEx = /^[A-Za-z0-9]+\.(mp4|mov)$/;
define.audioFileRegEx = /^[A-Za-z0-9]+\.(m4a|mp3|wav|ogg|aac)$/;

define.isQuestion = function(type){
  return type == "MULTIPLE_CHOICE" || type == "BINARY" || type == "SCENARIO";
};

module.exports.define = define;

