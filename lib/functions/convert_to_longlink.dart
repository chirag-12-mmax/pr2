import 'dart:io';

Future<String?> expandShortUrl({required String shortUrl}) async {
  try {
    final client = HttpClient();
    var uri = Uri.parse(shortUrl);
    var request = await client.getUrl(uri);
    request.followRedirects = false;
    var response = await request.close();

    while (response.isRedirect) {
      response.drain();
      final location = response.headers.value(HttpHeaders.locationHeader);

      if (location != null) {
        uri = uri.resolve(location);
        request = await client.getUrl(uri);
        // Set the body or headers as desired.

        if (location.toString().contains('job-description')) {
          return location.toString();
        }
        request.followRedirects = false;
        response = await request.close();
      }
    }

    return null;
  } catch (e) {
    return null;
  }
}
