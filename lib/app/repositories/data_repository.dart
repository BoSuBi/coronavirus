import 'package:coronavirus/app/repositories/endpoints_data.dart';
import 'package:coronavirus/app/services/api.dart';
import 'package:coronavirus/app/services/api_service.dart';
import 'package:http/http.dart';

class DataRepository {
  DataRepository({required this.apiService});
  final APIService apiService;

  String _accessToken = '';

  Future<int> getEndpointData(Endpoint endpoint) async {
    try {
      return await apiService.getEndpointData(accessToken: _accessToken, endpoint: endpoint);
    } on Response catch (response) {
      if (response.statusCode == 401) {
        _accessToken = await apiService.getAccessToken();
        return await apiService.getEndpointData(accessToken: _accessToken, endpoint: endpoint);
      }
      rethrow;
    }
  }

  Future<EndpointsData> getAllEndpointData() async {
    try {
      return await _getAllEndpointData();
    } on Response catch (response) {
      if (response.statusCode == 401) {
        _accessToken = await apiService.getAccessToken();
        return await _getAllEndpointData();
      }
      rethrow;
    }
  }

  Future<EndpointsData> _getAllEndpointData() async {
    final values = await Future.wait([
      apiService.getEndpointData(accessToken: _accessToken, endpoint: Endpoint.cases),
      apiService.getEndpointData(accessToken: _accessToken, endpoint: Endpoint.casesSuspected),
      apiService.getEndpointData(accessToken: _accessToken, endpoint: Endpoint.casesConfirmed),
      apiService.getEndpointData(accessToken: _accessToken, endpoint: Endpoint.deaths),
      apiService.getEndpointData(accessToken: _accessToken, endpoint: Endpoint.recovered),
    ]);
    return EndpointsData(
      values: {
        Endpoint.cases: values[0],
        Endpoint.casesSuspected: values[1],
        Endpoint.casesConfirmed: values[2],
        Endpoint.deaths: values[3],
        Endpoint.recovered: values[4],
      },
    );
  }
}