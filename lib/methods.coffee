Meteor.methods {
  
  cordovaContentSrc: ()->
    if !Meteor.user()
      return
    window.requestFileSystem LocalFileSystem.PERSISTENT, 0, (fs)->
      console.log "Requested the local file system: ", fs

  updateUser: (query)->
    if !Meteor.user()
      return
  
    console.log "Updating the user"
    console.log query
    Meteor.users.update {_id: this.userId}, query

  localStorageLocation: ()->
    console.log "Getting the local storage location else "

  refreshContent: ()->
    Curriculum.remove({})
    Lessons.remove({})
    Modules.remove({})

    Curriculum.insert curriculum for curriculum in CURRICULUM
    Lessons.insert lesson for lesson in LESSONS
    Modules.insert module for module in MODULES
}

