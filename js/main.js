const Promise = require('bluebird')
const FontFaceObserver = require('fontfaceobserver')

const body = document.getElementsByTagName('body')[0]
const fonts = [
  new FontFaceObserver('Libertine'),
  new FontFaceObserver('Open Sans')
]

Promise.map(fonts, function (font) { return font.load() })
  .then(function (_font) {
    body.className += ' fonts-loaded'
  })
  .catch(function (err) {
    console.error('Error loading fonts:', err)
    body.className += ' fonts-loaded'
  })
