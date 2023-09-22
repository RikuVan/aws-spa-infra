function handler(event) {
    var response = event.response;
    var headers = response.headers;

    var scriptHash = "{{CSP_HASH}}";

    headers['content-security-policy'] = {
        value: `default-src 'self'; style-src-elem https://cdn.jsdelivr.net; img-src 'self' https://images.dog.ceo; script-src 'self' '${scriptHash}'`
    };

    return response;
}
