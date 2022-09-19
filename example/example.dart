import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:wav/wav.dart';

void main() {
  const frequency = 400;
  const seconds = 5;
  const sampleRate = 44100;
  const samplesPerCycle = sampleRate / frequency;
  const totalSamples = seconds * sampleRate;

  final data = List.generate(totalSamples, (sample) {
    final tone = sin(sample / samplesPerCycle * 2 * pi);
    return tone;
  });

  final wav = Wav(
    metadata: WavMetadata(
      numberOfSamples: data.length,
      numberOfChannels: 1,
    ),
    channelData: [
      Float64List.fromList(data),
    ],
  );

  final wavBytes = wav.toBytes();

  File('test_wav.wav').writeAsBytesSync(wavBytes, mode: FileMode.writeOnly);
}
