import 'dart:ui';

/// Commenting out since it is already defined from Flutter
/// as `toARGB32()`
/// 
// extension ColorX on Color {
//   int get intAlpha => _floatToInt8(a);
//   int get intRed => _floatToInt8(r);
//   int get intGreen => _floatToInt8(g);
//   int get intBlue => _floatToInt8(b);

//   int _floatToInt8(double x) => (x * 255.0).round() & 0xff;

//   int get argb {
//     return _floatToInt8(a) << 24 |
//         _floatToInt8(r) << 16 |
//         _floatToInt8(g) << 8 |
//         _floatToInt8(b) << 0;
//   }
// }

extension IntX on int {
  Color get toColor {
    return Color.fromARGB(
      (this >> 24) & 0xFF, // Alpha
      (this >> 16) & 0xFF, // Red
      (this >> 8) & 0xFF, // Green
      this & 0xFF, // Blue
    );
  }
}
