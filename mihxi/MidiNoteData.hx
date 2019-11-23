package mihxi;

class MidiNoteData {
	var _noteTick:Int = 0x60;
	var _notes:Array<Map<String,Dynamic>> = [];
	var _notesRaw:Array<Array<Int>> = [[0x90,0x48,0x50,0x60, 0x80,0x48,0x50,0x60]];

	/**
	 * Declaraion is kind enough to allow new note data to be added
	 **/
	public inline function new(note:String=null, length:String='q', octave:Int=4, velocity:Int=90) {
		if (note == null) return;
		add(note,length,octave,velocity);
	}

	/**
	 * Adds a new high-level representation of a note to be played.
	 * Note is valid note name, length is 1-letter alias for note type,
	 *   velocity is percentage-based value.
	 **/
	public function add(note:String, length:String='q', octave:Int=4, velocity:Int=90) {
		var noteMap: Map<String,Dynamic> = [
			'note'=>note,
			'octave'=>octave,
			'velocity'=>velocity,
			'length'=>length
		];
		_notes.push(noteMap);
	}

	/**
	 * Function-based getter/setter for high-level notes representation
	 **/
	public function notes() {
		return _notes;
	}

	/**
	 * Parses high-level note data into single MIDI byte-data array
	 **/
	public function rawNotes() {
		var rawNoteData:Array<Int> = [];
		var note_i = 1;
		var lastNote = _notes[0];

		for (note in _notes) {
			var noteNum = 0;
			var nextNote = _notes[note_i-1];
			var noteVelocity = getMidiVelocityFromPercent(note['velocity']);
			var noteLen = note['length'];
			var noteLenNum = getMidiLengthFromAlias(noteLen);
			var restLenNum = 0;

			if (note['note'].toLowerCase() == 'r') {
				note_i++;
				continue;
			}

			if (note_i+1 < _notes.length) nextNote = _notes[note_i];
			if (nextNote['note'].toLowerCase() == 'r') {
				// Pull last note's bytes
				// Change last byte length to equal rest
				restLenNum = getMidiLengthFromAlias(nextNote['length']);
			}
			noteNum = MidiNoteLookup.getNoteAsInt(note['note'], note['octave']);
			rawNoteData.push(0x90);
			rawNoteData.push(noteNum);
			rawNoteData.push(noteVelocity);
			rawNoteData.push(noteLenNum);
			rawNoteData.push(0x80);
			rawNoteData.push(noteNum);
			rawNoteData.push(noteVelocity);
			// This check is needed because the extra 0 creates invalid MIDI data with unexpected EOF for common programs
			if (note_i < _notes.length) rawNoteData.push(restLenNum);
			note_i++;
			lastNote = note;
		}

		return rawNoteData;
	}

	/**
	 * Parses length alias to MIDI byte value
	 **/
	function getMidiLengthFromAlias(alias:String) {
		var lengthNum = _noteTick;
		switch (alias) {
			case 'w':
				lengthNum = _noteTick * 4;
			case 'h':
				lengthNum = _noteTick * 2;
			case 'q':
				lengthNum = _noteTick * 1;
			case 't':
				lengthNum = Std.int(_noteTick / 3);
			case 'e':
				lengthNum = Std.int(_noteTick / 2);
			case 's':
				lengthNum = Std.int(_noteTick / 4);
			default:
				lengthNum = _noteTick;
		}
		return lengthNum;
	}

	/**
	 * Parses percent volume to MIDI byte value
	 **/
	function getMidiVelocityFromPercent(velocityPercent:Float) {
		velocityPercent = velocityPercent/100;
		return Std.int(velocityPercent*0x7f);
	}
}
