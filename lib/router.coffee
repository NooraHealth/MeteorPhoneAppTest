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
    onBeforeAction: ()->

      if Meteor.loggingIn()
        return
      else if !Meteor.user()
        this.next()
      else if not Meteor.user().curriculumIsSet()
        Router.go "selectCurriculum"
      else if Meteor.isCordova and not Meteor.user().contentLoaded() and not Session.get "content loaded"
        Meteor.call 'contentEndpoint', (err, endpoint)->
          downloader = new ContentInterface(Meteor.user().getCurriculum(), endpoint)
          onSuccess = (entry)->
            Meteor.user().setContentAsLoaded true
            Session.set "content loaded", true
            Session.set( "content src", 'http://127.0.0.1:8080/')
            Router.go "home"

          onError = (err)->
            alert "There was an error downloading your content, please log in and try again: ", err
            Meteor.user().setContentAsLoaded false
            Meteor.logout()
          downloader.loadContent(onSuccess, onError)
          Router.go "loading"

      else if !Meteor.isCordova
        Meteor.call "contentEndpoint", (err, src)->
          console.log "Setting the src to ", src
          Session.set "content src", src

      Session.set "current transition", "slideWindowLeft"
      this.next()


    data: ()->
      console.log "The data"
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
    #waitOn: ()->
      #Meteor.subscribe "lessons"
      #Meteor.subscribe "modules"
    onBeforeAction: ()->
      if Meteor.loggingIn()
        return
      Session.set "current transition", "slideWindowLeft"
      this.next()
    data: () ->
      console.log @.params.nh_id
      console.log "ABOVE"
      console.log Lessons.findOne {nh_id: this.params.nh_id}
      console.log Lessons.find({}).count()
      if this.ready()
        console.log "READY"
        lesson = Lessons.findOne {nh_id: this.params.nh_id}
        console.log lesson
        Session.set "current lesson", lesson
        modules = lesson.getModulesSequence()
        Session.set "modules sequence", modules
        Session.set "current module index",0
        Session.set "correctly answered", []
        Session.set "incorrectly answered", []
        #Session.set "next button is hidden", nextBtnShouldHide()
        return {modules:  modules  }
        
  }


  ###
  # refresh the content
  ###
  this.route '/refreshcontent', {
    path: '/refreshcontent'
    data: ()->
      Meteor.call "refreshContent", ()->
        console.log "Yey called refresh"
    }

  this.route '/loading', {
    path: '/loading'
    name: 'loading'
    
  }


Router.configure {
  progressSpinner:false
}

