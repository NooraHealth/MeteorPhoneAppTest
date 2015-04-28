Meteor.startup ()->
  UploadServer.init {
    tmpDir:process.env.PWD +  '/.uploads/tmp'
    uploadDir: process.env.PWD + '/.uploads'
    checkCreateDirectories: true
  }


if Meteor.isCordova
  Uploader.uploadUrl = Meteor.absoluteUrl(".upload")
