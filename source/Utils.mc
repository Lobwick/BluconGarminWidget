using Toybox.Communications;
using Toybox.WatchUi;
using Toybox.System as Sys;
using Toybox.Time;
using Toybox.Time.Gregorian;

function timestampSecondToMs(nb){		
		var str = nb.format("%010d");
		return str + "000";
	}

function getTimeRange(){
	var now = new Time.Moment(Time.now().value());
	var oneDay = new Time.Duration(1*60*60);
	var first = now.subtract(oneDay);
	var res = {
		"begin_date" =>  first.value().toString(),
		"end_date" => now.value().toString()
	};
	return res;
}

function stringReplace(str, oldString, newString){
	var result = str;
	
	while (true){
		var index = result.find(oldString);
		
		if (index != null){
			var index2 = index + oldString.length();
			result = result.substring(0, index) + newString + result.substring(index2, result.length());
		}else{
			return result;
		}
	}
	return null;
}

function toTimestamp(strDate){
   		//var datum = Date.parse(strDate);
   		//return datum/1000;
}

function split(s, sep) {
	var tokens = []; //This works ? No need for initialisation ? This is good for me, but as I have errors, I asked me if this was not there the problem
	
	var found = s.find(sep);
	while (found != null) {
		var token = s.substring(0, found);
		tokens.add(token);
		s = s.substring(found + sep.length(), s.length());
		found = s.find(sep);
	}
	
	tokens.add(s);
	//System.println("tokens = "+tokens); //This failed, I don't understand why
	
	return tokens;
}