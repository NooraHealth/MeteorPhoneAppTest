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
          Session.set "sections map", {}
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
      if @.ready()
        console.log ""
        return {lessons: Session.get "current lessons"}

    onBeforeAction: ()->
      if this.ready()
        console.log "getting the chapter"
        chapterID = this.params.nh_id
        chapter = Lessons.findOne {nh_id: chapterID}
        if chapter
          Session.set "current chapter", chapter
          lessons = chapter.getSublessonDocuments()
          Session.set "current lessons", lessons
          Session.set "current chapter", chapter

      @.next()

    onAfterAction: ()->
      Tracker.nonreactive ()->
        console.log "I'm in the after action!"
        lessons = Session.get "current lessons"
        if not lessons?
          return
        
        sectionsMap = Session.get "sections map"
        if not sectionsMap?
          sectionsMap = {}
          Session.set "sections map", sectionsMap
        console.log "1"
        console.log "These are all the lessons I'm iterating over: ", lessons
        for lesson in lessons
          nh_id = lesson.nh_id
          console.log "2 : nh_id ", nh_id
          console.log "this is the sections Map: ", sectionsMap
          if not sectionsMap.nh_id?
            console.log "$!!!"
            console.log "this is the lesson, I'm getting the subdocuments: ", lesson
            lessonDoc = Lessons.findOne {nh_id: lesson.nh_id}
            console.log "This is the lessonDoc: ", lessonDoc
            if not lessonDoc?
              sectionDocuments.push lesson
            else
              sectionDocuments = lessonDoc.getSublessonDocuments()
              #If there are no sublessons, then 
              if sectionDocuments.length == 0
                sectionDocuments.push lesson
            console.log "Well 89 wasnt the problem"
            console.log "sectionDocuments: ", sectionDocuments
            sectionsMap[nh_id] = sectionDocuments
          
        Session.set "sections map", sectionsMap
        console.log "this is the sections Map NOW:"
        console.log Session.get "sections map"
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




