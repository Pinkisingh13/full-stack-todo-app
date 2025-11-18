import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';

class SummaryDialog extends StatelessWidget {
  const SummaryDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const SummaryDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6366F1),
                  Color(0xFF8B5CF6),
                  Color(0xFFA855F7),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Todo Summary',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        'Total',
                        todoProvider.totalTodos.toString(),
                        Icons.list_alt,
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      _buildStatCard(
                        'Completed',
                        todoProvider.completedTodos.toString(),
                        Icons.check_circle,
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      _buildStatCard(
                        'Pending',
                        todoProvider.pendingTodos.toString(),
                        Icons.pending,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  constraints: const BoxConstraints(maxHeight: 400),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (todoProvider.completedTodosList.isNotEmpty) ...[
                          Row(
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.green[600], size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Completed Tasks',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ...todoProvider.completedTodosList.map(
                            (todo) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ',
                                      style: TextStyle(fontSize: 16)),
                                  Expanded(
                                    child: Text(
                                      todo.title,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        if (todoProvider.pendingTodosList.isNotEmpty) ...[
                          Row(
                            children: [
                              Icon(Icons.pending_actions,
                                  color: Colors.orange[600], size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Pending Tasks',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ...todoProvider.pendingTodosList.map(
                            (todo) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ',
                                      style: TextStyle(fontSize: 16)),
                                  Expanded(
                                    child: Text(
                                      todo.title,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        if (todoProvider.totalTodos == 0)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'No todos yet! Start adding some tasks.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
