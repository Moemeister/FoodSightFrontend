import 'dart:convert';

import 'package:http/http.dart' as http;

//generada Sara
const GOOGLE_API_KEY = 'AIzaSyAW-LSQCWxkF7Mxja-8a42F1MgMVytW5y0';
// const GOOGLE_API_KEY = 'AIzaSyDqLMpPgNZqFuwApF508IfllFnDhw0CZhA';

class LocationHelper {
  static String generateLocationPreviewImage(
      {double latitude, double longitud}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitud&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:S%7C$latitude,$longitud&key=$GOOGLE_API_KEY';
  }

  static Future<String> getResAddress(double lat, double long) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$GOOGLE_API_KEY';

    final response = await http.get(url);

    // print('DIRECCION AAAAH' +
    //     json.decode(response.body)['results'][0]['formatted_address']);

    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
