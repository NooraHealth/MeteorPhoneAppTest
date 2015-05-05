Meteor.startup ()->
  Meteor.settings.AWSAccessKeyId = process.env.AWS_ACCESS_KEY
  Meteor.settings.AWSSecretAccessKey = process.env.AWS_SECRET_ACCESS_KEY
  console.log Meteor.settings

  Slingshot.createDirective "s3",Slingshot.S3Storage, {
    bucket: BUCKET
    acl: "public-read",
    AWSAccessKeyId: process.env.AWS_ACCESS_KEY
    AWSSecretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
    region: REGION,
    authorize: () ->
      #Deny uploads if user is not logged in.
      if not Meteor.user()?
        message = "Please login before posting files"
        throw new Meteor.Error("Login Required", message)

      return true

    key:(file) ->
      #Store file into a directory by the user's username.
      console.log "getting the key: ", file
      if file.type.indexOf "image"
        prefix = CONTENT_FOLDER + IMAGE_FOLDER
      else
        prefix = "TEST/"
      return prefix + file.name

  }
  #if Meteor.settings.AWS
    #AWS.config.update
      #accessKeyId: process.env.aws_access_key_id
      #secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
      #region: 'us-west-1'
  #else
    #console.warn "AWS settings missing"

  
  #s3 = new AWS.S3()
  #list = s3.listObjectsSync
    #Bucket: BUCKET
    #Prefix: 'NooraHealth/'
  #console.log "list "
  #console.log list
  #console.log "bucket"
  #bucket = s3.listBucketsSync
  #console.log bucket
  #for file in list.Contents
    #console.log "file:", file
  #for bucket in s3.listBucketsSync
    #console.log "s3 bucket: ", bucket
  #S3.config= {
    #key: process.env.AWS_ACCESS_KEY,
    #secret: process.env.AWS_SECRET_ACCESS_KEY,
    #bucket: 'elasticbeanstalk-us-west-1-584511731882',
    #region: "us-west-1"

  #UploadServer.init {
    #tmpDir:process.env.PWD +  '/.uploads/tmp'
    #uploadDir: process.env.PWD + '/.uploads'
    #checkCreateDirectories: true


