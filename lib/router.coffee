Router.map ()->
  
  ###
  # Home
  # Displays all lessons in curriculum
  ###
  this.route '/', {
    path: '/'
    name: 'home'
    cache: true
    onBeforeAction: ()->
      console.log "In the onBeforeAction in the home route"
      if Meteor.loggingIn()
        this.next()
      else if !Meteor.user()
        console.log "There was not a user!"
        this.next()

      else if Meteor.isCordova
        console.log "Meteor is cordova and I'm about to initialize the server"
        initializeServer()
        
      else if not Meteor.user().curriculumIsSet()
        Router.go "selectCurriculum"

      else if Meteor.isCordova and not Meteor.user().contentLoaded()
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
          scene = Scene.get()
          scene.setLessons lessons
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

