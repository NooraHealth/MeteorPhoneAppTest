Meteor.methods {
  updateUser: (query)->
    if !Meteor.user()
      return
  
    Meteor.users.update {_id: this.userId}, query

}

