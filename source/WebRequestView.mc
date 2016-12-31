//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi as Ui;
using Toybox.Graphics;
using Toybox.ActivityMonitor;
using Toybox.Time;
using Toybox.Timer;

class WebRequestView extends Ui.View
{
    hidden var mMessage = "Fitbit Step Sync";
    hidden var mModel;
    var days = 7;
    
    var fitbitLogin;
    var fitbitData;
    var fitbitWrite;
    var timer;
    var delay = 1000;

    function initialize()
    {
        Ui.View.initialize();
    }

    // Load your resources here
    function onLayout(dc) { }

    // Restore the state of the app and prepare the view to be shown
    function onShow() 
    {
    	login();
    }

    // Update the view
    function onUpdate(dc) 
    {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(0, 0, Graphics.FONT_XTINY, mMessage, Graphics.TEXT_JUSTIFY_LEFT);
    }

    // Called when this View is removed from the screen. Save the
    // state of your app here.
    function onHide() { }

    function appendWatchText(string) 
    {
        mMessage += string;
        Ui.requestUpdate();
    }
    
    function login()
    {
    	appendWatchText("\nLogging in...");        
        if (fitbitLogin == null)
		{
			timer = new Timer.Timer();
			fitbitLogin = new FitbitLogin(method(:onLogin));
			fitbitLogin.getAccessCode(); 
		}
    }
    
    function onLogin()
    {
    	fitbitLogin.callback = null;
    	appendWatchText("Done!");
    	delayRun(method(:getData));
    }
    
    function getData()
    {
    	days--;
    	if (days < 0)
    		{ return; }
    	
    	var negativeDays = new Time.Duration(-days * 60 * 60 * 24);
        var date = Time.today().add(negativeDays);
        var day = Time.Gregorian.utcInfo(date, Time.FORMAT_SHORT).day;
        
        appendWatchText("\n[" + day + "]");
    	fitbitData = new FitbitData(fitbitLogin.token_type, fitbitLogin.access_token, date, self);
    }
    
    function onGetData()
    {
    	fitbitData.caller = null;
    	appendWatchText("R" + fitbitData.garminSteps + "v" + fitbitData.fitbitSteps);
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
    	appendWatchText("W");
    	delayRun(method(:getData));
    }
    
    function delayRun(method)
    {
    	Communications.cancelAllRequests();
    	timer.start(method, delay, false);
    }
}