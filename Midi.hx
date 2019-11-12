class Midi {
	static function main() {
		trace('Hi');
	}
	function createChunk(header, chunkLength) {
		trace('NOT IMPLEMENTED!');
	}
	function createHeaderChunk(format, numberOfTracks, timing) {
		// TYPE: 4byte ASCII
		// LENGTH: 4bytes binary 32bit
		// DATA: 6bytes (16bit format, 16bit tracks, 16bit division)
			// Format0: single track
				// 1 header & 1 track chunk
			// Format1: multi tracks monomelodic (unison)
				// 1 header & 1+ track chunks
			// Format2: multi tracks polymelodic
				// 1 header & 1+ track chunks
		trace('NOT IMPLEMENTED!');
		var headerdata = 6;
		createChunk('MThd', headerdata);
	}
	function creatTrackChunk() {
		trace('NOT IMPLEMENTED!');
		var trackdata = 16;
		createChunk('MTrk', trackdata);
	}
}
