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

    function initialize()
    {
        Ui.View.initialize();
    }

    // Load your resources here
    function onLayout(dc) { }

    // Restore the state of the app and prepare the view to be shown
    function onShow() 
    {
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
}