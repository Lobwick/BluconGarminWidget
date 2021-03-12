using Toybox.Time;
using Toybox.Time.Gregorian as Calendar;

class Results {

function fake(){
		readings_value = [];
		readings_value.add(81);
		readings_value.add(174);
		readings_value.add(196);
		readings_value.add(73);
		readings_value.add(227);
		readings_value.add(248);
		readings_value.add(83);
		readings_value.add(82);
		readings_value.add(106);
		readings_value.add(216);
		readings_value.add(164);
		readings_value.add(190);
		readings_value.add(198);
		readings_value.add(222);
		readings_value.add(124);
		readings_value.add(93);
		readings_value.add(132);
		readings_value.add(245);
		readings_value.add(184);
		readings_value.add(59);
		readings_value.add(123);
		readings_value.add(156);
		readings_value.add(110);
		readings_value.add(146);
		readings_value.add(110);
		readings_value.add(147);
		readings_value.add(97);
		readings_value.add(172);
		readings_value.add(164);
		readings_value.add(137);
		readings_value.add(215);
		readings_value.add(89);
		readings_value.add(179);
		readings_value.add(83);
		readings_value.add(230);
		readings_value.add(176);
		readings_value.add(168);
		readings_value.add(108);
		readings_value.add(220);
		readings_value.add(205);
		readings_value.add(64);
		readings_value.add(241);
		readings_value.add(94);
		readings_value.add(125);
		readings_value.add(202);
		readings_value.add(196);
		readings_value.add(183);
		readings_value.add(195);
		readings_value.add(246);
		readings_value.add(190);
		readings_value.add(65);
		readings_value.add(108);
		readings_value.add(162);
		readings_value.add(123);
		readings_value.add(196);
		readings_value.add(234);
		readings_value.add(213);
		readings_value.add(225);
		readings_value.add(126);
		readings_value.add(147);
		readings_value.add(230);
		readings_value.add(79);
		readings_value.add(164);
		readings_value.add(147);
		readings_value.add(209);
		readings_value.add(182);
		readings_value.add(118);
		updated_time = "12/03 at 14:01";
	}


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
		fake();
		//data = cleanData(data);
		//parseReadings(split(data, "/"));
	}
}