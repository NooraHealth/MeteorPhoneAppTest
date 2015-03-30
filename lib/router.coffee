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
          console.log "in the home route"
          Session.set "current chapter", null
          Session.set "current lesson", null
          Session.set "current module index", null
          Session.set "module sequence", null
          Session.set "sections map", []
          Session.set "current sections", null
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
    layoutTemplate: 'moduleLayout'
    name: 'ModulesSequence'
    data: () ->
      if this.ready()
        lesson = Lessons.findOne {nh_id: this.params.nh_id}
        Session.set "current lesson", lesson
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
        console.log "getting the chapter"
        chapterID = this.params.nh_id
        chapter = Lessons.findOne {nh_id: chapterID}
        if chapter
          console.log "getting the sublesson documents for te lessons"
          Session.set "current chapter", chapter
          return {lessons: chapter.getSublessonDocuments()}

    onAfterAction: ()->
      lessons = Template.currentData().lessons
      newSectionEntries = []
      for lesson in lessons
        nh_id = lesson.nh_id
        sectionsMap = Session.get "sections map"
       
        if not sectionsMap[nh_id]
          sectionDocuments = @.getSublessonDocuments()
          newSectionEntries.push({nh_id: sectionDocuments})
        
      Session.set "sections map", sectionsMap
      console.log sectionDocuments
      sectionDocuments = @.getSublessonDocuments()
      sectionsMap.push({nh_id: sectionDocuments})
      Session.set "sections map", sectionsMap
      console.log sectionDocuments
  }

  ###
  # Refresh the content
  ###
  this.route '/refreshcontent', {
    path: '/refreshcontent'
    data: ()->
      Meteor.call "refreshContent", ()->
        console.log "Yey called refresh"
  }




