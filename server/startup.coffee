Meteor.startup ()->
  S3.config= {
    key: process.env.AWS_ACCESS_KEY,
    secret: process.env.AWS_SECRET_ACCESS_KEY,
    bucket: 'elasticbeanstalk-us-west-1-584511731882',
    region: "us-west-1"
  }
  #UploadServer.init {
    #tmpDir:process.env.PWD +  '/.uploads/tmp'
    #uploadDir: process.env.PWD + '/.uploads'
    #checkCreateDirectories: true
  #}


