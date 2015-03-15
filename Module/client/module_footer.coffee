Template.moduleFooter.events
  'click .next': (event, template)->
    next_module = @.modules[0].nh_id
    $("#"+next_module).addClass "is-visible"

