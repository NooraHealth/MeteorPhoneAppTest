###
# Handler for all failed attempts on a module
#
# - Inserts a failed attempt into the Attempts collection
# - Appends this module to the module sequence for the user to 
# try again.
###
this.handleFailedAttempt = (module) ->



###
# Handler for all successful attempts on a module
#
# -Inserts a successful attempt into the Attempts collection
###
this.handleSuccessfulAttempt = (module)->

