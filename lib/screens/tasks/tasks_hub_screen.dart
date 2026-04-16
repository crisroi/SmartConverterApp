import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import 'active_tasks_screen.dart';
import 'completed_tasks_screen.dart';
import '../../widgets/add_task_sheet.dart';

class TasksHubScreen extends StatelessWidget {
  const TasksHubScreen({super.key});

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
          'Tasks',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Consumer<TaskProvider>(
          builder: (context, provider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage your tasks',
                  style:
                      GoogleFonts.poppins(fontSize: 14, color: Colors.white38),
                ).animate().fadeIn(delay: 100.ms),
                const SizedBox(height: 28),
                _TaskHubCard(
                  icon: Icons.radio_button_unchecked_rounded,
                  label: 'Active Tasks',
                  subtitle:
                      '${provider.activeTasks.length} task${provider.activeTasks.length == 1 ? '' : 's'} remaining',
                  accent: _accent,
                  delay: 150,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ActiveTasksScreen())),
                ),
                const SizedBox(height: 16),
                _TaskHubCard(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'Completed Tasks',
                  subtitle:
                      '${provider.completedTasks.length} task${provider.completedTasks.length == 1 ? '' : 's'} done',
                  accent: _accent,
                  delay: 250,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CompletedTasksScreen())),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TaskHubCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color accent;
  final int delay;
  final VoidCallback onTap;

  const _TaskHubCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.accent,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: accent.withOpacity(0.25), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.10),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: accent, size: 30),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.white38)),
              ],
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded,
                color: accent.withOpacity(0.6), size: 18),
          ],
        ),
      ),
    ).animate()
        .fadeIn(duration: 350.ms, delay: Duration(milliseconds: delay))
        .slideY(begin: 0.12);
  }
}
