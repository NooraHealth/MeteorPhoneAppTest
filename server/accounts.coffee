Accounts.onCreateUser (options, user) ->
  console.log "in the on create user hook!"
  console.log options
  console.log user
  user.profile = options.profile
  console.log "This is the new user profile: ", user.profile
  user.profile['chapters_complete'] = []
  console.log "and after adding chapters complete:", user.profile
  return user
