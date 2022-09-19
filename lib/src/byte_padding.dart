import 'dart:typed_data';

/// Convert this value into an 8-bit byte array.
Uint8List u8(int value) {
  final byteData = ByteData(1)..setUint8(0, value);
  return byteData.buffer.asUint8List();
}

/// Convert this value into a 16-bit byte array.

Uint8List u16(int value) {
  final byteData = ByteData(2)..setUint16(0, value, Endian.little);
  return byteData.buffer.asUint8List();
}

/// Convert this value into a 32-bit byte array.
Uint8List u32(int value) {
  final byteData = ByteData(4)..setUint32(0, value, Endian.little);
  return byteData.buffer.asUint8List();
}
