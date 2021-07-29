import 'dart:convert';

import 'package:coronavirus/app/services/api.dart';
import 'package:http/http.dart' as http;

class APIService {
  APIService(this.api);
  final API api;

  Future<String> getAccessToken() async {
    var url = Uri.parse(api.tokenUri().toString());
    final response = await http.post(
      url,
      headers: {'Authorization': 'Basic ${api.apiKey}'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['access_token'];
      if (accessToken != null) {
        return accessToken;
      }
    }
    print('$url\n$response.body');
    throw response;
  }

  Future<int> getEndpointData({
    required String accessToken,
    required Endpoint endpoint,
  }) async {
    final url = api.endpointUri(endpoint);
    final response = await http.get(
      Uri.parse(url.toString()),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200){
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final Map<String, dynamic> endpointData = data[0];
        final String? responseJsonKey = _responseJsonKeys[endpoint];
        final int? result = endpointData[responseJsonKey];
        if (result != null) {
          return result;
        }
      }
    }
    throw response;
  }

  static Map<Endpoint, String> _responseJsonKeys = {
    Endpoint.cases: 'cases',
    Endpoint.casesSuspected: 'data',
    Endpoint.casesConfirmed: 'data',
    Endpoint.deaths: 'data',
    Endpoint.recovered: 'data',
  };
}