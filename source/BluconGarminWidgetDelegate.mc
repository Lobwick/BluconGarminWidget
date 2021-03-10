//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

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
		System.println("getSettings");
		System.println(user_name + " " + email + " " + password);
	}
	
	
	    // Set up the callback to the view
    function initialize(handler) {
    	getCredentials();
    	System.println("initialize");
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
        notify.invoke("Executing\nRequest");
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
        notify.invoke("Executing\nRequest");
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

	function getAuthentification(){
	System.println("getAuthentification");
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
		var header = {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
        };
		var params = {
        	"grant_type" => "access_token",
			"code " => access_token,
			"signature" => user_name,
        };
        makeRequest("https://www.ambrosiasys.com/app/user_authorization?grant_type=access_token&code="+access_token+"&signature=felix%20moulin", params, header, :receiveUserAuthorization);		
	}
	
	function getReadings(){
		var header = {
				"authorization" => access_token_user,
        };
        var timeRange = getTimeRange();

		var params = {
        	"begin_date" 	=> "16136777820",//timeRange["start"],
			"end_date" 		=> "16136792820",//timeRange["end"]
        };
        makeRequest2("https://www.ambrosiasys.com/app/readings", timeRange, header, :receiveReadings);		
	}
	
	function receiveReadings(responseCode, data) {
		System.println("receiveReadings");
        if (responseCode == 200) {
        	var test = stringReplace(data, "{'readings':[", "");
        	var test2 = stringReplace(test, ", 'count':20}]", "");
        	var test3 = stringReplace(test2, ":", "Q");        	
        	var testtab = split(Communications.encodeURL(test3),"%22%7D%2C%7B%22");
        	var popo = new Results(testtab);
        	System.println("size : "+ readings_value.size() + "content : "+readings_value[0]);
        	if (readings_value != null  && readings_value.size() > 0 && readings_value[0] != null){
        		notify.invoke(readings_value[readings_value.size()-1].toString());
            }else{
            	notify.invoke("NA");
            }
            
        } 
    }
    



    
    function receiveUserAuthorization(responseCode, data) {
    	System.println("receiveUserAuthorization");
        if (responseCode == 200) {
        	access_token_user = data["access_token"];
        	expiration_token = data["expires_in"];
            getReadings();
        } 
    }

    // Receive the data from the web request
    function receiveAuthentification(responseCode, data) {
    	System.println("receiveAuthentification");
        if (responseCode == 200) {
        	access_token = data["access_token"];
            getUserAuthorization();
        }
    }
}
