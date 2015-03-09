Router.map ()->
  
  ###
  # Home
  # Displays all chapters in curriculum
  ###
  this.route '/', {
    path: '/'
    name: 'home'
    template: 'home'
    layoutTemplate: 'layout'
    data: ()->
      console.log Curriculum.findOne({})
      return Curriculum.findOne({})
  }

  ###
  # Logout
  ###
  this.route '/logout', {
    path: '/logout'
    name: 'logout'
    where: 'server'

  }
