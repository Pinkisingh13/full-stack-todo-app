import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:todoappflutter/models/todo.dart';
import 'package:http/http.dart' as http;

class TodoService {
  static String baseUrl = dotenv.env['BASE_URL'].toString();

  //! GET ALL TODOS
  static Future<List<Todo>> getTodos() async {
    try {
      final url = Uri.parse(baseUrl);
      print('📡 GET Request to: $url');

      final response = await http.get(url);

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        return data.map((t) => Todo.fromJson(t)).toList();
      } else {
        throw Exception("Failed to load todos - Status: ${response.statusCode}, Body: ${response.body}");
      }
    } catch (e) {
      print('❌ GET Todos Error: $e');
      throw Exception("Failed to get all todos: $e");
    }
  }

  static Future<Todo> createTodos(Map<String, dynamic> body) async {
    try {
      final url = Uri.parse("${baseUrl}create-todo");
      print('📡 POST Request to: $url');
      print('📤 Payload: ${jsonEncode(body)}');

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return Todo.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to create todo - Status: ${response.statusCode}, Body: ${response.body}");
      }
    } catch (e) {
      print('❌ Create Todo Error: $e');
      throw Exception("Failed to create todo: $e");
    }
  }

  static Future<Todo> updateTodos(Map<String, dynamic> body, String id) async {
    try {
      final url = Uri.parse("${baseUrl}update-todo");
      print('📡 PUT Request to: $url');
      print('📤 Payload: ${jsonEncode(body)}');

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 201) {
        return Todo.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to update todo - Status: ${response.statusCode}, Body: ${response.body}");
      }
    } catch (e) {
      print('❌ Update Todo Error: $e');
      throw Exception("Failed to update todo: $e");
    }
  }

  static Future<int> deleteTodos(String id) async {
    try {
      final url = Uri.parse("${baseUrl}delete-todo");
      print('📡 DELETE Request to: $url');
      print('📤 Payload (ID): $id');

      final response = await http.delete(
        url,
        headers: {"Content-Type": "application/json"},
        body: id,
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        throw Exception("Failed to delete todo - Status: ${response.statusCode}, Body: ${response.body}");
      }
    } catch (e) {
      print('❌ Delete Todo Error: $e');
      throw Exception("Failed to delete todo: $e");
    }
  }

  Future<String> summarizeTodos() async {
    try {
      final url = Uri.parse("${baseUrl}ai-summarize");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception("Failed to summarize the todos");
      }
    } catch (e) {
      throw Exception("Failed to summarize the todos from catch");
    }
  }
}
