FlowRouter.triggers.enter [ AccountsTemplates.ensureSignedIn ]

###
# Home
# Displays all lessons in curriculum
###
FlowRouter.route '/',
  action: ()->

    #if Meteor.isCordova # and not Meteor.user().contentLoaded()
      #FlowRouter.go "/loading"
      #console.log "Going to download the content!"
      #Meteor.call 'contentEndpoint', (err, endpoint)=>
        #console.log "----------- Downloading the content----------------------------"
        #console.log "About to make downloader"
        #downloader = new ContentInterface(Meteor.user().getCurriculum(), endpoint)
        #onSuccess = (entry)=>
          #console.log "Success downloading content: ", entry
          #Meteor.user().setContentAsLoaded true
          #FlowRouter.go "/"

        #onError = (err)->
          #console.log "Error downloading content: ", err
          #console.log err
          #alert "There was an error downloading your content, please log in and try again: ", err
          #Meteor.user().setContentAsLoaded false

        #downloader.loadContent onSuccess, onError

    BlazeLayout.render "layout"
    console.log "Routing to home"
    scene = Scene.init()
    scene.openCurriculumMenu()
    
FlowRouter.route "/loading",
  action: ()->
    BlazeLayout.render "loading"
    console.log "Loading!"


AccountsTemplates.configureRoute('changePwd')
AccountsTemplates.configureRoute('forgotPwd')
AccountsTemplates.configureRoute('resetPwd')
AccountsTemplates.configureRoute('signIn')
AccountsTemplates.configureRoute('signUp')
AccountsTemplates.configureRoute('verifyEmail')

