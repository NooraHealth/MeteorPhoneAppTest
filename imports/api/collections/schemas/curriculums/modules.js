import { define } from './define.js';

const SCENARIO_OPTIONS = ['CallDoc', 'Call911', 'Normal'];
const BINARY_OPTIONS = ['No', 'Yes'];
let Modules = new Mongo.Collection("nh_modules");
let LocalModules = new Mongo.Collection("local_nh_modules", { connection: null });

let ModuleSchema = new SimpleSchema({
  type: {
    type: String,
    regEx: /^(MULTIPLE_CHOICE|SCENARIO|BINARY|VIDEO|SLIDE)$/
  },

  title: {
    type: String,
    optional: true,
    max: 100,
    custom: function() {
      type = this.field("type").value;
      if( define.isQuestion(type) && this.value !== undefined ) {
        return "The title field for module type " + type + " should not be defined.";
      } else if( !define.isQuestion(type) && this.value === undefined ) {
        return "The title field for module type " + type + " must be defined.";
      }
    }
  },

  image: {
    type: String,
    optional: true,
    custom: function() {
      type = this.field("type").value;
      if( type == "SLIDE" || type == "BINARY" || type == "SCENARIO" ) {
        isValid = this.value !== undefined && this.value.match(new RegExp(define.imageFileRegEx)) !== null;
        if( !isValid )
          return "Image filename is not properly formatted. Please save the filename with only letters and numbers in the name, as a .png, .jpg or .jpeg file";
      }
      else
        return this.value === undefined;
    }
  },

  question: {
    type: String,
    optional: true,
    max: 150,
    custom: function() {
      type = this.field("type").value;
      if( define.isQuestion(type) && this.value === undefined ) {
        return "The question field for module type " + type + " must be defined.";
      } else if( !define.isQuestion(type) && this.value !== undefined )
        return "The question field for module type " + type + " should not be defined.";
    }
  },

  options: {
    type: [String],
    optional: true,

    //Automatically set the options for scenario and binary questions
    autoValue: function() {
      type = this.field("type").value;
      if(type == "SCENARIO") {
        return SCENARIO_OPTIONS;
      }

      if(type == "BINARY") {
        return BINARY_OPTIONS;
      }
    },

    //Custom Validator
    custom: function() {
      type = this.field("type").value;

      if( type == "BINARY" ) {
        if( this.value.length != BINARY_OPTIONS.length )
          return "Invalid options for BINARY module: should be " + BINARY_OPTIONS;
        for( let option of this.value ) {
          if ( BINARY_OPTIONS.indexOf(option) == -1 )
            return "Invalid options for BINARY module: should be " + BINARY_OPTIONS;
        }
      }

      else if( type == "SCENARIO" ) {
        if( this.value.length != SCENARIO_OPTIONS.length )
          return "Invalid options for SCENARIO module: should be " + SCENARIO_OPTIONS;
        for( let option of this.value ) {
          if ( SCENARIO_OPTIONS.indexOf(option) == -1 ) {
            return "Invalid options for SCENARIO module: should be " + SCENARIO_OPTIONS;
          }
        }
      }
      else if(type == "MULTIPLE_CHOICE") {
        // If there are not 6 options
        if( this.value.length > 6 || this.value.length === 0 || this.value.length % 2 !== 0 )
          return "Invalid options for MULTIPLE_CHOICE module: should be 2, 4, or 6 options exactly";

        // If they are not properly formatted filenames
        for( let option of this.value) {
          if(!option.match(define.imageFileRegEx)) {
            return "Invalid options for MULTIPLE_CHOICE module: filenames should be only letters and numbers of filetype .png, .jpg, or .jpeg";
          }
        }
      }
    }
  },
  correct_answer: {
    type: [String],
    optional: true,

    //Custom Validator
    custom: function() {
      type = this.field("type").value;
      options = this.field("options");

      if( define.isQuestion(type) && this.value === undefined )
        return "Module of type " + type + " requires a correct_answer to be defined";

      if(type == "SCENARIO") {
        let isValid = this.value.length == 1 && SCENARIO_OPTIONS.indexOf(this.value[0]) != -1;
        if( !isValid )
            return "Invalid correct_answer for SCENARIO module: must be either " + BINARY_OPTIONS;
      } else if(type == "BINARY") {
        let isValid = this.value.length == 1 && BINARY_OPTIONS.indexOf(this.value[0]) != -1;
        if( !isValid )
          return "Invalid correct_answer for BINARY module: must be either " + BINARY_OPTIONS;
      }
      else if(type == "MULTIPLE_CHOICE") {
        //If an answer is not in the options then return false
        for( let answer of this.value ) {
          if( options.value.indexOf(answer) == -1 )
          return "Invalid correct_answer for MULTIPLE_CHOICE module: answer not found in options";
        }
      }
    }
  },
  correct_audio: {
    type: String,
    optional: true,
    custom: function() {
      var type = this.field("type").value;
      if( define.isQuestion(type) ) {
        isValid = this.value !== undefined && this.value.match(new RegExp(define.audioFileRegEx)) !== null;
        if( !isValid )
          return "Audio filename is not properly formatted. Please save the filename with only letters and numbers in the name, as a .ogg, .wav, .mp3, .m4a, or .aac file";
      }
      else
        return this.value === undefined;
    }
  },
  video: {
    type: String,
    optional: true,
    custom: function() {
      var type = this.field("type").value;
      if( type == "VIDEO") {
        isValid = this.value !== undefined && this.value.match(new RegExp(define.videoFileRegEx)) !== null;
        if( !isValid )
          return "Video filename is not properly formatted. Please save the filename with only letters and numbers in the name, as a .mp4 or .mov file";
      }
      else
        return this.value === undefined;
    }
  },
  audio: {
    type: String,
    optional: true,
    custom: function() {
      var type = this.field("type").value;
      if( define.isQuestion(type) || type == "SLIDE" ) {
        isValid = this.value !== undefined && this.value.match(new RegExp(define.audioFileRegEx)) !== null;
        if( !isValid )
          return "Audio filename is not properly formatted. Please save the filename with only letters and numbers in the name, as a .ogg, .wav, .mp3, .m4a, or .aac file";
      }
      else
        return this.value === undefined;
    }
  },
  is_active: {
    type: Boolean,
    defaultValue: true
  }

});

Modules.attachSchema( ModuleSchema );
LocalModules.attachSchema( ModuleSchema );

const helpers = ({

  isEmbedded: function() {
    if( this.video_url )
      return this.video_url.startsWith( "http" );
    else
      return false;
  },

  isCorrectAnswer: function( response ){
    return this.correct_answer.indexOf( response ) != -1;
  },

  isQuestion: function() {
    return define.isQuestion(this.type);
  },

  hasAudio: function() {
    return this.audio !== undefined && this.audio !== null;
  },

  hasExplanation: function() {
    return this.correct_audio !== undefined && this.correct_audio !== null;
  }

});

Modules.helpers = helpers;
LocalModules.helpers = helpers;

Ground.Collection( Modules );
Ground.Collection( LocalModules );

module.exports.Modules = LocalModules;
module.exports.ExternalModules = Modules;
