import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:traffic/models.dart';

class NetworkHandler {
  String endpoint;

  // Have one client so TCP Connections can be reused
  final _client = http.Client();

  NetworkHandler({
    required this.endpoint,
  });

  Future<(TrafficInfo?, bool)> makeAPICall() async {
    final uri = Uri.parse(endpoint);

    try {
      final response = await _client.get(uri);

      if (!response.statusCode.toString().startsWith('2')) {
        return (null, false);
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      // log(body.toString());

      final trafficInfo = TrafficInfo.fromJson(body);

      return (trafficInfo, true);
    } catch (e) {
      return (null, false);
    }
  }
}
