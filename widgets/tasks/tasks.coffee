class Dashing.Tasks extends Dashing.Widget

  ready: ->
    @currentIndex = 0
    @taskElem = $(@node).find('.task-container')
    @nextTask()
    @startCarousel()

  onData: (data) ->
    @currentIndex = 0

  startCarousel: ->
    setInterval(@nextTask, 20000)

  nextTask: =>
    tasks = @get('tasks')
    if tasks
      @taskElem.fadeOut =>
        @currentIndex = (@currentIndex + 1) % tasks.length
        @set 'current_task', tasks[@currentIndex]
        @taskElem.fadeIn()