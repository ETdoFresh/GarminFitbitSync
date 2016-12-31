using Toybox.Communications;
using Toybox.System;
using Toybox.ActivityMonitor;
using Toybox.Time;

class FitbitWrite
{
	const new_activity_url = "https://api.fitbit.com/1/user/-/activities.json";
	
	var token_type = :set_in_constructor;
	var access_token = :set_in_constructor;
	var date = :set_in_constructor;
	var steps = :set_in_constructor;
	var caller = :set_in_constructor;
	
	function initialize(new_token_type, new_access_token, new_date, new_steps, new_caller)
	{
		token_type = new_token_type;
		access_token = new_access_token;
		date = new_date;
		steps = new_steps;
		caller = new_caller;

		writeSteps();
    }
    
    function writeSteps()
    {
    	System.println("writeSteps()");
    	var date = Time.Gregorian.utcInfo(self.date, Time.FORMAT_SHORT);
    	var time = Time.Gregorian.utcInfo(Time.now(), Time.FORMAT_SHORT);
    	var url = new_activity_url;
        var parameters = {
        	"activityId" => "90013",
        	"distance" => steps.toString(),
        	"distanceUnit" => "steps",
        	"startTime" => time.hour + ":" + time.min + ":" + time.sec,
        	"durationMillis" => "60000",
        	"date" => date.year + "-" + date.month + "-" + date.day
    	};
        var headers = {"Authorization" => token_type + " " + access_token};
        var options = {:method => Communications.HTTP_REQUEST_METHOD_POST, :headers => headers};
        var responseCallback = method(:onWriteSteps);
        Communications.makeWebRequest(url, parameters, options, responseCallback);
    }
    
    function onWriteSteps(responseCode, data)
    {		
    	System.println("onWriteSteps(" + responseCode + ", " + data + ")");
    	caller.onWriteData();
    }
}