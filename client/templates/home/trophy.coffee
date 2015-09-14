Template.trophy.onRendered ()->
  console.log "THE TROPHY WAS RENDERED"
  trophy = FView.from this
  console.log trophy
  trophy.modifier.setOrigin [.5, 60]
  #trophy.modifier.setOrigin [.5, .5] , {method: "spring", period: 200, dampingRatio: .5, velocity: .1}
