# mihxi
A Haxe library that writes MIDI data.

## Functionality

- Currently writes type-1 MIDI files.
- Can write notes from all available octaves.
- Can declare whole, half, quarter, eighth, and sixteenth notes/rests.
- Triplets are currently limited to quarter-note lengths.
- Uses a high-level, programmatic implementation to declare note data that can be converted on the fly to raw MIDI byte note values.
- The resulting `prg.mid` file (created by [`Example.hx`](Example.hx)) can import to MuseScore3 and FLStudio.

## How-to

Mihxi is a package that you can include with your project.
There are 3 classes of the API exposed:
- `MidiData`: A static utility class used to create a (currently) type-1 MIDI file
- `MidiNoteData`: A class that is meant to parse high-level note representation to MIDI data
- `MidiNoteLookup`: A class that is used to look up MIDI note values from the high-level representation

A basic example showcasing its usage is in [`Example.hx`](Example.hx):
```Haxe
import mihxi.*;

import haxe.io.Bytes;
import sys.io.File;
import haxe.io.UInt8Array;

class Example {
	static function main() {
		// Can instance with initial args if desired like below //
		var midTrk = new MidiNoteData('C', 'q', 6);
		midTrk.add('R','q');
		midTrk.add('G#','q', 6);
		midTrk.add('r','s');
		midTrk.add('A','q', 5);

		// A cheap workaround to get the MIDI file's Bytes to write from the int array //
		var midiData = MidiData.createMidiFile(midTrk);
		var midBytes = UInt8Array.fromArray(midiData).view.buffer;

		trace(midiData, midBytes.toHex());
		File.saveBytes('prg.mid', midBytes); 
	}
}
```

The core library files are under the [`mihxi/`](mihxi/) project directory.
