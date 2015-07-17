Router.map ()->
  
  ###
  # Home
  # Displays all lessons in curriculum
  ###
  this.route '/', {
    path: '/'
    name: 'home'
    template: 'home'
    yieldTemplates: {
      'footer': {to:"footer"}
    }
    layoutTemplate: 'layout'
    cache: true
    waitOn: ()->
      if !Meteor.user()
        return []
      if Meteor.status().connected
        return [
          Meteor.subscribe("curriculum", Meteor.user().getCurriculumId()),
          Meteor.subscribe("lessons", Meteor.user().getCurriculumId()),
        ]

    onBeforeAction: ()->
      console.log "In the onBeforeAction in the home route"
      if Meteor.loggingIn()
        this.next()
      else if !Meteor.user()
        this.next()

      if Meteor.isCordova
        console.log "Meteor is cordova and I'm about to initialize the server"
        initializeServer()
        
      if not Meteor.user().curriculumIsSet()
        Router.go "selectCurriculum"

      if Meteor.isCordova and not Meteor.user().contentLoaded()# and not Session.get "content loaded"
        Router.go "loading"
        Meteor.call 'contentEndpoint', (err, endpoint)=>
          console.log "----------- Downloading the content----------------------------"
          console.log "About to make downloader"
          downloader = new ContentInterface(Meteor.user().getCurriculum(), endpoint)
          onSuccess = (entry)=>
            console.log "Success downloading content: ", entry
            Meteor.user().setContentAsLoaded true
            Router.go "home"

          onError = (err)->
            console.log "Error downloading content: ", err
            console.log err
            alert "There was an error downloading your content, please log in and try again: ", err
            Meteor.user().setContentAsLoaded false
            Meteor.logout()
          downloader.loadContent onSuccess, onError

      if this.next
        console.log "Calling this.next()"
        this.next()

    data: ()->
      if this.ready() and Meteor.user()
        curr = Curriculum.findOne({_id: Meteor.user().profile.curriculumId})
        if curr
          Session.set "current lesson", null
          Session.set "current module index", null
          Session.set "module sequence", null
          Session.set "sections map", {}
          Session.set "current sections", null
          lessons =  curr.getLessonDocuments()
          Session.set "lessons sequence", lessons
          return {lessons: lessons}

    onAfterAction: ()->
      Session.set "current transition", "slideWindowLeft"
  }

  this.route '/selectCurriculum', {
    path: '/selectCurriculum'
    layoutTemplate: 'layout'
    name: 'selectCurriculum'
    yieldTemplates: {
      'selectCurriculumFooter': {to:"footer"}
    }
    cache: true
    waitOn:()->
      if Meteor.status().connected
        return Meteor.subscribe("all_curriculums")
  }

  ###
  # module sequence
  ###
  this.route '/modules/:_id', {
    path: '/modules/:_id'
    layoutTemplate: 'layout'
    name: 'ModulesSequence'
    template: "module"
    yieldTemplates: {
      'moduleFooter': {to:"footer"}
    }
    cache: true
    waitOn: ()->
      if !Meteor.user()
        return
      if Meteor.status().connected
        return [
          Meteor.subscribe("lessons", Meteor.user().getCurriculumId()),
          Meteor.subscribe("curriculum", Meteor.user().getCurriculumId()),
          Meteor.subscribe("modules", this.params._id)
        ]

    data: () ->
      lesson = Lessons.findOne {_id: this.params._id}
      Session.set "current lesson", lesson
      modules = lesson.getModulesSequence()
      Session.set "modules sequence", modules
      Session.set "current module index",0
      Session.set "correctly answered", []
      Session.set "incorrectly answered", []
      return {modules:  modules  }
        
  }


  ###
  # refresh the content
  ###
  this.route '/refreshcontent', {
    path: '/refreshcontent'
    data: ()->
      Meteor.call "refreshContent"
    }

  this.route '/loading', {
    path: '/loading'
    name: 'loading'
  }


Router.configure {
  progressSpinner:false,
  #loadingTemplate: 'loading'
}

