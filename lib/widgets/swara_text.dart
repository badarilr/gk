import 'package:flutter/material.dart';

/// Notation convention used in raagbook.json:
///   upper octave  -> letter followed by an apostrophe, e.g. S'
///   lower octave   -> letter preceded by a comma, e.g. ,N
///   middle octave  -> plain letter, e.g. S
///   sustain        -> one or more hyphens, e.g. -- or ---
///   a "group" is a run of swaras with no space between them (e.g. "PN" = P then N)
///   groups within a cell are separated by spaces
enum SwaraOctave { lower, middle, upper }

class SwaraGlyph {
  final String letter; // one of S R G M P D N, or '-' for a sustain beat
  final SwaraOctave octave;
  SwaraGlyph(this.letter, this.octave);
}

List<List<SwaraGlyph>> parseSwaraCell(String cell) {
  final groups = cell.trim().isEmpty ? <String>[] : cell.trim().split(RegExp(r'\s+'));
  return groups.map(_parseGroup).toList();
}

List<SwaraGlyph> _parseGroup(String group) {
  final glyphs = <SwaraGlyph>[];
  var i = 0;
  while (i < group.length) {
    final ch = group[i];

    if (ch == '-') {
      glyphs.add(SwaraGlyph('-', SwaraOctave.middle));
      i++;
      continue;
    }

    if (ch == ',') {
      if (i + 1 < group.length) {
        glyphs.add(SwaraGlyph(group[i + 1], SwaraOctave.lower));
        i += 2;
      } else {
        i++; // stray comma, skip
      }
      continue;
    }

    // plain letter, check for a trailing apostrophe marking upper octave
    var octave = SwaraOctave.middle;
    final letter = ch;
    i++;
    if (i < group.length && group[i] == "'") {
      octave = SwaraOctave.upper;
      i++;
    }
    glyphs.add(SwaraGlyph(letter, octave));
  }
  return glyphs;
}

/// Renders one grid cell's swara notation with dot-above (upper octave)
/// and underline (lower octave) marks, matching the book's own convention.
class SwaraCellText extends StatelessWidget {
  final String cell;
  final TextStyle? style;

  const SwaraCellText(this.cell, {this.style, super.key});

  @override
  Widget build(BuildContext context) {
    final baseStyle = (style ?? DefaultTextStyle.of(context).style).copyWith(
      fontFamily: 'RobotoMono',
      fontSize: (style?.fontSize ?? 14) + 1,
      height: 1.3,
      color: const Color(0xFF1F2937),
    );
    final groups = parseSwaraCell(cell);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: groups.map((glyphs) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: glyphs
                .map((g) => Padding(
                      padding: const EdgeInsets.only(right: 1),
                      child: _SwaraGlyphWidget(glyph: g, style: baseStyle),
                    ))
                .toList(),
          );
        }).toList(),
      ),
    );
  }
}

class _SwaraGlyphWidget extends StatelessWidget {
  final SwaraGlyph glyph;
  final TextStyle style;

  const _SwaraGlyphWidget({required this.glyph, required this.style});

  @override
  Widget build(BuildContext context) {
    if (glyph.letter == '-') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Text('—', style: style.copyWith(color: Colors.deepPurpleAccent)),
      );
    }

    if (glyph.octave == SwaraOctave.lower) {
      return Text(
        glyph.letter,
        style: style.copyWith(
          decoration: TextDecoration.underline,
          decorationThickness: 2,
          decorationColor: Colors.indigoAccent,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    if (glyph.octave == SwaraOctave.upper) {
      final fontSize = style.fontSize ?? 14;
      return SizedBox(
        height: fontSize + 10,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              bottom: fontSize + 3,
              child: Container(
                width: fontSize * 0.20,
                height: fontSize * 0.20,
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Text(
              glyph.letter,
              style: style.copyWith(
                color: Colors.deepPurple,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      );
    }

    return Text(
      glyph.letter,
      style: style.copyWith(
        color: const Color(0xFF0F172A),
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
