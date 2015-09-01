
###
# Video Surface
###
class @VideoSurface extends ModuleSurface
  constructor: ( @_module, index )->
    super @._module, index

    @.setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.RELATIVE_SIZE
     .setProportionalSize 1, 1, 1
     #.setAbsoluteSize 700, 500, 0

    videoSrc = @._module.videoSrc()
    id = @._module._id
    if @._module.isEmbedded()
      content = "
        <iframe id='#{id}' title='#{@._module.title}' class='embedded-video ytplayer' src='#{@._module.video_url}?start=#{@._module.start}}&end=#{@._module.end}' frameborder='0' allowfullscreen></iframe>
        "
    else
      content = "<video id='#{id}' src='#{videoSrc}'  controls> Your browser does not support this video tag, please logout and use another browser </video>"
    @.domElement = new DOMElement @, {
      properties:
        height: "100%"
      content: content
    }

  moveOnstage: ()=>
    super

  getVideoElem: ()->
    return $("#" + @._module._id)[0]
  moveOffstage: ()=>
    video = @.getVideoElem()
    console.log video
    if video and video.pause
      video.pause()
    else if video and video.pauseVideo
      console.log "PAUSE VIDEO"
      video.pauseVideo()
    else
      video.setAttribute "src", ""
    super

