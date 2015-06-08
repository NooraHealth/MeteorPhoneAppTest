Meteor.methods {
  clearMongo: ()->
    Curriculum.remove({})
    Lessons.remove({})
    Modules.remove({})

  mediaUrl: ()->
    console.log "Getting media url"
    if process.env.METEOR_ENV == 'production'
      return "https://noorahealthcontent.s3-us-west-1.amazonaws.com/"
    else
      return 'https://noorahealth-development.s3-west-1.amazonaws.com/'

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

