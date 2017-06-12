App.comments = App.cable.subscriptions.create "CommentsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $("#messages").prepend(data) #What this says, is if there are new data coming in, simply place this new data on top of the div containing the old data. (See recipes/show view)
    # Called when there's incoming data on the websocket for this channel
