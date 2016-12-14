packageName = 'atom-jasmine-es6-snippets'

fs = require 'fs'

defaultConfig =
  semicolons: false

# console.log __dirname
expectationsPath = "#{__dirname}/../snippets/expectations.cson"
snippetFiles = [ 'blocks.cson', 'expectations.cson', 'matchers.cson', 'spies.cson' ]#.map (file) =>
  # return "#{__dirname}/../raw-snippets/#{file}"

addFullPathToFiles = (directory, files) ->
  return files.map (file) => "#{__dirname}/../#{directory}/#{file}"

# console.log (addFullPathToFiles 'raw-snippets', snippetFiles)

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

    inputFiles = addFullPathToFiles 'raw-snippets', snippetFiles
    outputFiles = addFullPathToFiles 'new-snippets', snippetFiles

    if not fs.existsSync "#{__dirname}/../new-snippets"
      fs.mkdir "#{__dirname}/../new-snippets"

    inputFiles.forEach (file, idx) =>
      console.log file
      newText = oldText = fs.readFileSync file, 'utf8'
      (Object.keys replacements).forEach (replacement) =>
        re = new RegExp(replacement, 'g')
        newText = newText.replace re, replacements[replacement]

      fs.writeFileSync outputFiles[idx], newText, 'utf8'


    # update snippets to have semicolons, if necessary
    if inputConfig.semicolons
      # loop through snippetFiles and replace __sc__ placeholders with semicolons
      console.log 'let us add semicolons'
      oldText = fs.readFileSync expectationsPath, 'utf8'
      newText = oldText.replace 'expect(${1:target}).toBeDefined()$2', 'expect(${1:target}).toBeDefined();$2'
      fs.writeFileSync expectationsPath, newText, 'utf8'
    else
      # loop through snippetFiles and remove __sc__ placeholders
