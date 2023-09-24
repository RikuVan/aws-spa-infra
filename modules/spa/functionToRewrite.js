'use strict'

function handler(event) {
  var request = event.request

  'use strict'

  function handler(event) {
    var request = event.request

    var regexPattern = /\.[a-zA-Z]{2,4}$/

    if (regexPattern.test(request.uri)) {
      return request
    }

    request.uri = '/index.html'

    return request
  }
  // Otherwise, modify the request to fetch index.html
  request.uri = '/index.html'
  return request
}
