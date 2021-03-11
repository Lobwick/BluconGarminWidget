using Toybox.Communications;
using Toybox.WatchUi;
using Toybox.System as Sys;
using Toybox.Time;
using Toybox.Time.Gregorian;

class BluconGarminWidgetDelegate extends WatchUi.BehaviorDelegate {
    var notify;
    var access_token = "";
    var access_token_user = "";
    var results;
    var expiration_token;
    
    var user_name = "";
    var email = "";
	var password = "";

	
	function getCredentials(){
 		var app = Application.getApp();
 		user_name = Communications.encodeURL(app.getProperty("bluconName"));
		email = app.getProperty("bluconEmail");
		password = app.getProperty("bluconPwd");
		hourToDisplay = app.getProperty("hourToDisplay");
	}
	
	
    function initialize(handler) {
    	getCredentials();
        WatchUi.BehaviorDelegate.initialize();
        notify = handler;
        getAuthentification();
    }

    function onMenu() {
        return true;
    }

    function onSelect() {
        return true;
    }
    
	function makeRequest2(url, params, header, callBackMethod) {
        var options = {
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_TEXT_PLAIN,
            :headers => header,
            :method => Communications.HTTP_REQUEST_METHOD_GET
        };
        Communications.makeWebRequest(
            url,
            params,
            options,
            method(callBackMethod)
        );
    }


    function makeRequest(url, params, header, callBackMethod) {
        var options = {
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => header,
            :method => Communications.HTTP_REQUEST_METHOD_GET
        };
        Communications.makeWebRequest(
            url,
            params,
            options,
            method(callBackMethod)
        );
    }
    
    function checkCredentials(){
    	if ( user_name.length() == 0){
			notify.invoke("Fill user in app");
			return -1;
		}if ( email.length() == 0){
			notify.invoke("Fill email in app");
			return -1;
		}if ( password.length() == 0){
			notify.invoke("Fill password in app");
			return -1;
		}
		return 0;
    }
    

	function getAuthentification(){
		notify.invoke("Loading 1/3 ...");
		if (checkCredentials() == -1){
				return; 
		}
		var header = {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
        };
		var params = {
        	"client_id" => "3778df716227c0666f713139666323609262b6df64ed66.ambrosiasys.com",
			"client_secret" => "Q7RdHd67G23P371e3T9FNL767C6EfI669206fDK6YV6J1UA3X16WZS2OM6B",
			"response_type" => "code",
			"redirect_uri" => "http://test.twomoulins.fr/",
			"email" => email,
			"password" => password
        };
        makeRequest("https://www.ambrosiasys.com/app/authentication", params, header, :receiveAuthentification);
	}

	function getUserAuthorization(){
		notify.invoke("Loading 2/3 ...");
		var header = {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
        };
		var params = {
        	"grant_type" => "access_token",
			"code " => access_token,
			"signature" => user_name,
        };
        makeRequest("https://www.ambrosiasys.com/app/user_authorization?grant_type=access_token&code="+access_token+"&signature="+user_name, params, header, :receiveUserAuthorization);//		
	}
	
	function getReadings(){
		notify.invoke("Loading 3/3 ...");
		var header = {
				"authorization" => access_token_user,
        };
        var timeRange = getTimeRange();
        makeRequest2("https://www.ambrosiasys.com/app/readings", timeRange, header, :receiveReadings);		
	}
	
	function receiveReadings(responseCode, data) {
        if (responseCode == 200) {
        	var res = new Results(data);
        	if (readings_value != null  && readings_value.size() > 0 && readings_value[0] != null){
        		notify.invoke(readings_value[readings_value.size()-1].toString());
            }else{
            	notify.invoke("NA");
            }
            
        } 
    }
    
    function receiveUserAuthorization(responseCode, data) {
        if (responseCode == 200  && data["access_token"] != null) {
        	access_token_user = data["access_token"];
        	expiration_token = data["expires_in"];
            getReadings();
        }else{
        	notify.invoke("Check your username");
        }
    }

    function receiveAuthentification(responseCode, data) {
        if (responseCode == 200 && data["access_token"] != null) {
        	access_token = data["access_token"];
            getUserAuthorization();
        }else{
        	notify.invoke("Check your email/password");
        }
    }
}
