Template.layout.onRendered ()->
  console.log "Settig the options"
  lightbox = FView.byId "lightbox"
  lightbox.view.setOptions {
      #inTransform: Transform.translate 600, 0, 0
      #showOrigin: [.5,.5]
      #inTransform: Transform.scale(1.1, 1.1, 1)
      inTransition: {duration: 1500, curve: 'easeIn'}
      outTransition: {duration: 1500, curve: 'easeOut'}
      inAlign: [2,.5]
      outAlign: [-2, .5]
      showAlign: [.5,.5]
      overlap: true
    }

