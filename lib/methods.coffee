Meteor.methods {

  mediaUrl: ()->
    console.log "Getting media url"
    if Meteor.isCordova
      console.log "This is a cordova"
      console.log "I am about to return the location of the local content"

    else if process.env.METEOR_ENV == 'production'
      return "https://noorahealthcontent.s3-us-west-1.amazonaws.com/"
    else
      return 'https://noorahealth-development.s3-us-west-1.amazonaws.com/'

  isProduction: ()->
    return process.env.METEOR_ENV == 'production'

  getBucket: ()->
    if process.env.METEOR_ENV== 'production'
      return BUCKET
    else
      return DEV_BUCKET

  refreshContent: ()->
    Curriculum.remove({})
    Lessons.remove({})
    Modules.remove({})

    Curriculum.insert curriculum for curriculum in CURRICULUM
    Lessons.insert lesson for lesson in LESSONS
    Modules.insert module for module in MODULES
}

