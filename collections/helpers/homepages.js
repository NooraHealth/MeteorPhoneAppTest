Home_Pages.helpers({
  getTitle: function(){
    if(!isDefined(this.title))
      return "";
    
    return this.title;
  },

  //Returns the lessons for the home page
  getLessons: function(){
    var lessons = [];
    for(i in this.lessons){
      var lessonID = this.lessons[i];
      var lesson = Lessons.findOne({nh_id:lessonID});
      lessons.push(lesson);
    }
    return lessons;
  },
});