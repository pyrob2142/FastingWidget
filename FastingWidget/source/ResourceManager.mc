using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.UserProfile;
using Toybox.System;
using Toybox.Application.Storage;
using Toybox.Time;
using Toybox.Time.Gregorian;


class ResourceManager {
	
	var toolbox;
	var fast_manager;
	var bitmap_burn;
	var longpress_threshold;
	var default_goal_hours;
	var default_goal_index;
	var arc_yellow_threshold;
	var arc_green_threshold;
	
	// User profile data
	var user;
	var activity_level;
	var weight;
	var height;
	var age;
	var gender;
	var bmi;
	
	// Fast data
	var fast_in_progress;
	var start_data_string;
	var goal_data;
	var streak;
	
	function initialize() {
		toolbox = Application.getApp().toolbox;
		fast_manager = Application.getApp().fast_manager;
		bitmap_burn = WatchUi.loadResource(Rez.Drawables.burn);
		
		user = UserProfile.getProfile();
		weight = toolbox.convertWeight(user.weight);
		height = user.height;
		gender = user.gender;
		bmi = toolbox.calculateBMI(weight, height);
		
		reloadSettings();
	}
	
	function reloadSettings() {
		longpress_threshold = Application.AppBase.getProperty("longpress_threshold");
		
		default_goal_index = Application.AppBase.getProperty("default_goal");
		
		arc_yellow_threshold = Application.AppBase.getProperty("arc_yellow_threshold") * 3600;
		arc_green_threshold = Application.AppBase.getProperty("arc_green_threshold") * 3600;
		streak = Application.AppBase.getProperty("streak").toNumber();
		
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


