
import { Curriculums } from '../schemas/curriculums/curriculums.js';
import { Lessons } from '../schemas/curriculums/lessons.js';
import { Modules } from '../schemas/curriculums/modules.js';
import { Conditions } from '../schemas/conditions.js';
import { Facilities } from '../schemas/facilities.js';


Meteor.publish("lessons.all", function() {
  return Lessons.find({});
});

Meteor.publish("modules.all", function() {
  return Modules.find({});
});

Meteor.publish("curriculums.all", function() {
  return Curriculums.find({});
});

Meteor.publish("facilities.all", function() {
  return Facilities.find({});
});

Meteor.publish("conditions.all", function() {
  return Conditions.find({});
});

Meteor.publish("curriculum", function(id) {
  if( !id ) return [];
  return Curriculums.find({_id: id});
});

Meteor.publish( "lesson", function(id) {
  if( !id ) return [];
  return Lessons.find({_id: id});
});

Meteor.publish("lessons.inCurriculum", function(curriculumId) {
  if( !curriculumId ) return [];

  this.related( function(curr) {
    return Lessons.find( {_id: {$in: curr.lessons}} );
  }, Curriculums.findOne( { _id: curriculumId }, { fields: { lessons: 1 } }));

});

Meteor.publish("modules.inLesson", function(lessonId) {
  if( !lessonId ) return [];

  this.related( function( lesson ) {
    return Modules.find( {_id: {$in: lesson.modules}} );
  }, Lessons.findOne( { _id: lessonId }, { fields: { modules: 1 } }));
});

