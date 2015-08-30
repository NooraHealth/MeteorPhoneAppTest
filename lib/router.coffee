###
# Home
# Displays all lessons in curriculum
###
FlowRouter.route '/',
  action: ()->
    console.log "IN THE FLOW ROUTER"
    if Meteor.isCordova
      initializeServer()

    if Meteor.isCordova and not Meteor.user().contentLoaded()
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

