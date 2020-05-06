
class FastManager {
	enum {
		STREAK,
		ELAPSED,
		REMAINING,
		CALORIES
	}
	
	var current_page;
	
	function initialize() {
		current_page = STREAK;
	}
	
	function toggleFast() {
		System.println("FAST TOGGLE");
	}
	
	function nextPage() {
		current_page++;
		
		if (current_page > 3) {
			current_page = 0;
		}
		
		WatchUi.requestUpdate();
	}
	
	function getPage() {
		return current_page;
	}
	

}