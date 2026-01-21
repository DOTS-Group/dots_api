import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dots_client.dart';

class DotsAuth {
  final Dots _client;

  DotsAuth(this._client);

  /// Sign Up a new user
  Future<dynamic> signUp(
      {required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('${Dots.baseUrl}/rpc/signup'),
      headers: _client.authHeaders(useAnon: true),
      body: jsonEncode({
        'email': email,
        'password': password,
        'project_id': _client.projectId
      }),
    );
    return _handleResponse(response);
  }

  /// Sign In an existing user
  Future<Map<String, dynamic>> signIn(
      {required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('${Dots.baseUrl}/rpc/login'),
      headers: _client.authHeaders(useAnon: true),
      body: jsonEncode({
        'email': email,
        'password': password,
        'project_id': _client.projectId
      }),
    );

    final data = _handleResponse(response);

    if (data is Map<String, dynamic> && data['token'] != null) {
      _client.setSession(data['token']);
    }
    return data as Map<String, dynamic>;
  }

  /// Sign Out
  void signOut() {
    _client.clearSession();
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      throw DotsException('Auth Error', response.statusCode, response.body);
    }
  }
}
