#SpringTransition = famous.transitions.SpringTransition
#EasingTransition = famous.transitions.Easing
#Transitionable = famous.transitions.Transitionable
#Transitionable.registerMethod('spring', SpringTransition)

Transform = null

FView.ready ()->

  this.Transform = famous.core.Transform
  this.Surface = famous.core.Surface
  this.EventHandler = famous.core.EventHandler
  famous.polyfills
  famous.core.famous
