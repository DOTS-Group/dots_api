import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dots_client.dart';

class DotsQueryBuilder {
  final Dots _client;
  final String _table;

  DotsQueryBuilder(this._client, this._table);

  /// Helper for headers
  Map<String, String> get _headers => _client.authHeaders();

  /// Execute Select Query
  Future<dynamic> select() async {
    final response = await http.get(
      Uri.parse('${Dots.baseUrl}/$_table'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  /// Execute Insert Query
  Future<dynamic> insert(Map<String, dynamic> data) async {
    // Automatically inject project_id if missing
    final bodyData = Map<String, dynamic>.from(data);
    if (!bodyData.containsKey('project_id')) {
      bodyData['project_id'] = _client.projectId;
    }

    final response = await http.post(
      Uri.parse('${Dots.baseUrl}/$_table'),
      headers: _headers,
      body: jsonEncode(bodyData),
    );
    return _handleResponse(response);
  }

  /// Execute Update Query
  Future<dynamic> update(Map<String, dynamic> data,
      {required String idColumn, required dynamic idValue}) async {
    final uri = Uri.parse('${Dots.baseUrl}/$_table?$idColumn=eq.$idValue');

    final response = await http.patch(
      uri,
      headers: _headers,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  /// Execute Delete Query
  Future<dynamic> delete(
      {required String idColumn, required dynamic idValue}) async {
    final uri = Uri.parse('${Dots.baseUrl}/$_table?$idColumn=eq.$idValue');

    final response = await http.delete(
      uri,
      headers: _headers,
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      throw DotsException('DB Error', response.statusCode, response.body);
    }
  }
}
