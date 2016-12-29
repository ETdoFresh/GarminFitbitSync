//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi as Ui;
using Toybox.Graphics;
using Toybox.ActivityMonitor;
using Toybox.Time;

class WebRequestView extends Ui.View {
    hidden var mMessage = "Press menu button";
    hidden var mModel;

    function initialize() {
        Ui.View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        onReceive(ActivityMonitor.getInfo().getHistory());//"Press menu or\nselect button";
    }

    // Restore the state of the app and prepare the view to be shown
    function onShow() {
    	onReceive(ActivityMonitor.getInfo().getHistory()[0].steps);
            System.println(ActivityMonitor.getInfo().getHistory()[0].steps);
            var negativeOneDay = new Time.Duration(-60 * 60 * 24);
            var yesterday = Time.today().add(negativeOneDay);
            var time = Time.Gregorian.utcInfo(yesterday, Time.FORMAT_SHORT);
            System.println(time.month + " " + time.day + " " + time.year);
    }

    // Update the view
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_MEDIUM, mMessage, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of your app here.
    function onHide() {
    }

    function onReceive(args) {
        if (args instanceof Lang.String) {
            mMessage = args;
        }
        else if (args instanceof Dictionary) {
            // Print the arguments duplicated and returned by httpbin.org
            var keys = args.keys();
            mMessage = "";
            for( var i = 0; i < keys.size(); i++ ) {
                mMessage += Lang.format("$1$: $2$\n", [keys[i], args[keys[i]]]);
            }
        }
        Ui.requestUpdate();
    }
}
