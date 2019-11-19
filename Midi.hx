//package mihxi;
import haxe.io.Bytes;
import sys.io.File;

class Midi {
	static function main() {
		var midHead = createHeaderChunk(1, 1, 60);
		var midTrk = new MidiNoteData('C', 'q');
		trace(midHead, midTrk.rawNotes());
		var midTrack = createTrackChunk();
	}
	static function createChunk(headerBytes, chunkData) {
		return headerBytes.concat(chunkData);
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

	static function createTrackChunk() {
		var MTrk = [0x4d,0x54,0x72,0x68,0x00,0x00,0x00,0x4f,0x00];
		var midiNotes = [0x90,0x48,0x50,0x60];
		return createChunk(MTrk, midiNotes);
	}
}
