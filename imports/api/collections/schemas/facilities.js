

let Facilities = new Mongo.Collection("salesforce_facilities");

let FacilitiesSchema = new SimpleSchema({
  name: {
    type: String,
    max: 100
  }
});

Facilities.attachSchema( FacilitiesSchema );

Ground.Collection( Facilities );

module.exports.Facilities = Facilities;
