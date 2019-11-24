import mihxi.*;

import haxe.io.Bytes;
import sys.io.File;
import haxe.io.UInt8Array;

class Example {
	static function main() {
		// Use this to set the note at the same start as the previous note //
		var isHarmony = true;
		var octave = 6;

		// Can instance with initial args if desired like below //
		/* Available args:
		 *    note: case-insensitive note name, or r for rest
		 *    length: w(hole) h(alf) e(ighth) s(ixteenth) t(riplet)
		 *    octave: int octave for note
		 *    velocity: percent velocity/attack
		 *    isHarmony: if should be played as harmony/chord with last note
		 **/
		var midTrk = new MidiNoteData('C', 'q', octave);
		midTrk.add('E','q', octave, isHarmony);
		midTrk.add('R','q');
		midTrk.add('F','e', octave);
		midTrk.add('b','e', octave, isHarmony);
		midTrk.add('g','e', octave,isHarmony);

		// A cheap workaround to get the MIDI file's Bytes to write from the int array //
		var midiFile = new MidiData();
		var midiData = midiFile.createMidiFile(midTrk);
		var midBytes = UInt8Array.fromArray(midiData).view.buffer;

		trace(midiData, midBytes.toHex());
		File.saveBytes('prg.mid', midBytes); 
	}
}
