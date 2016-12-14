packageName = 'atom-jasmine-es6-snippets'

fs = require 'fs'

defaultConfig =
  semicolons: false
console.log __dirname
expectationsPath = "#{__dirname}/../snippets/expectations.cson"
snippetFiles = [ 'blocks.cson', 'expectations.cson', 'matchers.cson', 'spies.cson' ].map (file) =>
  return "#{__dirname}/../raw-snippets/#{file}"

console.log snippetFiles

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

    # update snippets to have semicolons, if necessary
    if inputConfig.semicolons
      # loop through snippetFiles and replace __sc__ placeholders with semicolons
      console.log 'let us add semicolons'
      oldText = fs.readFileSync expectationsPath, 'utf8'
      newText = oldText.replace 'expect(${1:target}).toBeDefined()$2', 'expect(${1:target}).toBeDefined();$2'
      fs.writeFileSync expectationsPath, newText, 'utf8'
    else
      # loop through snippetFiles and remove __sc__ placeholders
