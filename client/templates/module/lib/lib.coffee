###
# Handler for all failed attempts on a module
#
# - Inserts a failed attempt into the Attempts collection
# - Appends this module to the module sequence for the user to 
# try again.
#
# module            Module document object 
# responses         user's incorrect response
# time_to_complete  the time to complete the module in ms
###
this.handleFailedAttempt = (module, responses, time_to_complete) ->
  Attempts.insert {
    user: Meteor.user()._id
    responses: responses
    passed: false
    date: new Date().getTime()
    time_to_complete_in_ms: 0
    nh_id: module.nh_id
  }, (error, _id) ->
    if error
      console.log "There was an error inserting the incorrect attempt into the database"
    else
      console.log "Just inserted this incorrect attempt into the DB: ", Attempts.findOne {_id: _id}




###
# Handler for all successful attempts on a module
#
# -Inserts a successful attempt into the Attempts collection
#
# module            Module document object 
# responses         user's incorrect response
# time_to_complete  time to complete the module in ms
###
this.handleSuccessfulAttempt = (module, time_to_complete)->
  Attempts.insert {
    user: Meteor.user()._id
    passed: true
    date: new Date().getTime()
    time_to_complete_in_ms: 0
    nh_id: module.nh_id
  }, (error, _id) ->
    if error
      console.log "There was an error inserting the CORRECT attempt into the database"
    else
      console.log "Just inserted this CORRECT attempt into the DB: ", Attempts.findOne {_id: _id}
