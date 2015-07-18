Template.imgWithToasts.helpers
  imgSrc: ()->
    return ModuleSurface.imgSrc Template.parentData()
  successToastIsVisible: ()->
    return Session.get "success toast is visible"
  failToastIsVisible: ()->
    return Session.get "fail toast is visible"
