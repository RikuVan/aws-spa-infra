'use strict'

function handler(event) {
  var request = event.request

  // Check if the request is for a JS or CSS resource
  if (request.uri.startsWith('/js/') || request.uri.startsWith('/css/')) {
    // If it is, let the request proceed as-is
    return request
  }

  // Otherwise, modify the request to fetch index.html
  request.uri = '/index.html'
  return request
}
