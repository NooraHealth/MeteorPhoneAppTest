Template.nav.helpers
 logo: ()->
   return MEDIA_URL + "VascularContent/Images/NooraLogo.png"

Template.nav.events
  'click #showImgs': ()->
    console.log "Showing src"
    imgs = $("img")
    $.each imgs, (i, img)->
      src = $(img).attr "src"
      console.log src



Template.nav.onRendered ()->
  fview = FView.from this
  surface = fview.view or fview.surface
  surface.setProperties {zIndex: 12}
