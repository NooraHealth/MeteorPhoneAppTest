
/* ----------------- STORED DATA JSON SCHEMA --------------------------*/
Schema.JsonSchema = new SimpleSchema({
    json: {
        type: String //identifies whether this module is a video, a true-false question, or a scenario question
    },
    timestamp:{
        type: Number
    }
})

PreviousJson.attachSchema(Schema.JsonSchema)

/** -------------------------- MODULE SCHEMAS -----------------------*/


Schema.ModuleSchema = new SimpleSchema({
    //REQUIRED ELEMENTS
    tags: {
        type: [String],
        minCount: 0,
        optional:true
    },
    type: {
        type: String //identifies whether this module is a video, a true-false question, or a scenario question
    },
    next_module: {
        type: String,
    },
    nh_id : {
        type: String,
        min: 0
    },

    title: {
        type: String,
        optional:true
    },
    image :{
        type: String,
        optional:true,
        regEx: /^([/]?\w+)+[.]png$/
    },

    //IF THIS IS A QUESTION MODULE
    question: {
        type: String,
        optional:true
    },
    explanation:{
      type: String, //Explanation of the answer
      optional: true
    },
    options : {
        type: [String],
        optional:true
    },
    correct_answer : {
        type: [String],
        optional:true
    },
    incorrect_audio: {
      type: String,
        optional:true //URL to the audio
    },
    correct_audio:{
      type: String,
        optional:true//URL to the audio
    },

    //VIDEO MODULE
    video: {
        type: String,
        optional:true, //identifies whether this module is a video, a true-false question, or a scenario question
        regEx: /^([/]?\w+)+[.]mp4$/
    },

    //SLIDES
    audio : {
        type: String,
        optional:true, //URL to the audio file
        regEx: /^([/]?\w+)+[.]mp3$/
    }
});

Modules.attachSchema(Schema.ModuleSchema);

/* -------------------------- LESSON SCHEMAS -----------------------*/

Schema.LessonSchema = new SimpleSchema({
    short_title: {
        type: String,
        optional:true
    },
    title: {
        type: String
    },
    description: {
        type: String,
        optional:true
    },
    image: {
        type: String,
        regEx: /^([/]?\w+)+[.]png$/
    },
    tags: {
        type: [String],
        minCount: 0,
        optional:true
    },
    has_sublessons:{
        type: String,
        defaultValue: false
    },
    lessons:{
        type:[String],
        // optional: true,
        // custom: function () {
        //     if (this.field('has_sublessons').value == true) 
        //         return "required";
        // }
    },
    first_module:{
        type: String, //Could do it this way or could do an array of modules and then either check the module for the order to present(I think I like this way)
        // optional: true,
        // custom: function () {
        //     if (this.field('has_sublessons').value == false) 
        //         return "required";
        // }
    },
    nh_id : {
        type: String,
        min: 0
    }
});

Lessons.attachSchema(Schema.LessonSchema);

/** -------------------------- HOME SCHEMAS -----------------------*/

Schema.HomeSchema = new SimpleSchema({
    title: {
        type: String
    },
    lessons: {
        type: [String],
        minCount: 1
    },
    condition: {
        type: String,
        min: 0
    },
    nh_id : {
        type: String,
        min: 0
    }
});

Home_Pages.attachSchema(Schema.HomeSchema);

/** ------------------------ ATTEMPT SCHEMA ------------------------**/

Schema.AttemptSchema = new SimpleSchema({
  nickname:{
    type: String
  },
  responses:{
    type: String,
    optional: true
  },
  passed: {
    type: String //indicates whether the attempt completed the module successfully
  },
  nh_id:{
    type: String //this will be the module's nh_id
  },
  date:{
    type: String
  },
  time_to_complete:{
    type: String,
  }
});

Attempts.attachSchema(Schema.AttemptSchema);
