package mihxi;
import haxe.io.Bytes;
import haxe.crypto.BaseCode;

class MidiData {
	public var timeSignature:String = 'c';
	public var key:String = 'C';
	public var tempo:Int = 120;
	var deltaTime = 0x00;

	public inline function new() {
	}

	public function createMidiFile(midiNotes,format:Int=1,tracks:Int=1) {
		var midHead = createHeaderChunk(format, tracks, 0x60);
		var midiData = midHead;
		var midTimeSig = setTimeSignature(this.timeSignature);
		var midKeySig = setKeySignature(this.key);
		var midInst = setInstrument('piano', 2);
		var midTempo = setTempo(this.tempo);
		var midPort = [deltaTime, 0xff,0x21,0x01,0x00];
		var xBytes = [
			deltaTime, 0xb0,0x79,0x00
		];
		var xBytes2 = [
			deltaTime, 0xb0,0x07,0x64,0x00,0x0a,0x40, 
			0x00,0x5b,0x00, 
			0x00,0x5d,0x00
		];

		var midTrackBody = [];
		midTrackBody = midTrackBody.concat(midTimeSig);
		midTrackBody = midTrackBody.concat(midKeySig);
		midTrackBody = midTrackBody.concat(midTempo);
		//midTrackBody = midTrackBody.concat(xBytes);
		midTrackBody = midTrackBody.concat(midInst);
		//midTrackBody = midTrackBody.concat(xBytes2);
		//midTrackBody = midTrackBody.concat(midPort);
		midTrackBody = midTrackBody.concat(midiNotes.rawNotes());

		var midTrack = createTrackChunk(midTrackBody);
		var midTrack2 = createTrackChunk(midiNotes.rawNotes());

		midiData = midiData.concat(midTrack);
		//midiData = midiData.concat(midTrack2);
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

		var midiInstrument = [deltaTime, channelCode, instrumentCode];

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

		var midiKeySigEvent = [deltaTime, 0xff, 0x59, 0x02];
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
		var midiTempoFlag = [deltaTime, 0xff, 0x51, 0x03];
		// TODO
		midiTempoFlag = midiTempoFlag.concat([0x07,0xa1,0x20]);
		return midiTempoFlag;
	}
	function setTimeSignature(timeSig:String='4/4') {
		if (timeSig.toLowerCase() == 'c') timeSig = '4/4';
		this.timeSignature = timeSig;

		var numerator = Std.parseInt( timeSig.split('/')[0] );
		var denominator = Std.parseInt( timeSig.split('/')[1] );
		var midClocksPerMetronomeTick = 0x24;
		var thirtysecondNotesPer24MidClockTicks = 0x08;

		var midiTimeSigEvent = [deltaTime, 0xff, 0x58, 0x04];
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
		return [deltaTime, 0xff,0x2f,0x00];
	}
	function createHeaderChunk(format, numberOfTracks, timing) {
		// Format0: single track
			// 1 header & 1 track chunk
		// Format1: multi tracks monomelodic (unison)
			// 1 header & 1+ track chunks
		// Format2: multi tracks polymelodic
			// 1 header & 1+ track chunks
		var MThd = [0x4d,0x54,0x68,0x64];
		var chunkLen = [0,0,0,0x06];
		var midiFormat = [0x00,format];
		var totalTracks = [0x00,0x01];
		var ticksPerQuarterNote = [0x00,0x60];

		var midiHeaderDataBytes = [].concat(chunkLen);
		midiHeaderDataBytes = midiHeaderDataBytes.concat(midiFormat);
		midiHeaderDataBytes = midiHeaderDataBytes.concat(totalTracks);
		midiHeaderDataBytes = midiHeaderDataBytes.concat(ticksPerQuarterNote);

		return createChunk(MThd, midiHeaderDataBytes);
	}
	function createTrackChunk(midiNotes:Array<Int>) {
		var trackEnd = [deltaTime, 0xff,0x2f,0x00];
		var trackLen = midiNotes.length + trackEnd.length;
		var MTrk = [0x4d,0x54,0x72,0x6b];
		var trackLenBytes = [0x00,0x00,0x00,trackLen];
		var trackLenStr = StringTools.hex(trackLen,8);

//TODO - get chars in sets of 2, convert to int for array. Cleaner than loop hacks
		trackLenBytes = [
			Std.parseInt('0x'+trackLenStr.substr(0,2)),
			Std.parseInt('0x'+trackLenStr.substr(2,2)),
			Std.parseInt('0x'+trackLenStr.substr(4,2)),
			Std.parseInt('0x'+trackLenStr.substr(6,2)),
		];
trace('LengthBytes: $trackLenBytes');
/*
		if (trackLen > 0xff) {
			//trace(trackLen);
trace(StringTools.hex(trackLen));
			trackLenBytes = [0x00,0x00,0x01,trackLen];
			//trackLenBytes = [0x00,0x00,trackLen];
		}
		if (trackLen > 0xffff) trackLenBytes = [0x00,trackLen];
		if (trackLen > 0xffff) trackLenBytes = [0x00,trackLen];
		if (trackLen > 0xffffff) trackLenBytes = [trackLen];
*/
		MTrk = MTrk.concat(trackLenBytes);
		var trackChunk = createChunk(MTrk, midiNotes);
		//trackChunk = trackChunk.concat(trackEnd);
		return trackChunk;
	}
}
