Template.footer.events {
  "change #condition": ()->
    condition = $("#condition").val()
    Session.set "condition", condition
}
Tracker.autorun ()->
  if(Session.get "condition") == "1"
    MEDIA_URL = "http://grass-roots-science.info/"
  else
    MEDIA_URL = ""
