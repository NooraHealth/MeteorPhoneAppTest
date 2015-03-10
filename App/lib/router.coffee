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

  this.route '/chapter/:nh_id', {
    path: '/chapter/:nh_id'
    name: 'chapter'
    layoutTemplate: 'layout'
    data: ()->
      if this.ready()
        chapterID = this.params.nh_id
        chapter = Lessons.findOne {nh_id: this.params.id}
        if chapter
          return {lessons: chapter.getSublessonDocuments()}
  }
