
let Conditions = new Mongo.Collection("conditions");

let ConditionsSchema = new SimpleSchema({
  name: {
    type: String,
    max: 50
  }
});

Conditions.attachSchema( ConditionsSchema );

Ground.Collection( Conditions );

module.exports.Conditions = Conditions;

