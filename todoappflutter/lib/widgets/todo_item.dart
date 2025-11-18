import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import 'todo_form.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({super.key, required this.todo});

  void _showEditForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TodoForm(todo: todo),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);

    return Dismissible(
      key: Key(todo.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        todoProvider.deleteTodo(todo.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${todo.title} deleted'),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: GestureDetector(
            onTap: () => todoProvider.toggleTodo(todo.id),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: todo.isCompleted
                      ? const Color(0xFF6366F1)
                      : Colors.grey[300]!,
                  width: 2,
                ),
                color: todo.isCompleted
                    ? const Color(0xFF6366F1)
                    : Colors.transparent,
              ),
              child: todo.isCompleted
                  ? const Icon(
                      Icons.check,
                      size: 18,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
              color: todo.isCompleted ? Colors.grey : Colors.black,
            ),
          ),
          subtitle: todo.description.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    todo.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: todo.isCompleted ? Colors.grey : Colors.grey[600],
                      decoration:
                          todo.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : null,
          trailing: IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: Color(0xFF6366F1),
            ),
            onPressed: () => _showEditForm(context),
          ),
        ),
      ),
    );
  }
}
