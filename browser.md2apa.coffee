# browserify -t coffeeify browser.md2apa.coffee > js/md2apa.js

window.md2apa            = require './md2apa.coffee'
window.md                = require('markdown').markdown
window._                 = require 'underscore'
window.extractMetadata   = md2apa.extractMetadata
window.createAPADocument = md2apa.createAPADocument
window.blobStream        = require 'blob-stream'
ace                      = require 'brace'
require 'brace/theme/textmate'
require 'brace/mode/markdown'

window.editor = ace.edit 'editor'
editor.setTheme 'ace/theme/textmate'
editor.getSession().setMode 'ace/mode/markdown'
editor.getSession().setUseWrapMode true
editor.renderer.setShowPrintMargin false

# do we have anything saved?
if essay = localStorage?.getItem 'APA_paper'
  editor.getSession().setValue essay

refreshTimer = null
editor.getSession().on 'change', ->
  clearTimeout refreshTimer
  refreshTimer = setTimeout(->
    refresh()
    localStorage?.setItem 'APA_paper', editor.getSession().getValue()
  , 1000)

window.refresh = ->
  content  = editor.getSession().getValue()
  content  = extractMetadata content
  body     = content.body
  metadata = content.metadata
  stream   = blobStream()
  doc      = createAPADocument body, metadata, stream
  stream.on 'finish', ->
    # get a blob you can do whatever you like with
    # blob = stream.toBlob 'application/pdf'

    # or get a blob URL for display in the browser
    url = stream.toBlobURL 'application/pdf'
    document.getElementById('preview').src = url

    document.title = "#{metadata.title} - MarkdownToAPA.com"

refresh()
