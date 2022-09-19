import 'dart:math';
import 'dart:typed_data';

import 'package:wav/src/byte_padding.dart';
import 'package:wav/src/wav_header.dart';
import 'package:wav/src/wav_metadata.dart';

/// A waveform audio object.
class Wav {
  /// Creates a new [Wav].
  Wav({
    required this.metadata,
    required this.channelData,
  });

  /// The number of bits to use for the data.
  static const bits = 16;

  /// The metadata for this file.
  final WavMetadata metadata;

  /// A list of data for each audio channel.
  final List<Float64List> channelData;

  int _percentToInt(double percent) {
    final maxValue = pow(2, bits);
    final adjValue = (percent * (maxValue / 2 - 1)).floor();
    final foldedValue = adjValue % maxValue;
    return foldedValue.toInt();
  }

  Uint8List _dataToBytes() {
    final buffer = BytesBuilder();

    for (var sample = 0; sample < metadata.numberOfSamples; sample++) {
      for (final channel in channelData) {
        if (sample < channel.length) {
          final byte = _percentToInt(channel[sample]);
          buffer.add(u16(byte));
        } else {
          buffer.addByte(0);
        }
      }
    }

    // Make the chunk size even.
    if (buffer.length.isOdd) buffer.addByte(0);

    return buffer.takeBytes();
  }

  /// Returns a byte representation for this Wav file.
  Uint8List toBytes() {
    final buffer = BytesBuilder();

    final header = WavHeader(metadata);
    final headerBytes = header.toBytes();
    final dataBytes = _dataToBytes();

    buffer
      ..add(headerBytes)
      ..add(dataBytes);

    return buffer.takeBytes();
  }
}
