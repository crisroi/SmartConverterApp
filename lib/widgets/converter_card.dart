import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ConverterCard extends StatelessWidget {
  final String inputValue;
  final String resultValue;
  final String fromLabel;
  final String toLabel;
  final Widget fromDropdown;
  final Widget toDropdown;
  final Function(String) onInputChanged;
  final VoidCallback onSwap;
  final Color accentColor;

  const ConverterCard({
    super.key,
    required this.inputValue,
    required this.resultValue,
    required this.fromLabel,
    required this.toLabel,
    required this.fromDropdown,
    required this.toDropdown,
    required this.onInputChanged,
    required this.onSwap,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.07),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // FROM section
          _SectionBlock(
            label: 'FROM',
            accentColor: accentColor,
            dropdown: fromDropdown,
            child: _InputField(
              value: inputValue,
              onChanged: onInputChanged,
              accentColor: accentColor,
            ),
          ),

          // Swap button divider
          _SwapDivider(onSwap: onSwap, accentColor: accentColor),

          // TO section
          _SectionBlock(
            label: 'TO',
            accentColor: accentColor,
            dropdown: toDropdown,
            child: _ResultDisplay(
              value: resultValue,
              accentColor: accentColor,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  final String label;
  final Color accentColor;
  final Widget dropdown;
  final Widget child;

  const _SectionBlock({
    required this.label,
    required this.accentColor,
    required this.dropdown,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: accentColor,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          dropdown,
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InputField extends StatefulWidget {
  final String value;
  final Function(String) onChanged;
  final Color accentColor;

  const _InputField({
    required this.value,
    required this.onChanged,
    required this.accentColor,
  });

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  late TextEditingController _controller;
  late FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focus = FocusNode();
  }

  @override
  void didUpdateWidget(_InputField old) {
    super.didUpdateWidget(old);
    // Only update if not focused to avoid cursor jumping
    if (!_focus.hasFocus && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextField(
      controller: _controller,
      focusNode: _focus,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      style: GoogleFonts.spaceGrotesk(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: cs.onSurface,
      ),
      decoration: InputDecoration(
        hintText: '0',
        hintStyle: GoogleFonts.spaceGrotesk(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: cs.onSurface.withOpacity(0.2),
        ),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear_rounded, size: 18),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged('');
                },
              )
            : null,
      ),
      onChanged: widget.onChanged,
    );
  }
}

class _ResultDisplay extends StatelessWidget {
  final String value;
  final Color accentColor;

  const _ResultDisplay({required this.value, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onLongPress: () {
        if (value.isNotEmpty && value != '—') {
          Clipboard.setData(ClipboardData(text: value));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$value copied to clipboard'),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accentColor.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value.isEmpty ? '—' : value,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: value.isEmpty
                      ? cs.onSurface.withOpacity(0.2)
                      : accentColor,
                ),
              ),
            ),
            if (value.isNotEmpty && value != '—')
              Icon(
                Icons.copy_rounded,
                size: 16,
                color: accentColor.withOpacity(0.5),
              ),
          ],
        ),
      ),
    );
  }
}

class _SwapDivider extends StatelessWidget {
  final VoidCallback onSwap;
  final Color accentColor;

  const _SwapDivider({required this.onSwap, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.white.withOpacity(0.07),
              indent: 20,
              endIndent: 8,
            ),
          ),
          GestureDetector(
            onTap: onSwap,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: accentColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.swap_vert_rounded,
                color: accentColor,
                size: 20,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.white.withOpacity(0.07),
              indent: 8,
              endIndent: 20,
            ),
          ),
        ],
      ),
    );
  }
}
