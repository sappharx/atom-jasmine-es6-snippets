packageName = 'atom-jasmine-es6-snippets'

fs = require 'fs'

defaultConfig =
  semicolons: false

packageRoot = "#{__dirname}/../"
snippetFiles = [ 'blocks', 'expectations', 'matchers', 'spies' ].map (name) => "#{name}.cson"

addFullPathToFile = (directory, file) -> "#{packageRoot}#{directory}/#{file}"

inputConfig = defaultConfig

module.exports =

  config:
    semicolons:
      title: "Semicolons"
      description: "Whether or not to add semicolons"
      type: 'boolean'
      default: defaultConfig.semicolons

  activate: (state) ->
    @observers = []

    @observers.push atom.config.observe "#{packageName}.semicolons", (newValue) =>
      inputConfig.semicolons = newValue

    replacements =
      '__sc__': if inputConfig.semicolons then ';' else ''

    if not fs.existsSync "#{packageRoot}snippets"
      fs.mkdir "#{packageRoot}snippets"

    snippetFiles.forEach (file) =>
      template = addFullPathToFile 'templates', file
      output = addFullPathToFile 'snippets', file

      newText = oldText = fs.readFileSync template, 'utf8'
      (Object.keys replacements).forEach (replacement) =>
        re = new RegExp replacement, 'g'
        newText = newText.replace re, replacements[replacement]

      fs.writeFileSync output, newText, 'utf8'
