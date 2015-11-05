Router.map ()->
  
  ###
  # Home
  # Displays all lessons in curriculum
  ###
  this.route '/', {
    path: '/'
    name: "home"
    template: 'lessonsView'
    yieldTemplates: {
      'footer': {to:"footer"}
    }
    layoutTemplate: 'layout'
    cache: true

    #waitOn: ()->
      #if !Meteor.user()
        #return []
      #if Meteor.status().connected
        #return [
          #Meteor.subscribe("curriculum", Meteor.user().getCurriculumId()),
          #Meteor.subscribe("lessons", Meteor.user().getCurriculumId()),
        #]

    #onBeforeAction: ()->
      #console.log "In the onBeforeAction in the home route"
      #if Meteor.loggingIn()
        #this.next()
      #else if !Meteor.user()
        #this.next()

      #if Meteor.isCordova
        #console.log "Meteor is cordova and I'm about to initialize the server"
        #initializeServer()
        
      #if not Meteor.user().curriculumIsSet()
        #Router.go "selectCurriculum"

      #if Meteor.isCordova and not Meteor.user().contentLoaded()# and not Session.get "content loaded"
        #Router.go "loading"
        #Meteor.call 'contentEndpoint', (err, endpoint)=>
          #console.log "----------- Downloading the content----------------------------"
          #console.log "About to make downloader"
          #downloader = new ContentInterface(Meteor.user().getCurriculum(), endpoint)
          #onSuccess = (entry)=>
            #console.log "Success downloading content: ", entry
            #Meteor.user().setContentAsLoaded true
            #Router.go "home"

          #onError = (err)->
            #console.log "Error downloading content: ", err
            #console.log err
            #alert "There was an error downloading your content, please log in and try again: ", err
            #Meteor.user().setContentAsLoaded false
            #Meteor.logout()
          #downloader.loadContent onSuccess, onError

      #if this.next
        #this.next()

    data: ()->
      scene = Scene.get()
      console.log "scene"
      if not scene.curriculumIsSet()
        scene.openCurriculumMenu()

  }

  ###
  # module sequence
  ###
  this.route '/module/:_id', {
    name: "module.show"
    path: '/module/:_id'
    layoutTemplate: 'layout'
    yieldTemplates:
      'moduleFooter1' : { to: 'footer' }
    template: "ModulesSequence"
    cache: true
    data: ()->
      Session.set "current lesson id", @.params._id
      module = Modules.findOne { _id: @.params._id }
      #modules = Scene.get().getModulesSequence()
      return { module : module }
  }

  this.route '/loading', {
    path: '/loading'
    name: 'loading'
  }


Router.configure {
  progressSpinner:false,
  #loadingTemplate: 'loading'
}

