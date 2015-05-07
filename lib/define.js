/** ---------------------- VARIABLES ------------------------ **/

//The percent necessary for it to be considered as having passed a module successfully
PASSING_GRADE = 75;
TRUE = "YES";
FALSE = "NO";
//BUCKET = 'elasticbeanstalk-us-west-1-584511731882';
REGION="us-west-1";
BUCKET = "noorahealthcontent";
//REGION="us-west-2";
//BUCKET = 'elasticbeanstalk-us-west-2-584511731882';

/**---------------------- URLS ----------------------------------**/

MEDIA_URL = "http://grass-roots-science.info/";
//DATA_URL = "http://serene-forest-4377.herokuapp.com/VascularContent/VascularMeta/";
DATA_URL = "http://serene-forest-4377.herokuapp.com/VascularContent/VascularMeta/metadata.json";
//MEDIA_URL= ""

/** ------------------ COLLECTION DEFINITIONS ----------------- **/

//The necessary collections --It would be great
Curriculum = new Mongo.Collection("nh_home_pages");
Modules = new Mongo.Collection("nh_modules");
Lessons = new Mongo.Collection("nh_lessons");
Attempts = new Mongo.Collection("nh_attempts");
PreviousJson = new Mongo.Collection("nh_json");

CONTENT_FOLDER = "NooraHealthContent/";
VIDEO_FOLDER = "Video/";
IMAGE_FOLDER = "Image/";
AUDIO_FOLDER = "Audio/";

Slingshot.fileRestrictions("s3", {
  allowedFileTypes: ["image/png", "image/jpeg", "image/gif", "video/mp4", "audio/mp3"],
  maxSize: 500 * 1024 * 1024 // 500 MB (use null for unlimited)
});

