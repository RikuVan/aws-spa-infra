'use strict'

function handler(event) {
  var request = event.request

  var regexPattern = /\.(?:[a-z]{2,4}|webmanifest)$/

  if (regexPattern.test(request.uri)) {
    return request
  }

  request.uri = '/index.html'

  return request
}
