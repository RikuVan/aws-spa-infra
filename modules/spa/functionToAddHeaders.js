function handler(event) {
  var response = event.response
  var headers = response.headers

  if ('x-amz-meta-csp' in headers) {
    // Extract the value of the X-Amz-Meta-Csp header
    var cspValue = headers['x-amz-meta-csp'].value

    var cspHeaderValue =
      "default-src 'self'; style-src-elem 'self' https://cdn.jsdelivr.net; img-src 'self' https://images.dog.ceo; script-src 'self' '" +
      cspValue +
      "';"

    headers['content-security-policy'] = {
      value: cspHeaderValue,
    }

    delete headers['x-amz-meta-csp']
  } else {
    headers['content-security-policy'] = {
      value:
        "default-src 'self'; style-src-elem 'self' https://cdn.jsdelivr.net; img-src 'self' https://images.dog.ceo; script-src 'self';",
    }
  }

  return response
}
    