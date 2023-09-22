function handler(event) {
    var response = event.response;
    var headers = response.headers;

    var scriptHash = "sha256-w1EbJKI4wFD9MhNIT2xnVkE9chgUnVsk4Vqc1yWlGS0=";

    headers['content-security-policy'] = {
        value: `default-src 'self'; style-src-elem 'self' https://cdn.jsdelivr.net; img-src 'self' https://images.dog.ceo; script-src 'self' '${scriptHash}'`
    };

    return response;
}
