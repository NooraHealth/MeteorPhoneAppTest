###
# Home
# Displays all lessons in curriculum
###
FlowRouter.route '/',
  action: ()->

    if Meteor.isCordova# and not Meteor.user().contentLoaded()
      console.log "Going to download the content!"
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

    scene.openCurriculumMenu()

FlowRouter.route "/loading",
  action: ()->
    console.log "Loading!"


