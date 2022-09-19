# wav

A package for creating waveform audio.

Inspired by [this package](https://github.com/liamappelbe/wav/).

# Usage

```dart
import 'package:wav/wav.dart';

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
```
