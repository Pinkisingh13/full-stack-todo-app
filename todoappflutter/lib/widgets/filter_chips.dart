import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';

class FilterChips extends StatelessWidget {
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip(
                context,
                'All',
                'all',
                Icons.list,
                todoProvider.currentFilter,
                todoProvider.setFilter,
              ),
              const SizedBox(width: 10),
              _buildFilterChip(
                context,
                'Newest',
                'createdAt_desc',
                Icons.arrow_downward,
                todoProvider.currentFilter,
                todoProvider.setFilter,
              ),
              const SizedBox(width: 10),
              _buildFilterChip(
                context,
                'Oldest',
                'createdAt_asc',
                Icons.arrow_upward,
                todoProvider.currentFilter,
                todoProvider.setFilter,
              ),
              const SizedBox(width: 10),
              _buildFilterChip(
                context,
                'Priority',
                'priority',
                Icons.flag,
                todoProvider.currentFilter,
                todoProvider.setFilter,
              ),
              const SizedBox(width: 10),
              _buildFilterChip(
                context,
                'Completed',
                'completed',
                Icons.check_circle,
                todoProvider.currentFilter,
                todoProvider.setFilter,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    String filterValue,
    IconData icon,
    String currentFilter,
    Function(String) onFilterChanged,
  ) {
    final isSelected = currentFilter == filterValue;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : const Color(0xFF6366F1),
          ),
          const SizedBox(width: 5),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        onFilterChanged(filterValue);
      },
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFF6366F1),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF6366F1),
        fontWeight: FontWeight.bold,
      ),
      elevation: 2,
      shadowColor: Colors.black26,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
