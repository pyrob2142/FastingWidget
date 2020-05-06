using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.UserProfile;

class ResourceManager {
	
	var toolbox;
	var bitmap_burn;
	var longpress_threshold;
	
	// User profile data
	var user;
	var activity_level;
	var weight;
	var height;
	var age;
	var gender;
	var bmi;
	
	function initialize() {
		toolbox = new Toolbox();
		bitmap_burn = WatchUi.loadResource(Rez.Drawables.burn);
		
		user = UserProfile.getProfile();
		weight = toolbox.convertWeight(user.weight);
		height = user.height;
		gender = user.gender;
		bmi = calculateBMI(weight, height);
		
		reloadSettings();
	}
	
	function reloadSettings() {
		longpress_threshold = Application.AppBase.getProperty("longpress_threshold");
		
		var raw_activity = Application.AppBase.getProperty("activity_level");
		if (raw_activity != null) {
			switch (raw_activity) {
				case 0:
					activity_level = 1.2;
					break;
				case 1:
					activity_level = 1.375;
					break;
				case 2:
					activity_level = 1.55;
					break;
				case 3: 
					activity_level = 1.725;
					break;
				case 4:
					activity_level = 1.9;
					break;
			}
		} else {
			activity_level = 1.2;
		}
		
		var birthday = Application.AppBase.getProperty("birthday");
		if (birthday != null) {
			age = toolbox.calculateAge(birthday);
		} else {
			age = 30;
		} 
	}
	
	
}


