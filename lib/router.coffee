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
        return
      if Meteor.status().connected
        return [
          Meteor.subscribe("curriculum", Meteor.user().getCurriculumId()),
          Meteor.subscribe("lessons", Meteor.user().getCurriculumId()),
        ]
    onBeforeAction: ()->
      if Meteor.loggingIn()
        return
      else if !Meteor.user()
        this.next()

      if Meteor.isCordova
        console.log "Meteor.client"
        console.log Meteor.Client
        Meteor.Client.restartLocalServer().then (url)->
          Session.set "content src", url
      
      if not Meteor.user().curriculumIsSet()
        Router.go "selectCurriculum"
      else if Meteor.isCordova and not Meteor.user().contentLoaded()# and not Session.get "content loaded"
        Meteor.call 'contentEndpoint', (err, endpoint)->
          downloader = new LocalContent(Meteor.user().getCurriculum(), endpoint)
          onSuccess = (entry)->
            Meteor.user().setContentAsLoaded true
            #Session.set "content loaded", true
            Router.go "home"

          onError = (err)->
            alert "There was an error downloading your content, please log in and try again: ", err
            Meteor.user().setContentAsLoaded false
            Meteor.logout()
          downloader.loadContent(onSuccess, onError)
        Router.go "loading"

      else if !Meteor.isCordova
        Meteor.call "contentEndpoint", (err, src)->
          Session.set "content src", src

      Session.set "current transition", "slideWindowLeft"
      this.next()


    data: ()->
      if this.ready() and Meteor.user()
        curr = Curriculum.findOne({_id: Meteor.user().profile.curriculumId})
        if curr
          Session.set "current lesson", null
          Session.set "current module index", null
          Session.set "modules sequence", null
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
        return Meteor.subscribe("all_curriculums", this.params.nh_id)
    onBeforeAction: ()->
      this.next()
  }

  ###
  # module sequence
  ###
  this.route '/modules/:nh_id', {
    path: '/modules/:nh_id'
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
          Meteor.subscribe("modules", this.params.nh_id)
        ]

    onBeforeAction: ()->
      if Meteor.loggingIn()
        return
      Session.set "current transition", "slideWindowLeft"
      this.next()

    data: () ->
      lesson = Lessons.findOne {nh_id: this.params.nh_id}
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
    onBeforeAction: ()->
      this.next()
    
  }


Router.configure {
  progressSpinner:false,
  #loadingTemplate: 'loading'
}

