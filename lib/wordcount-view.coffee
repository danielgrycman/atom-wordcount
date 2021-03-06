{View} = require 'atom-space-pen-views'

module.exports =
class WordcountView extends View
  CSS_SELECTED_CLASS: 'wordcount-select'

  constructor: ->
    super
    @divWords = document.createElement 'div'
    @append @divWords

  @content: ->
    @div class: 'word-count inline-block'

  update_count: (editor) ->
    text = @getCurrentText editor
    [wordCount, charCount] = @count text
    @divWords.innerHTML = "#{wordCount || 0} W | #{charCount || 0} C"
    if goal = atom.config.get 'wordcount.goal'
      if not @divGoal
        @divGoal = document.createElement 'div'
        @divGoal.style.width = '100%'
        @append @divGoal
      green = Math.round(wordCount / goal * 100)
      green = 100 if green > 100
      color = atom.config.get 'wordcount.goalColor'
      @divGoal.style.background = '-webkit-linear-gradient(left, ' + color + ' ' + green + '%, transparent 0%)'
      percent = parseFloat(atom.config.get 'wordcount.goalLineHeight') / 100
      height = @height() * percent;
      @divGoal.style.height = height + 'px'
      @divGoal.style.marginTop = -height + 'px'

  getCurrentText: (editor) =>
    selection = editor.getSelectedText()
    if selection
      @addClass @CSS_SELECTED_CLASS
    else
      @removeClass @CSS_SELECTED_CLASS
    text = editor.getText()
    selection || text

  count: (text) ->
    words = text?.match(/\S+/g)?.length
    chars = text?.length
    [words, chars]
