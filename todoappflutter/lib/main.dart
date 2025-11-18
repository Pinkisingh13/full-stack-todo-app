import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/todo_provider.dart';
import 'widgets/todo_form.dart';
import 'widgets/todo_item.dart';
import 'widgets/summary_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: MaterialApp(
        title: 'Beautiful Todo App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            brightness: Brightness.light,
          ),
          fontFamily: 'Roboto',
        ),
        home: const TodoHomePage(),
      ),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fabAnimationController;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Fetch todos when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoProvider>(context, listen: false).fetchTodos();
    });
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _showAddTodoForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TodoForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6366F1),
              Color(0xFFF3F4F6),
            ],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildTodoList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Todos',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Consumer<TodoProvider>(
                builder: (context, todoProvider, child) {
                  return IconButton(
                    onPressed: todoProvider.isLoading
                        ? null
                        : () => todoProvider.fetchTodos(),
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 28,
                    ),
                    tooltip: 'Refresh todos',
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Consumer<TodoProvider>(
            builder: (context, todoProvider, child) {
              return Text(
                '${todoProvider.totalTodos} tasks to manage',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          _buildSummaryButton(),
        ],
      ),
    );
  }

  Widget _buildSummaryButton() {

  
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          return ElevatedButton.icon(
            onPressed: todoProvider.isLoading
                ? null
                : () async {
                    await todoProvider.summarize();
                    if (context.mounted) {
                      SummaryDialog.show(context);
                    }
                  },
            icon: todoProvider.isLoading ? null : const Icon(Icons.analytics_outlined, size: 24, color: Colors.white,),
            label:  todoProvider.isLoading ? CircularProgressIndicator(color: Colors.white,) : const Text(
              'View Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTodoList() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF3F4F6),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          // Show loading indicator
          if (todoProvider.isLoading && todoProvider.todos.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6366F1),
              ),
            );
          }

          // Show error message
          if (todoProvider.errorMessage != null && todoProvider.todos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Error loading todos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      todoProvider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => todoProvider.fetchTodos(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Show empty state
          if (todoProvider.todos.isEmpty) {
            return _buildEmptyState();
          }

          // Show todos list
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: todoProvider.todos.length,
            itemBuilder: (context, index) {
              final todo = todoProvider.todos[index];
              return TodoItem(todo: todo);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          Text(
            'No todos yet!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tap the + button to add your first task',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
          parent: _fabAnimationController,
          curve: Curves.easeInOut,
        ),
      ),
      child: FloatingActionButton.extended(
        onPressed: () {
          _fabAnimationController.forward().then((_) {
            _fabAnimationController.reverse();
          });
          _showAddTodoForm();
        },
        backgroundColor: const Color(0xFF6366F1),
        icon: const Icon(Icons.add, size: 28),
        label: const Text(
          'Add Todo',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        elevation: 8,
      ),
    );
  }
}




// X2932