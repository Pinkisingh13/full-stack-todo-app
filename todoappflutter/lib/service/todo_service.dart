import 'dart:convert';

import 'package:todoappflutter/models/todo.dart';
import 'package:todoappflutter/config/app_config.dart';
import 'package:http/http.dart' as http;

class TodoService {
  static String baseUrl = AppConfig.baseUrl;

  //! GET ALL TODOS
  static Future<List<Todo>> getTodos() async {
    try {
      final url = Uri.parse(baseUrl);
      print('📡 GET Request to: $url');

      final response = await http.get(url);

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic decodedData = jsonDecode(response.body);

        if (decodedData is! List) {
          print('❌ Expected a List but got: ${decodedData.runtimeType}');
          throw Exception("API returned unexpected data format");
        }

        List data = decodedData;
        print('📊 Parsing ${data.length} todos...');

        return data.map((t) {
          if (t is! Map<String, dynamic>) {
            print('❌ Todo item is not a Map: $t');
            throw Exception("Invalid todo format");
          }
          return Todo.fromJson(t as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception(
          "Failed to load todos - Status: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e, stackTrace) {
      print('❌ GET Todos Error: $e');
      print('📍 Stack trace: $stackTrace');
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Todo.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          "Failed to create todo - Status: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      print('❌ Create Todo Error: $e');
      throw Exception("Failed to create todo: $e");
    }
  }

  static Future<Todo> updateTodos(Map<String, dynamic> body, String id) async {
    try {
      final url = Uri.parse("${baseUrl}update-todo/$id");
      print('📡 PUT Request to: $url');
      print('📤 Payload: ${jsonEncode(body)}');

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Todo.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          "Failed to update todo - Status: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      print('❌ Update Todo Error: $e');
      throw Exception("Failed to update todo: $e");
    }
  }

  static Future<int> deleteTodos(String id) async {
    try {
      final url = Uri.parse("${baseUrl}delete-todo/$id");
      print('📡 DELETE Request to: $url');

      final response = await http.delete(url);

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        throw Exception(
          "Failed to delete todo - Status: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      print('❌ Delete Todo Error: $e');
      throw Exception("Failed to delete todo: $e");
    }
  }

  static Future<String> summarizeTodos() async {
    try {
      
      final url = Uri.parse("${baseUrl}ai-summary");

      print('📡 AI SUMMARY Request to: $url');
      final response = await http.get(url);

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['summary'] as String;
      } else {
        throw Exception("Failed to summarize the todos");
      }
    } catch (e) {
      throw Exception("Failed to summarize the todos from catch");
    }
  }


}
