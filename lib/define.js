/** ---------------------- VARIABLES ------------------------ **/

//The percent necessary for it to be considered as having passed a module successfully
PASSING_GRADE = 75;
TRUE = "YES";
FALSE = "NO";

/**---------------------- URLS ----------------------------------**/

MEDIA_URL = "http://grass-roots-science.info/";
//DATA_URL = "http://serene-forest-4377.herokuapp.com/VascularContent/VascularMeta/";
DATA_URL = "http://serene-forest-4377.herokuapp.com/VascularContent/VascularMeta/metadata.json";

/** ------------------ COLLECTION DEFINITIONS ----------------- **/

//The necessary collections --It would be great
Curriculum = new Mongo.Collection("nh_home_pages");
Modules = new Mongo.Collection("nh_modules");
Lessons = new Mongo.Collection("nh_lessons");
Attempts = new Mongo.Collection("nh_attempts");
PreviousJson = new Mongo.Collection("nh_json");

TrueVaultInfo= new Meteor.Collection("true_vault");

