Accounts.onCreateUser (options, user)->
  user.profile = options.profile
  user.profile['chapters_complete'] = []
  return user

