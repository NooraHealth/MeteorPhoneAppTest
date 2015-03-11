Router.map ()->
  
  ###
  # Home
  # Displays all chapters in curriculum
  ###
  this.route '/', {
    path: '/'
    name: 'home'
    template: 'home'
    layoutTemplate: 'layout'
    data: ()->
      if this.ready()
        curr = Curriculum.findOne({})
        if curr
          return {chapters: curr.getLessonDocuments()}
  }

  ###
  # Logout
  ###
  this.route '/logout', {
    path: '/logout'
    name: 'logout'
    where: 'server'
  }

  ###
  # Module Sequence
  ###
  this.route '/modules/:nh_id', {
    path: '/modules/:nh_id'
    layoutTemplate: 'layout'
    name: 'ModulesSequence'
    data: () ->
      if this.ready()
        lesson = Lessons.findOne {nh_id: this.params.nh_id}
        return {lesson: lesson}
        
  }

  ###
  # Chapter Page
  ###
  this.route '/chapter/:nh_id', {
    path: '/chapter/:nh_id'
    name: 'chapter'
    layoutTemplate: 'layout'
    data: ()->
      if this.ready()
        chapterID = this.params.nh_id
        chapter = Lessons.findOne {nh_id: chapterID}
        if chapter
          return {lessons: chapter.getSublessonDocuments()}
  }
  
