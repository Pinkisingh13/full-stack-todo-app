import 'package:flutter/foundation.dart';
import '../models/todo.dart';
import '../service/todo_service.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  bool _isLoading = false;
  bool _isSummarizing = false;
  String? _errorMessage;

  String? _summarizeText;

  // Getters
  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;
  bool get isSummarizing => _isSummarizing;
  String? get errorMessage => _errorMessage;
  String? get todosummarize => _summarizeText;

  int get totalTodos => _todos.length;
  int get completedTodos => _todos.where((todo) => todo.isCompleted).length;
  int get pendingTodos => totalTodos - completedTodos;

  List<Todo> get completedTodosList =>
      _todos.where((todo) => todo.isCompleted).toList();
  List<Todo> get pendingTodosList =>
      _todos.where((todo) => !todo.isCompleted).toList();

  // Fetch all todos from API
  Future<void> fetchTodos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _todos = await TodoService.getTodos();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Add a new todo
  Future<void> addTodo({
    required String title,
    required String description,
    required String priority,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final body = {
        'todotitle': title,
        'description': description,
        'priority': priority.toLowerCase(),
        'isCompleted': false,
      };

      final newTodo = await TodoService.createTodos(body);
      _todos.add(newTodo);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Update an existing todo
  Future<void> updateTodo({
    required String id,
    required String title,
    required String description,
    required String priority,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final todo = _todos.firstWhere((todo) => todo.id == id);

      final body = {
        'id': id,
        'todotitle': title,
        'description': description,
        'priority': priority.toLowerCase(),
        'isCompleted': todo.isCompleted,
      };

      final updatedTodo = await TodoService.updateTodos(body, id);

      // Update local state
      todo.title = updatedTodo.title;
      todo.description = updatedTodo.description;
      todo.priority = updatedTodo.priority;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Delete a todo
  Future<void> deleteTodo(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await TodoService.deleteTodos(id);
      _todos.removeWhere((todo) => todo.id == id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Toggle todo completion status
  Future<void> toggleTodo(String id) async {
    try {
      final todo = _todos.firstWhere((todo) => todo.id == id);

      // Optimistically update UI
      todo.isCompleted = !todo.isCompleted;
      notifyListeners();

      final body = {
        'id': id,
        'todotitle': todo.title,
        'description': todo.description,
        'priority': todo.priority.toLowerCase(),
        'isCompleted': todo.isCompleted,
      };

      await TodoService.updateTodos(body, id);
    } catch (e) {
      // Revert on error
      final todo = _todos.firstWhere((todo) => todo.id == id);
      todo.isCompleted = !todo.isCompleted;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

Future<void> summarize() async {
  try {
    print("Summarize start");

    _isSummarizing = true;
    notifyListeners();

    final String s = await TodoService.summarizeTodos();

    print("Summarize Todo Text: $s");

    if (s.isNotEmpty) {
      _summarizeText = s;
    } else {
      print("Summarize todo text is empty");
    }

    _isSummarizing = false;
    notifyListeners();

  } catch (e) {
    _isSummarizing = false;
    _errorMessage = e.toString();
    notifyListeners();

    print("❌ Summarize Error: $e");
  }
}
}
