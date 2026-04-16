import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'converters/converter_hub_screen.dart';
import 'tasks/tasks_hub_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Smart Utility',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),
              Text(
                'Toolkit',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white54,
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideX(begin: -0.2),
              const SizedBox(height: 8),
              Text(
                'What would you like to do today?',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white38,
                ),
              ).animate().fadeIn(delay: 200.ms),
              const Spacer(),
              _HomeCard(
                icon: Icons.swap_horiz_rounded,
                label: 'Converters',
                subtitle: 'Currency · Weight · Length',
                accent: const Color(0xFF00BFA5),
                delay: 300,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ConverterHubScreen()),
                ),
              ),
              const SizedBox(height: 20),
              _HomeCard(
                icon: Icons.checklist_rounded,
                label: 'Tasks',
                subtitle: 'Active · Completed',
                accent: const Color(0xFFE91E8C),
                delay: 450,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TasksHubScreen()),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color accent;
  final int delay;
  final VoidCallback onTap;

  const _HomeCard({
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
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: accent.withOpacity(0.25), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.10),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: accent, size: 36),
            ),
            const SizedBox(width: 22),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded,
                color: accent.withOpacity(0.6), size: 20),
          ],
        ),
      ),
    ).animate()
        .fadeIn(duration: 400.ms, delay: Duration(milliseconds: delay))
        .slideY(begin: 0.15);
  }
}