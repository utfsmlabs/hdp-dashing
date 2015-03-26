class Dashing.Labs extends Dashing.Widget
  ready: ->
    @currentIndex = 0
    @labElem = $(@node).find('.labs-container')
    @nextLab()
    @startCarousel()

  onData: (data) ->
    @currentIndex = 0

  startCarousel: ->
    setInterval(@nextLab, 2000)

  nextLab: =>
    labs = @get('labs')
    if labs
      @labElem.fadeOut =>
        @currentIndex = (@currentIndex + 1) % labs.length
        @set 'current_labs', labs[@currentIndex]
        @labElem.fadeIn()
