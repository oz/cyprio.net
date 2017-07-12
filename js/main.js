var Promise = require('bluebird')
var FontFaceObserver = require('fontfaceobserver')

var body = document.getElementsByTagName('body')[0]
var fonts = [
  new FontFaceObserver('Libertine'),
  new FontFaceObserver('Open Sans')
]

Promise.map(fonts, function (font) { return font.load() })
.then(function (font) {
  body.className += ' fonts-loaded'
})
.catch(function (err) {
  console.error('Error loading fonts:', err)
  body.className += ' fonts-loaded'
})
