import 'dart:typed_data';

import 'package:wav/src/byte_padding.dart';
import 'package:wav/wav.dart';

/// A class containing the metadata of a waveform audio file.
class WavHeader {
  /// Creates a mew [WavHeader] given some [metadata].
  WavHeader(this.metadata);

  /// The number of bytes needed to represent the RIFF marker.
  static const int riffMarkerBytes = 4;

  /// The number of bytes needed to represent the overall file size in bytes.
  static const int fileSizeBytes = 4;

  /// The number of bytes needed to represent the WAVE marker.
  static const int waveMarkerBytes = 4;

  /// The number of bytes needed to represent the format marker.
  static const int formatMarkerBytes = 4;

  /// The number of bytes needed to represent the format length.
  static const int formatLengthBytes = 4;

  /// The number of bytes needed to represent the format type.
  static const int formatTypeBytes = 2;

  /// The number of bytes needed to represent the number of channels.
  static const int numberOfChannelsBytes = 2;

  /// The number of bytes needed to represent the sample rate.
  static const int sampleRateBytes = 4;

  /// The number of bytes needed to represent the number of bytes per second.
  static const int bytesPerSecondBytes = 4;

  /// The number of bytes needed to represent the block alignment.
  static const int blockAlignmentBytes = 2;

  /// The number of bytes needed to represent number of bits per sample.
  static const int bitsPerSampleBytes = 2;

  /// The number of bytes needed to represent the data marker.
  static const int dataMarkerBytes = 4;

  /// The number of bytes needed to represent the data size.
  static const int dataSizeBytes = 4;

  /// The number of bytes needed to represent the entire header.
  static const int totalHeaderSizeBytes = riffMarkerBytes +
      fileSizeBytes +
      waveMarkerBytes +
      formatMarkerBytes +
      formatLengthBytes +
      formatTypeBytes +
      numberOfChannelsBytes +
      sampleRateBytes +
      bytesPerSecondBytes +
      blockAlignmentBytes +
      bitsPerSampleBytes +
      dataMarkerBytes +
      dataSizeBytes;

  /// The metadata for this file.
  final WavMetadata metadata;

  /// Returns the byte representation of this wave file header.
  Uint8List toBytes() {
    final buffer = BytesBuilder();

    const bytesPerSample = Wav.bits ~/ 8;
    final bytesPerSampleTotal = bytesPerSample * metadata.numberOfChannels;
    final dataSize = metadata.numberOfSamples * bytesPerSampleTotal;
    final bytesPerSecond = bytesPerSampleTotal * metadata.sampleRate;
    final bytesPerSecondEven =
        bytesPerSecond.isEven ? bytesPerSecond : bytesPerSecond + 1;
    final fileSize =
        (totalHeaderSizeBytes - riffMarkerBytes - formatLengthBytes) + dataSize;

    buffer
      ..add('RIFF'.codeUnits)
      ..add(u32(fileSize))
      ..add('WAVE'.codeUnits)
      ..add('fmt '.codeUnits)
      ..add(u32(16))
      ..add(u16(1))
      ..add(u16(metadata.numberOfChannels))
      ..add(u32(metadata.sampleRate))
      ..add(u32(bytesPerSecondEven))
      ..add(u16(bytesPerSampleTotal))
      ..add(u16(Wav.bits))
      ..add('data'.codeUnits)
      ..add(u32(dataSize));

    return buffer.takeBytes();
  }
}
