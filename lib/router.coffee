#FlowRouter.triggers.enter [ AccountsTemplates.ensureSignedIn ]

###
# Home
# Displays all lessons in curriculum
###
FlowRouter.route '/',
  action: ()->
    BlazeLayout.render "layout"
    scene = Scene.init()
    if not scene.curriculumIsSet()
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

