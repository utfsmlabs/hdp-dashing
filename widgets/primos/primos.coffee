class Dashing.Primos extends Dashing.Widget

  ready: ->
    @currentIndex = 0
    @primoElem = $(@node).find('.primo-container')
    if @nextPrimo()
      @startCarousel()

  onData: (data) ->
    @currentIndex = 0

  startCarousel: ->
    setInterval(@nextPrimo, 2000)

  nextPrimo: =>
    primos = @get('primos')
    if primos
        @primoElem.fadeOut =>
          @currentIndex = (@currentIndex + 1) % primos.length
          @set 'current_primo', primos[@currentIndex]
          @primoElem.fadeIn()
