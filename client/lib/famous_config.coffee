#SpringTransition = famous.transitions.SpringTransition
#EasingTransition = famous.transitions.Easing
#Transitionable = famous.transitions.Transitionable
#Transitionable.registerMethod('spring', SpringTransition)

Transform = null

FView.ready ()->
  this.Transform = famous.core.Transform
  this.Surface = famous.core.Surface
  this.Lightbox = famous.views.Lightbox
  this.Scrollview = famous.views.Scrollview
  this.Scroller = famous.views.Scroller
  this.EventHandler = famous.core.EventHandler
  this.Modifier = famous.core.Modifier
  this.SpringTransition = famous.transitions.SpringTransition
  this.Timer = famous.utilities.Timer
  this.RenderNode = famous.core.RenderNode
  this.StateModifier = famous.modifiers.StateModifier

  #events
  this.MSync = famous.inputs.MouseSync
  this.SSync= famous.inputs.ScrollSync
  this.TSync= famous.inputs.TouchSync
  this.GenericSync = famous.inputs.GenericSync

  this.GenericSync.register([
      #'mouse' : MSync
      'touch' : TSync
      'scroll': SSync
  ])

  famous.polyfills
  famous.core.famous
