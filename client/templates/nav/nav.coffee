Template.nav.helpers
 logo: ()->
   return MEDIA_URL + "VascularContent/Images/NooraLogo.png"

Template.nav.onRendered ()->
  fview = FView.from this
  console.log "THE NAV FVIEW", fview
  surface = fview.view or fview.surface
  surface.setProperties {zIndex: 12}
