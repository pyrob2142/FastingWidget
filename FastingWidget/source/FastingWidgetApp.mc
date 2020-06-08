using Toybox.Application;

class FastingWidgetApp extends Application.AppBase {
	static var fast_manager;
	static var resource_manager;
	static var toolbox;
	
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
 
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    	
    }

    // Return the initial view of your application here
    function getInitialView() {
    	toolbox = new Toolbox();
        resource_manager = new ResourceManager();
        fast_manager = new FastManager();
        return [ new FastingView(), new FastingViewDelegate() ];
    }
        
    (:glance)
    function getGlanceView() {
    	return [ new FastingGlanceView() ];
    }

}