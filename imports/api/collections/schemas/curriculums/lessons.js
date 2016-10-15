
import { Modules } from './modules.js';
import { define } from './define.js';

let Lessons = new Mongo.Collection("nh_lessons");
let LocalLessons = new Mongo.Collection("local_nh_lessons", { connection: null });

let LessonSchema = new SimpleSchema({
  title: {
    type:String,
    max: 50
  },
  image: {
    type: String,
    regEx: define.imageFileRegEx
  },
  modules: {
    type: [String]
  },
  is_active: {
    type: Boolean,
    defaultValue: true
  }
});

Lessons.attachSchema( LessonSchema );
LocalLessons.attachSchema( LessonSchema );

const helpers = ({
  getModulesSequence: function() {
    if( this.modules )
      sequence = this.modules.map( ( id ) => {
        return Modules.findOne( {_id: id, is_active: {$not: false}} );
      });
      return sequence.filter( (doc)=> {
        return doc !== undefined;
      });
  }
});

Lessons.helpers = helpers;
LocalLessons.helpers = helpers;

Ground.Collection( Lessons );
Ground.Collection( LocalLessons );

module.exports.Lessons = LocalLessons;
module.exports.ExternalLessons = Lessons;
