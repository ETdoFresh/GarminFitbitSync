using Toybox.Communications;
using Toybox.System;

class FitbitLogin
{
	const client_id = "2287K5";
	const response_type = "code";
	const grant_type = "authorization_code";
	const accessCodeUrl = "https://www.fitbit.com/oauth2/authorize";
	const accessTokenUrl = "https://api.fitbit.com/oauth2/token";
	const redirect_uri = "https://www.etdofresh.com/oauth2/get_code.php";
	const scope = "activity";
	const expires_in = "604800";
	
	var callback = null;
	var token_type = "Not Available";
	var access_token = "Not Available";
	var refresh_token = "Not Available";
	
	function initialize(new_callback)
	{
		callback = new_callback;
        Communications.registerForOAuthMessages(method(:onGetAccessCode));
    }
    
    function getAccessCode() 
    {
        System.println("getAccessCode()");
        var requestUrl = accessCodeUrl;
        var requestParams = {"response_type" => response_type, "client_id" => client_id, "redirect_uri" => redirect_uri, "scope" => scope, "expires_in" => expires_in};
        var resultUrl = redirect_uri;
        var resultType = Communications.OAUTH_RESULT_TYPE_URL;
        var resultKeys = { "code" => "value" };
        Communications.makeOAuthRequest(requestUrl, requestParams, resultUrl, resultType, resultKeys);
    }
    
     function getAccessToken(accessCode) 
     {
        System.println("getAccessToken(" + accessCode + ")");
        accessCode = replace(accessCode, "#_=_", "");
        var url = accessTokenUrl;
        var parameters = {"code" => accessCode, "clientId" => client_id, "redirect_uri" => redirect_uri, "grant_type" => grant_type};
        var headers = {"Authorization" => "Basic MjI4N0s1Ojg0NDRiM2NlZWRmZWNmYjcxZGY5MjUwNmYzNTg3M2Rk"};
        var options = {:method => Communications.HTTP_REQUEST_METHOD_POST, :headers => headers};
        var responseCallback = method(:onGetAccessToken);
        Communications.makeWebRequest(url, parameters, options, responseCallback);
    }
    
    function onGetAccessCode(value)
    {
    	System.println("onGetAccessCode(" + value + ")");
    	System.println(dictionaryToString(value.data, 0));
    
        if( value.data != null)
        	{ getAccessToken(value.data["value"]); }
        else
        {
            System.println("Error in accessCodeResult");
            System.println("data = " + value.data);
            System.println(value.responseCode);
        }
    }
    
    function onGetAccessToken(responseCode, data)
    {
    	System.println("onGetAccessToken(" + responseCode + ", " + data + ")");
        if( data != null) 
        {
        	token_type = data["token_type"];
            access_token = data["access_token"];
            refresh_token = data["refresh_token"];
            callback.invoke();
            callback = null;
        }
        else 
        {
            System.println("Error in handleAccessResponse");
            System.println("data = " + data);
        }
    }
}