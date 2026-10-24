using Toybox.System;
using Toybox.Timer;
using Toybox.WatchUi;

//! Handles the page navigation and long press menus.
class FastingViewDelegate extends WatchUi.BehaviorDelegate {
    var fast_manager;
    var resource_manager;
    
    function initialize() {
        BehaviorDelegate.initialize();
        fast_manager = Application.getApp().fast_manager;
        resource_manager = Application.getApp().resource_manager;
    }
    
    // Triggered by Start/Select button (Fenix) or Screen Tap (Venu)
    function onSelect() {
        fast_manager.nextPage();
        return true;
    }
    
    // Triggered by Down button (Fenix) or Downward Swipe (Venu)
    function onNextPage() {
        fast_manager.nextPage();
        return true;
    }
    
    // Triggered by Up button (Fenix) or Upward Swipe (Venu)
    function onPreviousPage() {
        fast_manager.nextPage();
        return true;
    }
    
    // Triggered by Long-Press Menu (Fenix) or Press-and-Hold / Secondary Button (Venu)
    function onMenu() {
        handleLongPress();
        return true;
    }
    
    // Explicit Touch Hold fallback for touch-first watches
    function onHold(evt) {
        handleLongPress();
        return true;
    }

    // Intercept low-level key events to stop CIQ 3.1 (fēnix 5) from passing unhandled key codes
    function onKey(evt) {
        var key = evt.getKey();
        if (key == WatchUi.KEY_DOWN || key == WatchUi.KEY_UP) {
            fast_manager.nextPage();
            return true; // Return true to signal the key press was completely handled
        }
        return false;
    }
    
    function handleLongPress() {
        if (fast_manager.fast.is_active == false) {
            var menu = new MenuHandler();
            menu.openFastTypeMenu();
        } else {
            if (fast_manager.fast.is_complete == true) {
                var menu = new MenuHandler();
                if (fast_manager.fast.has_goal == true) {
                    menu.openFinishMenu();
                } else {
                    menu.openOptionsMenu();
                }
            } else {
                var menu = new MenuHandler();
                menu.openCancelMenu();
            }
        }
    }
}