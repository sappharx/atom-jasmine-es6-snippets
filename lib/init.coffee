packageName = 'atom-jasmine-es6-snippets'

fs = require 'fs'
path = require 'path'

defaultConfig =
  semicolons: false

packageRoot = path.join __dirname, '..'
snippetFiles = [ 'blocks', 'expectations', 'matchers', 'spies' ].map (name) => "#{name}.cson"

addFullPathToFile = (directory, file) -> path.join packageRoot, directory, file

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

    if not fs.existsSync (path.join packageRoot, 'snippets')
      fs.mkdir (path.join packageRoot, 'snippets')

    snippetFiles.forEach (file) =>
      template = addFullPathToFile 'templates', file
      output = addFullPathToFile 'snippets', file

      fs.readFile template, 'utf8', (err, oldText) =>
        if err?
          return console.error err

        newText = oldText
        (Object.keys replacements).forEach (replacement) =>
          re = new RegExp replacement, 'g'
          newText = newText.replace re, replacements[replacement]

          fs.writeFile output, newText, 'utf8', (err) =>
            if err?
              return console.error err
