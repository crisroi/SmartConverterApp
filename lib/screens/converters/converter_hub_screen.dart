import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'currency_screen.dart';
import 'weight_screen.dart';
import 'length_screen.dart';

class ConverterHubScreen extends StatelessWidget {
  const ConverterHubScreen({super.key});

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
          'Converters',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a converter',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white38),
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 28),
            _ConverterCard(
              icon: Icons.currency_exchange_rounded,
              label: 'Currency',
              subtitle: 'Live exchange rates',
              accent: const Color(0xFF00BFA5),
              delay: 150,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CurrencyScreen())),
            ),
            const SizedBox(height: 16),
            _ConverterCard(
              icon: Icons.monitor_weight_outlined,
              label: 'Weight',
              subtitle: 'kg, lb, g, oz and more',
              accent: const Color(0xFF7C4DFF),
              delay: 250,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const WeightScreen())),
            ),
            const SizedBox(height: 16),
            _ConverterCard(
              icon: Icons.straighten_rounded,
              label: 'Length',
              subtitle: 'm, ft, cm, in and more',
              accent: const Color(0xFFFFB300),
              delay: 350,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const LengthScreen())),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConverterCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color accent;
  final int delay;
  final VoidCallback onTap;

  const _ConverterCard({
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
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent.withOpacity(0.25), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: accent, size: 28),
            ),
            const SizedBox(width: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.white38)),
              ],
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded,
                color: accent.withOpacity(0.6), size: 16),
          ],
        ),
      ),
    ).animate()
        .fadeIn(duration: 350.ms, delay: Duration(milliseconds: delay))
        .slideY(begin: 0.12);
  }
}
