
ModuleSchema = new SimpleSchema
  nh_id:
    type:String
    min:0
    optional:true
  tags:
    type:[String]
    minCount:0
    optional:true
  type:
    type:String
  title:
    type:String
    optional:true
  image:
    type:String
    optional: true
  #QUESTION MODULE
  question:
    type:String
    optional:true
  explanation:
    type:String
    optional:true
  options:
    type:[String]
    optional:true
  correct_answer:
    type:[String]
    optional:true
  incorrect_audio:
    type:String
    optional:true
  correct_audio:
    type:String
    optional:true
  next_module:
    type: String
    optional:true
  
  #VIDEO MODULE
  video:
    type:String
    optional:true
    #regEx: /^([/]?\w+)+[.]mp4$/

  #SLIDE OR AUDIO MODULE
  audio:
    type:String
    optional:true
    #regEx: /^([/]?\w+)+[.]mp3$/

Modules.attachSchema ModuleSchema

