
###
# Video Surface
###
class @VideoSurface
  @get: ( module, parent )->
    if not @.surface
      @.surface = new PrivateSurface module
      parent.addChild @.surface
    else
      @.surface.setModule module
    return @.surface

  class PrivateSurface extends ModuleSurface
    constructor: ( @_module )->
      super @._module

      @.setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.RELATIVE_SIZE
      .setProportionalSize .8, .8, 1
      .setAlign .5, .6, .5

      @.domElement = new DOMElement @, {
        properties:
          height: "100%"
      }
      @.setContent()

    setModule: ( module )->
      @._module = module
      super

      @.setContent()

    setContent: ()->
      videoSrc = @._module.videoSrc()
      id = @._module._id
      if @._module.isEmbedded()
        content = "
          <iframe id='#{id}' title='#{@._module.title}' class='embedded-video ytplayer' src='#{@._module.video_url}?start=#{@._module.start}}&end=#{@._module.end}' frameborder='0' allowfullscreen></iframe>
          "
      else
        content = "<video id='#{id}' src='#{videoSrc}'  controls> Your browser does not support this video tag, please logout and use another browser </video>"

      @.domElement.setContent content

    getVideoElem: ()->
      return $("#" + @._module._id)[0]

    moveOffstage: ()=>
      video = @.getVideoElem()
      if video and video.pause
        video.pause()
      else if video and video.pauseVideo
        video.pauseVideo()
      else
        @.domElement.setContent ""
      super

