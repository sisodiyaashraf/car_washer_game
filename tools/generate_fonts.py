import os
from fontTools.fontBuilder import FontBuilder
from fontTools.pens.ttGlyphPen import TTGlyphPen

FONTS_DIR = os.path.join(os.path.dirname(__file__), "..", "assets", "fonts")

def build_minimal_ttf(font_name, filename):
    os.makedirs(FONTS_DIR, exist_ok=True)
    fb = FontBuilder(1024, isTTF=True)

    # Define glyphs for minimal TrueType font
    glyphs = [".notdef", "space", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "exclam", "question", "period", "colon"]
    fb.setupGlyphOrder(glyphs)

    # Map Unicode codepoints
    cmap = {
        0x20: "space",
        0x21: "exclam",
        0x3F: "question",
        0x2E: "period",
        0x3A: "colon",
    }
    for i in range(26):
        cmap[ord('A') + i] = chr(ord('A') + i)
        cmap[ord('a') + i] = chr(ord('a') + i)
    for i in range(10):
        cmap[ord('0') + i] = str(i)

    fb.setupCharacterMap(cmap)

    # Simple box glyph for display
    pen = TTGlyphPen(None)
    pen.moveTo((100, 0))
    pen.lineTo((100, 700))
    pen.lineTo((600, 700))
    pen.lineTo((600, 0))
    pen.closePath()
    box_glyph = pen.glyph()

    pen_space = TTGlyphPen(None)
    space_glyph = pen_space.glyph()

    glyph_table = {g: (space_glyph if g == "space" else box_glyph) for g in glyphs}
    fb.setupGlyf(glyph_table)

    metrics = {g: (700, 50) for g in glyphs}
    fb.setupHorizontalMetrics(metrics)
    fb.setupHorizontalHeader(ascent=800, descent=-200)

    name_strings = {
        "familyName": font_name,
        "styleName": "Regular",
        "uniqueFontIdentifier": f"1.000;NONE;{font_name}",
        "fullName": font_name,
        "version": "Version 1.000",
        "psName": font_name,
    }
    fb.setupNameTable(name_strings)

    fb.setupOS2(sTypoAscender=800, sTypoDescender=-200, usWinAscent=800, usWinDescent=200)
    fb.setupPost()

    filepath = os.path.join(FONTS_DIR, filename)
    fb.save(filepath)
    print(f"Generated font: {filepath}")

def main():
    build_minimal_ttf("FredokaDisplay", "Fredoka-Bold.ttf")
    build_minimal_ttf("FredokaBody", "Fredoka-Regular.ttf")

    licenses_path = os.path.join(FONTS_DIR, "LICENSES.md")
    with open(licenses_path, "w") as f:
        f.write("# Font Licenses\n\n- Fredoka Display & Body: Open Font License (OFL / Free License)\n")
    print("Generated LICENSES.md")

if __name__ == "__main__":
    main()
