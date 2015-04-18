Router.map ()->
  
  ###
  # Home
  # Displays all chapters in curriculum
  ###
  this.route '/', {
    path: '/'
    name: 'home'
    template: 'home'
    yieldTemplates: {
      'footer': {to:"footer"}
    }
    layoutTemplate: 'layout'
    data: ()->
      if this.ready()
        curr = Curriculum.findOne({})
        if curr
          Session.set "current chapter", null
          Session.set "current lesson", null
          Session.set "current module index", null
          Session.set "module sequence", null
          Session.set "sections map", {}
          Session.set "current sections", null
          chapters =  curr.getLessonDocuments()
          Session.set "chapters sequence", chapters
          return {chapters: chapters}
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
    template: "ModulesSequence"
    yieldTemplates: {
      'moduleFooter': {to:"footer"}
    }
    #onBeforeAction: ()->
      #Session.set "current transition", "slideWindowLeft"

    data: () ->
      console.log "going to the modules section"
      if this.ready()
        section = Lessons.findOne {nh_id: this.params.nh_id}
        Session.set "current section", section
        return {section: section}
        
  }

  ###
  # Chapter Page
  ###
  this.route '/chapter/:nh_id', {
    path: '/chapter/:nh_id'
    name: 'chapter'
    layoutTemplate: 'layout'
    data: ()->
      if @.ready()
        return {lessons: Session.get "current lessons"}

    onBeforeAction: ()->
      console.log "getting the chapter"
      chapterID = this.params.nh_id
      chapter = Lessons.findOne {nh_id: chapterID}
      if chapter
        Session.set "current chapter", chapter
        lessons = chapter.getSublessonDocuments()
        Session.set "current lessons", lessons

      @.next()

    onAfterAction: ()->
      Tracker.nonreactive ()->
        lessons = Session.get "current lessons"
        if not lessons?
          return
        
        sectionsMap = Session.get "sections map"
        if not sectionsMap?
          sectionsMap = {}
          Session.set "sections map", sectionsMap
        for lesson in lessons
          nh_id = lesson.nh_id
          if not sectionsMap.nh_id?
            lessonDoc = Lessons.findOne {nh_id: lesson.nh_id}
            if not lessonDoc?
              sectionDocuments.push lesson
            else
              sectionDocuments = lessonDoc.getSublessonDocuments()
              #If there are no sublessons, then 
              if sectionDocuments.length == 0
                sectionDocuments.push lesson
            sectionsMap[nh_id] = sectionDocuments
          
        Session.set "sections map", sectionsMap
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



