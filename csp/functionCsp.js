function handler(event) {
    var response = event.response;
    var headers = response.headers;

    var scriptHash = "{{CSP_HASH}}";

    headers['content-security-policy'] = {
        value: `default-src 'none'; base-uri 'self'; img-src 'self' images.dog.ceo: script-src 'self' '${scriptHash}'`
    };

    return response;
}
