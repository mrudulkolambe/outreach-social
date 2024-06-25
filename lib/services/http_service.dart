import 'dart:convert';
import 'package:http/http.dart' as http;

getMethod(endpointurl) async {
  var json = <String, dynamic>{};
  final urlstring = 'http://18.206.233.144:8000/Api' + endpointurl;
  final response = await http.get(Uri.parse(urlstring));

  if (response.statusCode == 200) {
    json = jsonDecode(response.body);
    return json;
  } else {
    json = {'status': 0, 'alertmessage': 'Failed to load books'};
    return json;
  }
}

postMethod(endpointurl, jsonBody) async {
  var json = <String, dynamic>{};
  final urlstring = 'http://18.206.233.144:8000/Api' + endpointurl;

  final response = await http.post(Uri.parse(urlstring), body: jsonBody);
  if (response.statusCode == 200) {
    json = jsonDecode(response.body);
    return json;
  } else {
    json = {'status': 0, 'alertmessage': 'Failed to load books'};
    return json;
  }
}


class HttpParams {
  final headersValues = {};
}
