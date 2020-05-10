using Toybox.System;
using Toybox.Timer;
using Toybox.WatchUi;

class FastingViewDelegate extends WatchUi.BehaviorDelegate {
	
	var keys;
	var timer;
	var fast_manager;
	var resource_manager;
	
	class KeyHeldDelegate {
		var parent;
		var key;
		
		function initialize(parent, key) {
			me.parent = parent;
			me.key = key;
		}
		
		function invoke() {
			parent.onKeyHeld(new WatchUi.KeyEvent(key, WatchUi.PRESS_TYPE_ACTION));
		}
	}

  	function initialize() {
        BehaviorDelegate.initialize();
        fast_manager = Application.getApp().fast_manager;
        resource_manager = Application.getApp().resource_manager;
        
        
        keys = new [WatchUi has :EXTENDED_KEYS ? 23 : 16];
        timer = new Timer.Timer();
    }
	
	function onKeyPressed(evt) {
		var key = evt.getKey();
		
		if (keys[key] == null) {
			keys[key] = new KeyHeldDelegate(me, key);
		}
		
		timer.stop();
		timer.start(keys[key].method(:invoke), resource_manager.longpress_threshold, false);
		
		return true; 
	}
	
	function onKeyHeld(evt) {
		var key = evt.getKey();
		keys[key] = null;
		
		if (fast_manager.fast == null) {
			var menu = new MenuHandler();
			menu.openFastTypeMenu();
		}
	}
	
	function onKeyReleased(evt) {
		var key = evt.getKey();
		
		if (keys[key] == null) {
			return true;
		}
		
		keys[key] = null;
		
		timer.stop();
		
		fast_manager.nextPage();
		
		return true;
	}
}