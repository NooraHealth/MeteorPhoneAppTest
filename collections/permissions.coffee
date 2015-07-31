Meteor.users.allow {
  update: (id, docs, field, modifier) ->
    return true
}
