Meteor.methods {
  updateUser: (query)->
    if !Meteor.user()
      return
  
    Meteor.users.update {_id: this.userId}, query

  refreshContent: ()->
    Curriculum.remove({})
    Lessons.remove({})
    Modules.remove({})

    Curriculum.insert curriculum for curriculum in CURRICULUM
    Lessons.insert lesson for lesson in LESSONS
    Modules.insert module for module in MODULES
}

