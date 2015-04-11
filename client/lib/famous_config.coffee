#SpringTransition = famous.transitions.SpringTransition
#EasingTransition = famous.transitions.Easing
#Transitionable = famous.transitions.Transitionable
#Transitionable.registerMethod('spring', SpringTransition)

Transform = null

FView.ready ()->

  Transform = famous.core.Transform

  console.log "FAOUNS: ", famous
  famous.polyfills
  famous.core.famous
