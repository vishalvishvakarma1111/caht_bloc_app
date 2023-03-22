import 'dart:convert';

import 'package:http/http.dart' as http;

var headers = {
  'Authorization':
      'key=AAAAVTG0eww:APA91bHiK-EdP9DJVKntvwlRkmJ-IZZrt1RSddwPDIYb5d3glpFyYrFC-UO3n3AFO1_CHYZ8-srjs-X3GpGfptgbFrHC0ZKLI2rWti8hQvCjuBNT28XQbjiel-Q3g7-5_bYcLALPcOQN',
  'Content-Type': 'application/json'
};

var request = http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));

class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  postApi({required Map<String, dynamic> map}) async {
    var url = Uri.https('fcm.googleapis.com', '/fcm/send');

    var response = await http.post(url, body: jsonEncode(map), headers: headers);

    print('Response status:${response.statusCode}');
    print('Response body:${response.body}');
  }
}
