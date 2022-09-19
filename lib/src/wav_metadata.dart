/// The metadata of a waveform audio file.
class WavMetadata {
  /// Creates a new [WavMetadata].
  WavMetadata({
    this.sampleRate = 44100,
    this.numberOfChannels = 2,
    required this.numberOfSamples,
  });

  /// The sample rate in hertz.
  final int sampleRate;

  /// The number of audio channels.
  final int numberOfChannels;

  /// The maximum number of samples between all channels.
  final int numberOfSamples;
}
