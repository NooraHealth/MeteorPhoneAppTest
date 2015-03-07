###
# PreviousJson
# 
# The most recent JSON file pulled from the endpoint.
# Used to stock the modules, lessons, and chapters in the 
# mongo db
###

JsonSchema = new SimpleSchema
  json:
    type:String
  timestamp:
    type:Number

PreviousJson.attachSchema JsonSchema
