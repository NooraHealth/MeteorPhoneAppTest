
Lessons.helpers({
  hasSublessons: function(){
    if(!isDefined(this.has_sublessons))
      return false;

    return this.has_sublessons.toLowerCase() == "true";
  },
  
  getTitle: function(){
    return this.title;
  },

  getLessons: function(){
    var lessons = [];
    for(i in this.lessons){
      var lessonID = this.lessons[i];
      var lesson = Lessons.findOne({nh_id:lessonID});
      lessons.push(lesson);
    }
    return lessons;
  },

  firstModule: function(){
    return Modules.findOne({nh_id: this.first_module});
  },

  getImgSrc: function(){
    return MEDIA_URL + this.image;
  },

  getParentId: function(){
    lessons = Lessons.find({has_sublessons: "true"}).fetch()
    
    var parents = {}
    for(i in lessons){
      if(_.contains(lessons[i].lessons, this.nh_id))
        parents.push(lessons[i].nh_id)
    }

    if(parents.length > 1 )
      throw "Error fetching the parent of lesson " + this.nh_id + ": more than 1 parent"

    return parents;
  }

});
