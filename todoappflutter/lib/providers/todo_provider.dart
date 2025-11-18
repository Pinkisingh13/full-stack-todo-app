import 'package:flutter/foundation.dart';
import '../models/todo.dart';
import '../service/todo_service.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  String _currentFilter = 'all';
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Todo> get todos => _todos;
  String get currentFilter => _currentFilter;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get totalTodos => _todos.length;
  int get completedTodos => _todos.where((todo) => todo.isCompleted).length;
  int get pendingTodos => totalTodos - completedTodos;

  List<Todo> get completedTodosList =>
      _todos.where((todo) => todo.isCompleted).toList();
  List<Todo> get pendingTodosList =>
      _todos.where((todo) => !todo.isCompleted).toList();

  // Get filtered todos based on current filter
  List<Todo> get filteredTodos {
    List<Todo> filteredList = List.from(_todos);

    switch (_currentFilter) {
      case 'createdAt_asc':
        filteredList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'createdAt_desc':
        filteredList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'priority':
        filteredList.sort((a, b) => a.priority.compareTo(b.priority));
        break;
      case 'completed':
        filteredList.sort((a, b) => b.isCompleted ? 1 : -1);
        break;
      default:
        break;
    }

    return filteredList;
  }

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
        'title': title,
        'description': description,
        'priority': priority,
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
        'title': title,
        'description': description,
        'priority': priority,
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
        'title': todo.title,
        'description': todo.description,
        'priority': todo.priority,
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

  // Set filter
  void setFilter(String filter) {
    _currentFilter = filter;
    notifyListeners();
  }
}
