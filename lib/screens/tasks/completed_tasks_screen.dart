import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/task_provider.dart';
import '../../widgets/task_card.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({super.key});

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
          'Completed Tasks',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
        actions: [
          Consumer<TaskProvider>(
            builder: (context, provider, _) {
              if (provider.completedTasks.isEmpty) return const SizedBox();
              return TextButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: const Color(0xFF1A1A2E),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    title: Text('Clear All',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                    content: Text(
                        'Delete all completed tasks? This cannot be undone.',
                        style:
                            GoogleFonts.poppins(color: Colors.white60)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text('Cancel',
                            style: GoogleFonts.poppins(
                                color: Colors.white38)),
                      ),
                      TextButton(
                        onPressed: () {
                          for (final t
                              in provider.completedTasks.toList()) {
                            provider.deleteTask(t.id);
                          }
                          Navigator.pop(ctx);
                        },
                        child: Text('Clear',
                            style: GoogleFonts.poppins(
                                color: Colors.redAccent)),
                      ),
                    ],
                  ),
                ),
                child: Text('Clear all',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: Colors.white38)),
              );
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, _) {
          final tasks = provider.completedTasks;
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hourglass_empty_rounded,
                      size: 64, color: _accent.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text('Nothing completed yet',
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white38)),
                  const SizedBox(height: 8),
                  Text('Complete tasks to see them here',
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: Colors.white24)),
                ],
              ).animate().fadeIn(duration: 400.ms),
            );
          }
          return ListView.builder(
            padding:
                const EdgeInsets.fromLTRB(24, 16, 24, 40),
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
