using Toybox.WatchUi;

class BluconGarminWidgetView extends WatchUi.View {

  	hidden var mMessage = "Wait ...";
    hidden var mModel;
	var min = 40;
	var max = 350;
	var init = false;
	var pause = false;
	var timeToRefresh = 5; // min 
	var displayValues = (hourToDisplay * 60 / timeToRefresh);

	var h = System.getDeviceSettings().screenHeight/2;
	var w = System.getDeviceSettings().screenWidth;
	
    function initialize() {
        WatchUi.View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        displayBlucon(dc);
    	return;
    }

    // Restore the state of the app and prepare the view to be shown
    function onShow() {
    	if (pause){
    		delegate.getAuthentification();
        	pause = false; 
        }
        WatchUi.requestUpdate();
    	return;
    }
 
  
  	function findTop(h, value){
  		return 235 - ((((value - min) * h)/ (max -min)) - min/2);  		
  	}
  	
  	function calcWidth(screenWidth){
  		return screenWidth / (hourToDisplay * 60 / timeToRefresh);
  	}
 
 	
 	function displayActual(dc){
 		var val;
 		var textSize; 
 		if (readings_value != null && readings_value.size() > 0 && readings_value[0] != null){
 			val = readings_value[readings_value.size()-1];
 			textSize = Graphics.FONT_NUMBER_HOT;
 			dc.drawText(System.getDeviceSettings().screenWidth/2, System.getDeviceSettings().screenHeight/4*3+20, Graphics.FONT_MEDIUM, updated_time, Graphics.TEXT_JUSTIFY_CENTER);
 			
 		}else{
 			val = mMessage;
 			textSize =  Graphics.FONT_MEDIUM;
 		}
 		dc.drawText(System.getDeviceSettings().screenWidth/2, System.getDeviceSettings().screenHeight/4*2.5, textSize, val, Graphics.TEXT_JUSTIFY_CENTER);
 		
 	}
  
  	function hashLine(y, dc,val){
  		var i = 0;
  		var space = 6; 
  		while (i <= System.getDeviceSettings().screenWidth){
  			dc.drawLine(i, y, i + space, y);
  			i += (space*2);
  		}
  		dc.drawText(0, y, Graphics.FONT_SYSTEM_XTINY, val, Graphics.TEXT_JUSTIFY_LEFT);
  		
  	}
  
  	function displayLegend(dc){
  		var h = System.getDeviceSettings().screenHeight/2;
  		hashLine(findTop(h, 300),dc,300);
  		hashLine(findTop(h, 250),dc,250);
  		hashLine(findTop(h, 200),dc,200);
  		hashLine(findTop(h, 150),dc,150);
  		hashLine(findTop(h, 100),dc,100);
  		hashLine(findTop(h, 50),dc,50);
  		var bottom = findTop(h, 0);
  		dc.drawLine(22, 0, 22,bottom );
  		dc.drawLine( 0,bottom,  System.getDeviceSettings().screenWidth,bottom);  		
  	}
  	
  	function calculPosition(){
  		var position = [];
  		var c = 0;
    	for (var i = (readings_value.size() - 1); i >= 0 && c < displayValues ; i--) {
    		var tmp = findTop(h, readings_value[i]);
			position.add(tmp);
			c++;
		}
		return position;
  	}
  
  	
  	function drawCircles(dc, widthCol, position){
  		var next = w;
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		for (var i = 0; i < position.size()  ; i++) {
			dc.drawCircle(next, position[i], 5);
			next -= widthCol;
		}
  	}
  	
  	function drawLines(dc, widthCol, position){
  		dc.setPenWidth(2);
  		var next = w;
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		var c = 0;
		for (var i = 0; (i  + 1)< position.size() ; i++) {
			dc.drawLine(next, position[i], next-widthCol, position[i+1]);
			next -= widthCol;
			c++;
		}
  	}
  
    function displayBlucon(dc){
    	dc.clear();
    	dc.setAntiAlias(true);
    	displayActual(dc);
    	displayLegend(dc);
		if (readings_value.size() == 0){
			return;
		}
		if (readings_value[0] == null){
			return;
		}
    	
		
    	
    	var widthCol = calcWidth(w);
    	var position = calculPosition();
    	drawCircles(dc, widthCol, position);
    	drawLines(dc, widthCol, position);
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
    	displayBlucon(dc);
    }

    function onHide() {
    	pause = true; 
    }

    function onReceive(args) {
        if (args instanceof Lang.String) {
            mMessage = args;
        }
        else if (args instanceof Dictionary) {
            var keys = args.keys();
            mMessage = "";
            for( var i = 0; i < keys.size(); i++ ) {
                mMessage += Lang.format("$1$: $2$\n", [keys[i], args[keys[i]]]);
            }
        }
        WatchUi.requestUpdate();
    }
}
