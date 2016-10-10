
self.addEventListener("message", ( OfflineEvents, Analytics )=> {
  const events = OfflineEvents.find({}).fetch();
  console.log("Events to register");
  for( event in events ){
    console.log("Event register");
    Analytics.registerEvent(event.type, event.name, JSON.parse(event.params));
    OfflineEvents.remove({ _id: event._id });
  }
}, false)
