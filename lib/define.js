/** ---------------------- VARIABLES ------------------------ **/

//The percent necessary for it to be considered as having passed a module successfully
PASSING_GRADE = 75;
TRUE = "YES";
FALSE = "NO";
//BUCKET = 'elasticbeanstalk-us-west-1-584511731882';
REGION="us-west-1";
BUCKET = "noorahealthcontent";
DEV_BUCKET = "noorahealthcontent";
//REGION="us-west-2";
//BUCKET = 'elasticbeanstalk-us-west-2-584511731882';

/** ------------------ COLLECTION DEFINITIONS ----------------- **/

//The necessary collections --It would be great
Curriculum = new Mongo.Collection("nh_home_pages");
Modules = new Mongo.Collection("nh_modules");
Lessons = new Mongo.Collection("nh_lessons");
Attempts = new Mongo.Collection("nh_attempts");

Ground.Collection(Curriculum);
Ground.Collection(Modules);
Ground.Collection(Lessons);
Ground.Collection(Attempts);

VIDEO_FOLDER = "Video/";
IMAGE_FOLDER = "Image/";
AUDIO_FOLDER = "Audio/";

