
class ResourceManager {
	
	var bitmap_burn;
	var longpress_threshold;
	function initialize() {
		bitmap_burn = WatchUi.loadResource(Rez.Drawables.burn);
		load();
	}
	
	function load() {
		longpress_threshold = Application.AppBase.getProperty("longpress_threshold");
	}
	
	
}


