Meteor.methods {

  refreshContent: ()->
    console.log "Refresghing the content on the server"
    Curriculum.remove({})
    Lessons.remove({})
    Modules.remove({})

    Curriculum.insert curriculum for curriculum in CURRICULUM
    Lessons.insert lesson for lesson in LESSONS
    Modules.insert module for module in MODULES

  contentEndpoint: ()->
    if process.env.METEOR_ENV == 'production'
      return "http://d1loll817ogoo0.cloudfront.net/"
      #return "http://noorahealthcontent.s3-us-west-1.amazonaws.com/"
    else
      return 'http://noorahealth-development.s3-us-west-1.amazonaws.com/'

  isProduction: ()->
    return process.env.METEOR_ENV == 'production'

  getBucket: ()->
    if process.env.METEOR_ENV== 'production'
      return BUCKET
    else
      return DEV_BUCKET

  
}
