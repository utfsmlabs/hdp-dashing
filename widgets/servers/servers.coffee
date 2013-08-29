class Dashing.Servers extends Dashing.Widget

  ready: ->
    @currentIndex = 0
    @servElem = $(@node).find('.servers-container')
    @nextServ()
    @startCarousel()

  onData: (data) ->
    @currentIndex = 0

  startCarousel: ->
    setInterval(@nextServ, 5000)

  nextServ: =>
    servers = @get('servers')
    if servers
      @servElem.fadeOut =>
        @currentIndex = (@currentIndex + 1) % servers.length
        @set 'current_server', servers[@currentIndex]
        @servElem.fadeIn()
