

##
# Percolate:Momentum Transition definitions
##

console.log Transitioner
Transitioner.setTransitions {
  'home->module': 'right-to-left',
  'module->module': 'right-to-left',
  'module->home': 'slide-height',

  'default': 'fade'
}
