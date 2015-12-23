Meteor.methods {

  refreshContent: ()->
    console.log "Refresghing the content on the server"
    Curriculum.remove({})
    Lessons.remove({})
    Modules.remove({})

    Curriculum.insert curriculum for curriculum in CURRICULUM
    Lessons.insert lesson for lesson in LESSONS
    Modules.insert module for module in MODULES

  isProduction: ()->
    return process.env.METEOR_ENV == 'production'

  getBucket: ()->
    if process.env.METEOR_ENV== 'production'
      return BUCKET
    else
      return DEV_BUCKET

  
}
