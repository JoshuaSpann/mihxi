//package mihxi;

class MidiNoteData {
	public var note_status:Int;
	public var note:Int;
	public var velocity:Int;
	public var length:Int;

	public inline function new(noteStatus, note, velocity, length) {
		this.note_status = noteStatus;
		this.note = note;
		this.velocity = velocity;
		this.length = length;
	}
}
