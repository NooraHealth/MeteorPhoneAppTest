Template.imgWithToasts.helpers
  imgSrc: ()->
    return Template.parentData().imgSrc()
  successToastIsVisible: ()->
    return Session.get "success toast is visible"
  failToastIsVisible: ()->
    return Session.get "fail toast is visible"
