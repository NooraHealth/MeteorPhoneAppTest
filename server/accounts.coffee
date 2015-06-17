Accounts.onCreateUser (options, user)->
  console.log options
  console.log user
  user.profile = options.profile or {}
  user.profile['lessons_complete'] = []
  user.profile.content_loaded = false
  return user

