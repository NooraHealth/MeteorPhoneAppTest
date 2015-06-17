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
    onBeforeAction: ()->
      console.log "THis is this in home route: "
      console.log this
      console.log "This is the Meteor.user()"
      console.log Meteor.user()
      if !Meteor.user()
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

      this.next()

    data: ()->
      console.log "The data"
      if this.ready() and Meteor.user()
        curr = Curriculum.findOne({_id: Meteor.user().profile.curriculumId})
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

  this.route '/selectCurriculum', {
    path: '/selectCurriculum'
    layoutTemplate: 'layout'
    name: 'selectCurriculum'
    yieldTemplates: {
      'selectCurriculumFooter': {to:"footer"}
    }
    onBeforeAction: ()->
      Session.set "current transition", "opacity"
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
    onBeforeAction: ()->
      Session.set "current transition", "slideWindowRight"
      this.next()
    data: () ->
      if this.ready()
        lesson = Lessons.findOne {nh_id: this.params.nh_id}
        Session.set "current lesson", lesson
        modules = lesson.getModulesSequence()
        Session.set "modules sequence", modules
        Session.set "current module index",0
        Session.set "correctly answered", []
        Session.set "incorrectly answered", []
        Session.set "next button is hidden", false
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

