Modules.helpers({
  isSlide: function(){
    return this.type == "SLIDE";
  },

  isMultipleChoice: function(){
    return this.type == "MULTIPLE_CHOICE";
  },

  isScenario: function(){
    return this.type == "SCENARIO";
  },

  isBinary: function(){
    return this.type == "BINARY";
  },

  isVideo: function(){
    return this.type == "VIDEO";
  },

  isGoalChoice: function(){
    return this.type == "GOAL_CHOICE"
  },

  isLastModule:function(){
    return this.next_module == "-1" || this.next_module == -1 ;
  },

  nextModule: function(){
    return Modules.findOne({nh_id: this.next_module});
  },

  getOptions: function(){
    console.log("returning trivial ");
    var options =[];
    var i = 0
    while(i < this.options.length){
      var columnOne = this.options[i]
      var columnTwo = null

      i++
      if(i < this.options.length)
        columnTwo = this.options[i]
      
      options.push({columnOne: columnOne, columnTwo: columnTwo})
      i++
    }
    return options;
  },

  option: function(index){
    return this.options[index];
  },

  answerIsCorrect: function(response){
    check(response, String)
    console.log("This is the response ", response)
    console.log("This si teh correct_answer ", this.correct_answer)
    console.log("these are the options ", this.options)
    return _.indexOf(this.correct_answer, response) != -1;
  },

  getImgSrc: function(){
    return MEDIA_URL + this.image;
  },

  getVideoSrc: function(){
    return MEDIA_URL + this.video;
  },

  getAudioSrc: function(){
    return MEDIA_URL + this.audio;
  }
});