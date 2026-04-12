import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UnitDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final String Function(T)? subtitleBuilder;
  final void Function(T?) onChanged;
  final Color accentColor;

  const UnitDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.labelBuilder,
    this.subtitleBuilder,
    required this.onChanged,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        isExpanded: true,
        icon: Icon(Icons.keyboard_arrow_down_rounded,
            color: accentColor, size: 20),
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        dropdownColor: cs.surfaceContainerHighest,
        style: GoogleFonts.dmSans(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: cs.onSurface,
        ),
        selectedItemBuilder: (context) => items.map((item) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              labelBuilder(item),
              style: GoogleFonts.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        items: items.map((item) {
          final isSelected = item == value;
          return DropdownMenuItem<T>(
            value: item,
            child: Row(
              children: [
                if (isSelected)
                  Container(
                    width: 4,
                    height: 24,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  )
                else
                  const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        labelBuilder(item),
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? accentColor
                              : cs.onSurface,
                        ),
                      ),
                      if (subtitleBuilder != null)
                        Text(
                          subtitleBuilder!(item),
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: cs.onSurface.withOpacity(0.45),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
