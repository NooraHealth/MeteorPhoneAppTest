Template.trophy.onRendered ()->
  trophy = FView.from this
  trophy.modifier.setOrigin [.5, 60]
  #trophy.modifier.setOrigin [.5, .5] , {method: "spring", period: 200, dampingRatio: .5, velocity: .1}
