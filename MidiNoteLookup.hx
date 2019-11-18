//import haxe.ds.Map;

class MidiNoteLookup {
	static private var _noteMapping: Map<String,Int> = [
		'C'=>0x00, 'C#'=>0x01,
		'D'=>0x02, 'D#'=>0x03,
		'E'=>0x04,
		'F'=>0x05, 'F#'=>0x06,
		'G'=>0x07, 'G#'=>0x08,
		'A'=>0x09, 'A#'=>0x0a,
		'B'=>0x0b
	];

	public static function getNoteAsInt(note:String, octave:Int=0) {
		var octaveMult = octave;
		if (octave < 0) octaveMult = 0;

		var noteInt = _noteMapping[note];
		noteInt += octaveMult*12;
		return noteInt;
	}
}
