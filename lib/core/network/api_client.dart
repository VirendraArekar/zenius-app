import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({
    this.baseUrl = 'http://localhost:8080/api/v1',
  });

  String baseUrl;
  String? authToken;
  String currentOrgId = 'org-acme-prod';

  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
        'X-Tenant-Id': currentOrgId,
      };

  Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.get(uri, headers: headers).timeout(
            const Duration(seconds: 4),
          );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        return decoded['data'] ?? decoded;
      }
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    } catch (e) {
      // Return null to trigger repository mock fallback
      return null;
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http
          .post(uri, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 4));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        return decoded['data'] ?? decoded;
      }
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    } catch (e) {
      return null;
    }
  }
}
