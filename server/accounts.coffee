Accounts.onCreateUser (options, user)->
  user.profile = options.profile or {}
  user.profile['lessons_complete'] = []
  user.profile.content_loaded = false
  return user

