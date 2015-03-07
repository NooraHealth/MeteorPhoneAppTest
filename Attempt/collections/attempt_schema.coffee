###
# Attempt
# 
# A user's single attempt, failed or successful, 
# on a single module of any type. 
###


AttemptSchema = new SimpleSchema
  nickname:
    type:String
  responses:
    type:[String]
    minCount:1
  passed:
    type:String
    min:0
  date:
    type:String
  time_to_complete:
    type: String
  nh_id:
    type:String
    min:0

Attempts.attachSchema AttemptSchema
