#SpringTransition = famous.transitions.SpringTransition
#EasingTransition = famous.transitions.Easing
#Transitionable = famous.transitions.Transitionable
#Transitionable.registerMethod('spring', SpringTransition)

Transform = null

FView.ready ()->
  this.Transform = famous.core.Transform
  this.Surface = famous.core.Surface
  this.Scroller = famous.views.Scroller
  console.log famous
  console.log famous.core
  this.EventHandler = famous.core.EventHandler
  this.SpringTransition = famous.transitions.SpringTransition
  famous.polyfills
  famous.core.famous
