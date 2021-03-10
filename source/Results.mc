var readings_value = [];
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
	}
	
	function toto(json){
		/*for (var i = 0; i < json.size(); i++) {
			// check si pas de NA 
			if (json[i].find("NA") == null){
				if (json[i].find("count") == null){
					var line = split(json[i], "%22%2C%22");
					var value = split(line[0], "%22Q%22")[1];
					//var time = stringReplace(line[1], "reading_time%22Q%22", "");    
					readings_value.add(value.toNumber());
					//System.println(value + " at " + time);
				}
			}
		}*/
		
		fake();
		return readings_value;
		
		
		/*count = json["count"];
		System.println("count");
		System.println(count);
		System.println(json["readings"]);*/
		//setReadings(json["readings"]);
	}

	function initialize(json) {
		return toto(json);
	}

}