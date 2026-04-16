import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import 'add_task_sheet.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  static const _accent = Color(0xFFE91E8C);

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      background: _swipeBackground(
        alignment: Alignment.centerLeft,
        color: const Color(0xFF00BFA5),
        icon: Icons.edit_rounded,
        label: 'Edit',
      ),
      secondaryBackground: _swipeBackground(
        alignment: Alignment.centerRight,
        color: Colors.redAccent,
        icon: Icons.delete_rounded,
        label: 'Delete',
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => AddTaskSheet(task: task),
          );
          return false;
        } else {
          return await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: const Color(0xFF1A1A2E),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  title: Text('Delete Task',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                  content: Text(
                      'Are you sure you want to delete this task?',
                      style:
                          GoogleFonts.poppins(color: Colors.white60)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text('Cancel',
                          style: GoogleFonts.poppins(
                              color: Colors.white38)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text('Delete',
                          style: GoogleFonts.poppins(
                              color: Colors.redAccent)),
                    ),
                  ],
                ),
              ) ??
              false;
        }
      },
      onDismissed: (_) =>
          context.read<TaskProvider>().deleteTask(task.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () =>
                  context.read<TaskProvider>().toggleTask(task.id),
              child: Container(
                margin: const EdgeInsets.only(top: 2),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        task.isCompleted ? _accent : Colors.white30,
                    width: 2,
                  ),
                  color: task.isCompleted
                      ? _accent.withOpacity(0.15)
                      : Colors.transparent,
                ),
                child: task.isCompleted
                    ? const Icon(Icons.check_rounded,
                        size: 14, color: _accent)
                    : null,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: task.isCompleted
                          ? Colors.white38
                          : Colors.white,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      decorationColor: Colors.white38,
                    ),
                  ),
                  if (task.note.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      task.note,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.white38),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _swipeBackground({
    required AlignmentGeometry alignment,
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: alignment == Alignment.centerLeft
            ? [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 6),
                Text(label,
                    style: GoogleFonts.poppins(
                        color: color, fontSize: 13)),
              ]
            : [
                Text(label,
                    style: GoogleFonts.poppins(
                        color: color, fontSize: 13)),
                const SizedBox(width: 6),
                Icon(icon, color: color, size: 20),
              ],
      ),
    );
  }
}
