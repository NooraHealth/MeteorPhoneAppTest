/** ---------------------- VARIABLES ------------------------ **/

TRUE = "YES";
FALSE = "NO";

REGION="us-west-1";
BUCKET = "noorahealthcontent";
DEV_BUCKET = "noorahealthcontent";

/** ------------------ COLLECTION DEFINITIONS ----------------- **/

Curriculums = new Mongo.Collection("nh_home_pages");
Modules = new Mongo.Collection("nh_modules");
Lessons = new Mongo.Collection("nh_lessons");
Attempts = new Mongo.Collection("nh_attempts");

Ground.Collection(Curriculums);
Ground.Collection(Modules);
Ground.Collection(Lessons);
Ground.Collection(Attempts);

VIDEO_FOLDER = "Video/";
IMAGE_FOLDER = "Image/";
AUDIO_FOLDER = "Audio/";

