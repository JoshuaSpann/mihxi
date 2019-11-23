import mihxi.*;

import haxe.io.Bytes;
import sys.io.File;
import haxe.io.UInt8Array;

class Midi {
	static function main() {
		var midTrk = new MidiNoteData('C', 'q', 6);
		midTrk.add('R','q');
		midTrk.add('G#','q', 6);
		midTrk.add('r','s');
		midTrk.add('A','q', 5);
		var midiData = MidiData.createMidiFile(midTrk);
		var midBytes = UInt8Array.fromArray(midiData).view.buffer;
		trace(midiData, midBytes.toHex());
		File.saveBytes('prg.mid', midBytes); 
	}
}
