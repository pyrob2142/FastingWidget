using Toybox.System;
using Toybox.Timer;
using Toybox.WatchUi;

//! Handles the page navigation and long press menus.
class FastingViewDelegate extends WatchUi.BehaviorDelegate {
	
	var keys;
	var timer;
	var fast_manager;
	var resource_manager;
	
	//! Used to determine if a key is held for a set amount of time.
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
	
	//! Handles key held events.
	//! If no fast is active, the users gets to start a new fast.
	//! If a fast is active, we present options to finish or cancel the fast 
	//! depending on its current progress.
	function onKeyHeld(evt) {
		var key = evt.getKey();
		keys[key] = null;
		
		if (fast_manager.fast.is_active == false) {
			var menu = new MenuHandler();
			menu.openFastTypeMenu();
		} else {
		
			if (fast_manager.fast.is_complete == true) {
				var menu = new MenuHandler();
				menu.openFinishMenu();
			} else {
				var menu = new MenuHandler();
				menu.openCancelMenu();
			}
		
		}
	}
	
	//! If the key is released, we can assume that the timer has not 
	//! been triggered and ask the fast_manager for the next page.
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