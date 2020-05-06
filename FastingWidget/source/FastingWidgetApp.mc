using Toybox.Application;

class FastingWidgetApp extends Application.AppBase {
	var fast_manager;
	var resource_manager;
	
    function initialize() {
        AppBase.initialize();
        fast_manager = new FastManager();
        resource_manager = new ResourceManager();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new FastingView(), new FastingViewDelegate() ];
    }
    
    function onSettingsChanged() {
    	resource_manager.load();
    }

}