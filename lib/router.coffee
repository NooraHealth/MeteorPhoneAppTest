#FlowRouter.triggers.enter [ AccountsTemplates.ensureSignedIn ]

###
# Home
# Displays all lessons in curriculum
###
FlowRouter.route '/',
  action: ()->
    console.log ""
    console.log "FLOWROUTER ROUTING TO HOME!!!"
    console.log ""

    console.log "Routing to home"
    BlazeLayout.render "layout"
    scene = Scene.init()
    scene.openCurriculumMenu()
    
FlowRouter.route "/loading",
  action: ()->
    console.log "In the loading loading screen"
    BlazeLayout.render "loading"
    console.log "Loading!"


#AccountsTemplates.configureRoute('changePwd')
#AccountsTemplates.configureRoute('forgotPwd')
#AccountsTemplates.configureRoute('resetPwd')
#AccountsTemplates.configureRoute('signIn')
#AccountsTemplates.configureRoute('signUp')
#AccountsTemplates.configureRoute('verifyEmail')

