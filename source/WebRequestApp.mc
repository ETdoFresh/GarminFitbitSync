//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Application as App;
using Toybox.Communications;

class WebRequestApp extends App.AppBase {
    hidden var mView;

	var days = 7;
    var fitbitLogin;
    var fitbitData;
    var fitbitWrite;
    var timer;
    var delay = 10;

    function initialize() {
        App.AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
    	mView = new WebRequestView();
    	login();
        return [mView];
    }
    
    function login()
    {    
    	//appendWatchText("\nLogging in...");        
        if (fitbitLogin == null)
		{
			mView.appendWatchText("\nLogging in...");
			timer = new Timer.Timer();
			fitbitLogin = new FitbitLogin(method(:onLogin));
			fitbitLogin.getAccessCode(); 
		}
    }
    
    function onLogin()
    {
    	fitbitLogin.callback = null;
    	mView.appendWatchText("Done!");
    	delayRun(method(:getData));
    }
    
    function getData()
    {
    	days--;
    	if (days < 0)
    		{ mView = null; return; }
    	
    	var negativeDays = new Time.Duration(-days * 60 * 60 * 24);
        var date = Time.today().add(negativeDays);
        var day = Time.Gregorian.utcInfo(date, Time.FORMAT_SHORT).day;
        
        mView.appendWatchText("\n[" + day + "]");
    	fitbitData = new FitbitData(fitbitLogin.token_type, fitbitLogin.access_token, date, self);
    }
    
    function onGetData()
    {
    	fitbitData.caller = null;
    	mView.appendWatchText("R" + fitbitData.garminSteps + "v" + fitbitData.fitbitSteps);
    	if (fitbitData.deltaSteps() > 10)
    		{ delayRun(method(:writeData)); }
    	else
    		{ delayRun(method(:getData)); }
    }
    
    function writeData()
    {
    	var f = fitbitData;
    	fitbitWrite = new FitbitWrite(f.token_type, f.access_token, f.date, f.deltaSteps(), self);
    }
    
    function onWriteData()
    {
    	fitbitWrite.caller = null;
    	mView.appendWatchText("W");
    	delayRun(method(:getData));
    }
    
    function delayRun(method)
    {
    	Communications.cancelAllRequests();
    	timer.start(method, delay, false);
    }
    
}