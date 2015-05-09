Accounts.onCreateUser (options, user) ->
  console.log "in the on create user hook!"
  console.log options
  console.log user
  user.profile = {}
  user.profile['chapters_complete'] = []
  return user
