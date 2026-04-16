import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/task_provider.dart';
import '../../widgets/task_card.dart';
import '../../widgets/add_task_sheet.dart';

class ActiveTasksScreen extends StatelessWidget {
  const ActiveTasksScreen({super.key});

  static const _accent = Color(0xFFE91E8C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Active Tasks',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: const [
          IconButton(icon: Icon(Icons.info_outline,), onPressed: null, tooltip: "Swipe left to edit task, swipe right to delete task",)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _accent,
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const AddTaskSheet(),
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, _) {
          final tasks = provider.activeTasks;
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt_rounded,
                      size: 64, color: _accent.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text('No active tasks',
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white38)),
                  const SizedBox(height: 8),
                  Text('Tap + to add a new task',
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: Colors.white24)),
                ],
              ).animate().fadeIn(duration: 400.ms),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
            itemCount: tasks.length,
            itemBuilder: (_, i) => TaskCard(task: tasks[i])
                .animate()
                .fadeIn(
                    duration: 300.ms,
                    delay: Duration(milliseconds: i * 60))
                .slideY(begin: 0.1),
          );
        },
      ),
    );
  }
}
