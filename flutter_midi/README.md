[![Buy Me A Coffee](https://img.shields.io/badge/Donate-Buy%20Me%20A%20Coffee-yellow.svg)](https://www.buymeacoffee.com/rodydavis)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=WSH3GVC49GNNJ)
![github pages](https://github.com/rodydavis/flutter_midi/workflows/github%20pages/badge.svg)
[![GitHub stars](https://img.shields.io/github/stars/rodydavis/flutter_midi?color=blue)](https://github.com/rodydavis/flutter_midi)
[![flutter_midi](https://img.shields.io/pub/v/flutter_midi.svg)](https://pub.dev/packages/flutter_midi)

# flutter_midi

A FLutter Plugin to Play midi on iOS and Android. This uses SoundFont (.sf2) Files.

Online Demo: https://rodydavis.github.io/flutter_midi/

## Installation

Download a any sound font file, example: `sound_font.SF2` file.

Create an /assets folder and store the .sf2 files

Update pubspec.yaml

``` ruby
assets:
   - assets/sf2/Piano.SF2
   - assets/sf2/SmallTimGM6mb.sf2
```
 
Load the sound font to prepare to play;

```dart
 @override
  void initState() {
    load('assets/sf2/Piano.SF2');
    super.initState();
  }
  
 void load(String asset) async {
    FlutterMidi.unmute(); // Optionally Unmute
    ByteData _byte = await rootBundle.load(asset);
    FlutterMidi.prepare(sf2: _byte);
  }
```

Play and Stop the Midi Notes

```dart
 FlutterMidi.playMidiNote(midi: 60);

 FlutterMidi.stopMidiNote(midi: 60);
```
