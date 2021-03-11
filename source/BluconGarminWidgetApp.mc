using Toybox.Application;

var delegate;
var hourToDisplay = 1;
var readings_value = [];
var updated_time = "NA";


class BluconGarminWidgetApp extends Application.AppBase {

	hidden var mView;
	
	function onSettingsChanged(){
		var app = Application.getApp();
 		hourToDisplay = app.getProperty("hourToDisplay");
	}
	
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        mView = new BluconGarminWidgetView();
        delegate = new BluconGarminWidgetDelegate(mView.method(:onReceive));
        return [mView, delegate];
    }
}