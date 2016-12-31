using Toybox.Communications;
using Toybox.System;
using Toybox.ActivityMonitor;
using Toybox.Time;

class FitbitData
{
	const activities_url = "https://api.fitbit.com/1/user/-/activities/date/";
	
	var caller = :set_in_constructor;
	var token_type = :set_in_constructor;
	var access_token = :set_in_constructor;
	var date = :set_in_constructor;
	var fitbitSteps = 0;
	var garminSteps = 0;
	
	function initialize(new_token_type, new_access_token, new_date, new_caller)
	{
		token_type = new_token_type;
		access_token = new_access_token;
		date = new_date;
		caller = new_caller;
		
		getActivities();
    }
    
    function getActivities()
    {
    	System.println("getActivities()");
        var date = Time.Gregorian.utcInfo(self.date, Time.FORMAT_SHORT);
        var url = activities_url + date.year + "-" + date.month + "-" + date.day + ".json";
        var parameters = { };
        var headers = {"Authorization" => token_type + " " + access_token};
        var options = {:method => Communications.HTTP_REQUEST_METHOD_GET, :headers => headers};
        var responseCallback = method(:onGetActivities);
        Communications.makeWebRequest(url, parameters, options, responseCallback);
    }
    
    function onGetActivities(responseCode, data)
    {
    	System.println("onGetActivities(" + responseCode + ", " + data + ")");   	    	
    	var deltaDays = Math.round(Time.today().subtract(date).value() / (60 * 60 * 24)).toNumber();
    	if (ActivityMonitor.getHistory().size() <= deltaDays)
    	{
    		fitbitSteps = -1;
    		garminSteps = -1;
		}
		else
		{    	
			fitbitSteps = data["summary"]["steps"];
			garminSteps =  ActivityMonitor.getHistory()[deltaDays].steps;
		}
		caller.onGetData();
    }
    
    function deltaSteps()
    {
    	return garminSteps - fitbitSteps;
    }
}