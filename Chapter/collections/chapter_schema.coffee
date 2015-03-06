###
# Chapter: A chapter is the outermost collection of lessons, 
# and is displayed on the home page. 
###

Schema.Chapter = new SimpleSchema
  title:
    type:String
  lessons:
    type:[String]
    minCount:1
  condition:
    type:String
    min:0
  nh_id:
    type:String
    min:0

Chapters.attachSchema Schema.Chapter
