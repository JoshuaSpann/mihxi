package mihxi;

class MidiData {
	public var timeSignature:String = 'c';
	public var key:String = 'C';
	public var tempo:Int = 120;

	public inline function new() {
	}

	public function createMidiFile(midiNotes) {
		var midHead = createHeaderChunk(1, 1, 60);
		var midiData = midHead;
		var midTimeSig = setTimeSignature(this.timeSignature);
		var midKeySig = setKeySignature(this.key);
		var midInst = setInstrument('piano', 0);
		var midTempo = setTempo(this.tempo);

		var midTrackBody = [];
		//midTrackBody = midTrackBody.concat(midTimeSig);
		//midTrackBody = midTrackBody.concat(midKeySig);
		//midTrackBody = midTrackBody.concat(midTempo);
		//midTrackBody = midTrackBody.concat(midInst);
		midTrackBody = midTrackBody.concat(midiNotes.rawNotes());

		var midTrack = createTrackChunk(midTrackBody);

		midiData = midiData.concat(midTrack);
		midiData = midiData.concat(createChunkEnd());
		midiData = midiData.concat(createChunkEnd());
		return midiData;
	}
	function setInstrument(instrument, channel) {
		var instrumentCode = 0;
		var channelCode = 0xc0;

		if (channel > 15) channel = 15;
		channelCode += channel;

		if (instrument.toLowerCase() == 'piano') {
			instrumentCode = 0x00;
		}

		var midiInstrument = [];
		midiInstrument.push(channelCode);
		midiInstrument.push(instrumentCode);

		return midiInstrument;
	}
	function setKeySignature(key:String='C') {
		var keys = [
			'C','D','E','F','G','A','B',
			'C#','D#','F#','G#','A#',
			'Db','Eb','Gb','Ab','Bb'
		];
		var sharps = 0;
		var flats = 0;
		var isMinor = false;
		if (keys.indexOf(key.toUpperCase()) < 0 && keys.indexOf(key.toLowerCase()) < 0) {
			key = 'C';
		}

		if (key == 'C') { }
		switch (key) {
			case 'C#':
				sharps = 7;
			case 'c':
				flats = 3;
				isMinor = true;
			case 'c#':
				sharps = 4;
				isMinor = true;
			case 'D':
				sharps = 2;
			case 'D#':
				sharps = 5;
			case 'Db':
				flats = 5;
			case 'd':
				flats = 1;
				isMinor = true;
			case 'd#':
				sharps = 6;
				isMinor = true;
			case 'db':
				flats = 6;
				isMinor = true;
			case 'E':
				sharps = 4;
			case 'Eb':
				flats = 3;
			case 'e':
				sharps = 1;
				isMinor = true;
			case 'eb':
				flats = 6;
				isMinor = true;
			case 'F':
				flats = 1;
			case 'F#':
				sharps = 6;
			case 'f':
				flats = 4;
				isMinor = true;
			case 'f#':
				sharps = 3;
				isMinor = true;
			case 'G':
				sharps = 1;
			case 'G#':
				sharps = 6;
			case 'Gb':
				flats = 6;
			case 'g':
				flats = 2;
				isMinor = true;
			case 'g#':
				sharps = 5;
				isMinor = true;
			case 'A':
				sharps = 3;
			case 'A#':
				// B-Flat major
				flats = 2;
			case 'Ab':
				flats = 4;
			case 'a':
				isMinor = true;
			case 'a#':
				sharps = 7;
				isMinor = true;
			case 'ab':
				flats = 7;
				isMinor = true;
			case 'B':
				sharps = 5;
			case 'Bb':
				flats = 2;
			case 'b':
				sharps = 2;
				isMinor = true;
			case 'bb':
				flats = 5;
				isMinor = true;
			default:
				// Defaults to C-Major
				sharps = 0;
				flats = 0;
				isMinor = false;
		}

		var midiKeySigEvent = [0xff, 0x59, 0x02];
		var flatsSharps = 0;
		var majorMinor = 0;

		flatsSharps += sharps;
		flatsSharps -= flats;
		if (isMinor) majorMinor = 1;

		midiKeySigEvent.push(flatsSharps);
		midiKeySigEvent.push(majorMinor);

		return midiKeySigEvent;
	}
	function setTempo(tempoBPM:Int=120) {
		var midiTempoFlag = [0xff, 0x51, 0x03];
		// TODO
		midiTempoFlag = midiTempoFlag.concat([0x50,0x00,0x00]);
		return midiTempoFlag;
	}
	function setTimeSignature(timeSig:String='4/4') {
		if (timeSig.toLowerCase() == 'c') timeSig = '4/4';
		this.timeSignature = timeSig;

		var numerator = Std.parseInt( timeSig.split('/')[0] );
		var denominator = Std.parseInt( timeSig.split('/')[1] );
		var midClocksPerMetronomeTick = 0x18;
		var thirtysecondNotesPer24MidClockTicks = 0x08;

		var midiTimeSigEvent = [0xff, 0x58, 0x04];
		midiTimeSigEvent.push(numerator);
		midiTimeSigEvent.push(Std.int(denominator/2));
		midiTimeSigEvent.push(midClocksPerMetronomeTick);
		midiTimeSigEvent.push(thirtysecondNotesPer24MidClockTicks);

		return midiTimeSigEvent;
	}
	function createChunk(headerBytes, chunkData) {
		return headerBytes.concat(chunkData);
	}
	function createChunkEnd() {
		return [0xff, 0x2f, 0x00];
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
		var MThd = [0x4d,0x54,0x68,0x64];
		var midiHeaderDataBytes = [0x00,0x00,0x00,0x06,0x00,0x01,0x00,0x11,0x00,0x60];
		return createChunk(MThd, midiHeaderDataBytes);
	}
	function createTrackChunk(midiNotes) {
		var MTrk = [0x4d,0x54,0x72,0x6b,0x00,0x00,0x00,0x4f,0x00];
		return createChunk(MTrk, midiNotes);
	}
}
