
###
# Home
# Displays all lessons in curriculum
###
FlowRouter.route '/', {
  name: "home"
  action: ( params, qparams )->
    BlazeLayout.render "layout", { main : "lessonsView" }
}

###
# module sequence
###

FlowRouter.route '/lesson/:_id', {
  name: "lesson"
  action: ( params, qparams )->
    BlazeLayout.render "moduleLayout", { main: "moduleSlider", footer: "moduleFooter" }

}

FlowRouter.route '/loading',
  name: "loading"
  action: ()->
    BlazeLayout.render "layout", { main: "loading" }

