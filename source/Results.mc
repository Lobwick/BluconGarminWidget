using Toybox.Time;
using Toybox.Time.Gregorian as Calendar;

class Results {

	function cleanData(data){
		var no_array = stringReplace(data, "{'readings':[{", "");		
		var encoded = Communications.encodeURL(no_array);
		var encoded_clean = stringReplace(encoded, "%22", "");
		return  decodeData(encoded_clean);
	}

	function getReadFromLine(line){
		return stringReplace(line, "reading:", "").toNumber();
	}
	
	function getLastUpdate(line){
		var timestamp = stringReplace(stringReplace(line, "reading_time:", ""), "%7D%5D", "").substring(0, 10).toLong();
		var moment = new Toybox.Time.Moment(timestamp);
		var date = Calendar.info(moment, Time.FORMAT_SHORT);
		return Lang.format("$1$/$2$ at $3$:$4$", [date.day, date.month, date.hour, date.min]);
	}

	function getLastReadAndTime(data, last_line){
		if (last_line >= 0){
			var line = split(data[last_line], ",");
			readings_value.add(getReadFromLine(line[0]));
			updated_time = getLastUpdate(line[1]);
		}
	}

	function parseReadings(data){
		for (var i = 0; i < (data.size() - 1); i++) {
			System.println("tab["+i+"]:"+data[i]);
			var line = split(data[i], ",");
			readings_value.add(getReadFromLine(line[0]));
		}
		getLastReadAndTime(data, data.size()-1);
	}

	function initialize(data) {
		data = cleanData(data);
		parseReadings(split(data, "/"));
	}
}