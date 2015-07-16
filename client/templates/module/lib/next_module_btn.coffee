
class @NextModuleBtn
  @show: ()->
    $("#nextbtn").fadeIn()
    Session.set "next button is hidden", false
