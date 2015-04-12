#SpringTransition = famous.transitions.SpringTransition
#EasingTransition = famous.transitions.Easing
#Transitionable = famous.transitions.Transitionable
#Transitionable.registerMethod('spring', SpringTransition)

Transform = null

FView.ready ()->

  this.Transform = famous.core.Transform

  famous.polyfills
  famous.core.famous
