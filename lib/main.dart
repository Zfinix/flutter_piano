import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piano/piano.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      title: 'Flutter Piano',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.notoSansTextTheme(textTheme),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _flutterMidi = FlutterMidi();

  void load(String asset) async {
    print('Loading File...');
    _flutterMidi.unmute();
    ByteData byte = await rootBundle.load(asset);
    _flutterMidi.prepare(sf2: byte, name: 'grand_piano.sf2');
  }

  final FocusNode _focusNode = FocusNode();
// The message to display.
  String? _message;

// Focus nodes need to be disposed.
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

// Handles the key events from the RawKeyboardListener and update the
// _message.
  void _handleKeyEvent(RawKeyEvent event) {
    print(event.logicalKey.keyId);

    onNotePositionTapped(event.logicalKey.keyId - 13);
  }

  @override
  void initState() {
    load('assets/sf/grand_piano.sf2');
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: _handleKeyEvent,
        child: ListView(
          children: [
            const Gap(100),
            /* ClefImage(
              clef: Clef.Treble,
              clefColor: Colors.white,
              noteColor: Colors.white,
              noteImages: playedNotes
                  .map(
                    (it) => NoteImage(
                      notePosition: it,
                    ),
                  )
                  .toList(),
              noteRange: NoteRange.forClefs([
                Clef.Treble,
              ]),
              size: const Size(double.infinity, 130),
            ),
            ClefImage(
              clef: Clef.Bass,
              clefColor: Colors.white,
              noteColor: Colors.white,
              noteImages: playedNotes
                  .map(
                    (it) => NoteImage(
                      notePosition: it,
                    ),
                  )
                  .toList(),
              noteRange: NoteRange.forClefs([
                Clef.Bass,
              ]),
              size: const Size(double.infinity, 130),
            ), */
            SizedBox(
              height: 500,
              child: InteractivePiano(
                highlightedNotes: [NotePosition(note: Note.C, octave: 4)],
                naturalColor: Colors.white,
                accidentalColor: Colors.black,
                keyWidth: 50,
                noteRange: NoteRange.forClefs([
                  Clef.Treble,
                  Clef.Alto,
                  Clef.Bass,
                ]),
                onNotePositionTapped: (pos) => onNotePositionTapped(pos.pitch),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onNotePositionTapped(int pitch) async {
    _flutterMidi.playMidiNote(midi: pitch);

    Future.delayed(const Duration(seconds: 3)).then(
      (value) => setState(() {
        _flutterMidi.stopMidiNote(midi: pitch);
      }),
    );
  }
}
