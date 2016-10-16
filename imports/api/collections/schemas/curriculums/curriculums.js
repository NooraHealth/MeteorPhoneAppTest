
import { Lessons } from './lessons.js';
import { Modules } from './modules.js';

let Curriculums = new Mongo.Collection("nh_home_pages");
let LocalCurriculums = new Mongo.Collection("local_nh_home_pages", { connection: null });

let CurriculumSchema = new SimpleSchema({
  title: {
    type:String,
    min: 1,
    max: 40
  },
  condition: {
    type: String,
    regEx: /^(Cardiac Surgery|Diabetes|Neonatology)$/
  },
  language: {
    type: String,
    regEx: /^(Hindi|English|Kannada|Tamil)$/
  },
  introduction: {
    type: String,
    optional: true
  },
  beginner: {
    type:[String],
    defaultValue: []
  },
  intermediate: {
    type:[String],
    defaultValue: []
  },
  advanced: {
    type:[String],
    defaultValue: []
  }
});

Curriculums.attachSchema( CurriculumSchema );
// LocalCurriculums.attachSchema( CurriculumSchema );

const helpers = ({

  getIntroductionModule: function() {
    console.log("Getting into module");
    const lesson = Lessons.findOne({_id: this.introduction});
    console.log("LESSON");
    console.log(lesson);
    if(!lesson)
      return null;
    const moduleId = lesson.modules[0];
    const doc = Modules.findOne({_id: moduleId});
    if( doc.type != "VIDEO" ) {
      return null;
    } else {
      return doc;
    }
  },

  getLessonDocuments: function(level) {
    new SimpleSchema({
      level: { type: String }
    }).validate( {level: level} );

    let filterEmptyValues = function(elem) {
      return elem !== null && elem !== undefined && elem !== "";
    };
    //const ids = [this.introduction].concat(this.beginner).concat(this.intermediate).concat(this.advanced);
    var ids = this[level];
    if(!ids)
      return [];
    if(level == "introduction")
      ids = [ids];
    let docs = ids.map( id =>{
      return Lessons.findOne({_id: id, is_active: {$not: false}});
    });
    return docs.filter(filterEmptyValues);
  }
});

Curriculums.helpers(helpers);
LocalCurriculums.helpers(helpers);

Ground.Collection( Curriculums );
Ground.Collection( LocalCurriculums );

module.exports.Curriculums = LocalCurriculums;
module.exports.ExternalCurriculums = Curriculums;
