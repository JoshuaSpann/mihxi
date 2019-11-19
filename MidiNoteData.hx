//package mihxi;
class MidiNoteData {
	public var note_status:Int;
	public var note:Int;
	public var velocity:Int;
	public var length:Int;

	var _noteTick:Int = 0x60;
	//var _notes:Array<Array<Dynamic>> = [];
	var _notes:Array<Map<String,Dynamic>> = [];
	var _notesRaw:Array<Array<Int>> = [[0x90,0x48,0x50,0x60, 0x80,0x48,0x50,0x60]];

	public inline function newRawNotes(noteStatus, note, velocity, length) {
		this.note_status = noteStatus;
		this.note = note;
		this.velocity = velocity;
		this.length = length;
	}

	public inline function new(note:String, length:String='q', octave:Int=4, aftertouch:Int=0x50) {
		add(note,length,octave,aftertouch);
	}

	public function add(note:String, length:String='q', octave:Int=4, aftertouch:Int=0x50) {
		var noteNum = MidiNoteLookup.getNoteAsInt(note, octave);
		var lengthNum = 0x60;
		var noteMap: Map<String,Dynamic> = [
			'note'=>note,
			'octave'=>octave,
			'velocity'=>velocity,
			'length'=>length
		];
		_notes.push(noteMap);
		switch (length) {
			case 'w':
				lengthNum = _noteTick * 4;
			case 'h':
				lengthNum = _noteTick * 2;
			case 'q':
				lengthNum = _noteTick * 1;
			case 'e':
				lengthNum = Std.int(_noteTick / 2);
			case 's':
				lengthNum = Std.int(_noteTick / 4);
			default:
				lengthNum = _noteTick;
		}
	}
	public function notes() {
		return _notes;
	}
	public function rawNotes() {
		//var noteData:Array<Dynamic> = [0x90, note, aftertouch, length, 0x80, note, aftertouch, 0];
		var rawNoteData:Array<Int> = [];
		for (note in _notes) {
			var noteNum = MidiNoteLookup(note['note'], note['octave'])
			var noteVelocity = note['velocity'];
			var noteLen = note['length'];
			var noteLenNum = 0;

			rawNoteData.push(0x90);
			rawNoteData.push(noteNum);
			rawNoteData.push(noteVelocity);
			rawNoteData.push(noteLenNum);
			rawNoteData.push(0x80);
			rawNoteData.push(noteNum);
			rawNoteData.push(noteVelocity);
			rawNoteData.push(0);
		}
		return rawNoteData;
	}
}
