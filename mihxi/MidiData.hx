package mihxi;

class MidiData {
	public static function createMidiFile(midiNotes) {
		var midHead = createHeaderChunk(1, 1, 60);
		var midiData = midHead;
		midiData = midiData.concat(createTrackChunk(midiNotes.rawNotes()));
		midiData = midiData.concat(createChunkEnd());
		midiData = midiData.concat(createChunkEnd());
		return midiData;
	}
	static function createChunk(headerBytes, chunkData) {
		return headerBytes.concat(chunkData);
	}
	static function createChunkEnd() {
		return [0xff, 0x2f, 0x00];
	}
	static function createHeaderChunk(format, numberOfTracks, timing) {
		// TYPE: 4byte ASCII
		// LENGTH: 4bytes binary 32bit
		// DATA: 6bytes (16bit format, 16bit tracks, 16bit division)
			// Format0: single track
				// 1 header & 1 track chunk
			// Format1: multi tracks monomelodic (unison)
				// 1 header & 1+ track chunks
			// Format2: multi tracks polymelodic
				// 1 header & 1+ track chunks
		var MThd = [0x4d,0x54,0x68,0x64];
		var midiHeaderDataBytes = [0x00,0x00,0x00,0x06,0x00,0x01,0x00,0x11,0x00,0x60];
		return createChunk(MThd, midiHeaderDataBytes);
	}
	static function createTrackChunk(midiNotes) {
		var MTrk = [0x4d,0x54,0x72,0x6b,0x00,0x00,0x00,0x4f,0x00];
		return createChunk(MTrk, midiNotes);
	}
}
