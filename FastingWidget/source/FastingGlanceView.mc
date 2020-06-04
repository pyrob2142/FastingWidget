using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Application.Storage;
using Toybox.Time;
using Toybox.Timer;

(:glance)
class FastingGlanceView extends WatchUi.GlanceView {
	var streak_data;
	var is_active;
	var start_data;
	var m_start;
	var goal_data;
	var d_goal;
	var elapsed;
	var remaining;
	var string_streak;
	var string_elapsed;
	var string_remaining;
	var time_format;
	var show_days;
	var symbol_days;
	var symbol_hours;
	var symbol_minutes;
	var symbol_seconds;
	var m_now;
	var timer;
	
	function initialize() {
		GlanceView.initialize();
		load();
		
		if (is_active == true) {
			timer = new Timer.Timer();
			timer.start(me.method(:update), 1000, true);
		}
	}
	
	function onUpdate(dc) {
		var center_y = dc.getHeight() / 2;
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		
		if (is_active == false) {
			dc.drawText(0, center_y - Graphics.getFontHeight(Graphics.FONT_SMALL) / 2, Graphics.FONT_SMALL, string_streak + ": " + streak_data, Graphics.TEXT_JUSTIFY_LEFT);
		} else {
			m_now = Time.now();
			elapsed = m_now.subtract(m_start);
			
			if (goal_data != -1) {
				remaining = d_goal.subtract(elapsed);
				dc.drawText(0, 5, Graphics.FONT_XTINY, string_remaining + ":", Graphics.TEXT_JUSTIFY_LEFT);
				dc.drawText(0, dc.getHeight() - 5 - Graphics.getFontHeight(Graphics.FONT_SMALL), Graphics.FONT_TINY, convertSeconds(remaining.value()), Graphics.TEXT_JUSTIFY_LEFT);
				
			} else {	
				dc.drawText(0, 5, Graphics.FONT_XTINY, string_elapsed + ":", Graphics.TEXT_JUSTIFY_LEFT);
				dc.drawText(0, dc.getHeight() - 5 - Graphics.getFontHeight(Graphics.FONT_SMALL), Graphics.FONT_TINY, convertSeconds(elapsed.value()), Graphics.TEXT_JUSTIFY_LEFT);
				
			}
		}
	}
	
	function load() {
		streak_data = Application.AppBase.getProperty("streak_data").toNumber();
	
		is_active = Storage.getValue("is_active");
		if (is_active == null) {
			is_active = false;
		}
		
		start_data = Storage.getValue("start_data");
		if (start_data == -1 || start_data == null) {
			start_data = -1;
		} else {
			m_start = new Time.Moment(start_data);
		}
		
		goal_data = Storage.getValue("goal_data");
		System.println(goal_data);
		if (goal_data == -1 || goal_data == null) {
			goal_data = -1;
		} else {
			d_goal = new Time.Duration(goal_data);
		}
		
		string_streak = WatchUi.loadResource(Rez.Strings.streak);
		string_elapsed = WatchUi.loadResource(Rez.Strings.elapsed);
		string_remaining = WatchUi.loadResource(Rez.Strings.remaining);
		time_format = Application.AppBase.getProperty("time_format");
		show_days = Application.AppBase.getProperty("show_days");
		symbol_days = WatchUi.loadResource(Rez.Strings.symbol_days);
		symbol_hours = WatchUi.loadResource(Rez.Strings.symbol_hours);
		symbol_minutes = WatchUi.loadResource(Rez.Strings.symbol_minutes);
		symbol_seconds = WatchUi.loadResource(Rez.Strings.symbol_seconds);
		
	}
	
	function convertSeconds(value) {
		var n = value;
		
		if (time_format == 0) {
			if (n / 3600 >= show_days) {
				var days = n / (24 * 3600);
				n = n % (24 * 3600);
				
				var hours = n / 3600;
				n = n % 3600;
				
				var minutes = n / 60;
				n = n % 60;
				
				var seconds = n;
				return days.format("%02d") + symbol_days + " " + hours.format("%02d") 
					+ symbol_hours + " " + minutes.format("%02d") + symbol_minutes;
			} else {
				var hours = n / 3600;
				n = n % 3600;
				
				var minutes = n / 60;
				n = n % 60;
				
				var seconds = n;
				return hours.format("%02d") + symbol_hours + " " + minutes.format("%02d") 
					+ symbol_minutes + " " + seconds.format("%02d") + symbol_seconds;
			}
		} else {
			if (n / 3600 >= show_days) {
				var days = n / (24 * 3600);
				n = n % (24 * 3600);
				
				var hours = n / 3600;
				n = n % 3600;
				
				var minutes = n / 60;
				n = n % 60;
				
				var seconds = n;
				return days.format("%02d") + ":" + hours.format("%02d") + ":" + minutes.format("%02d") + ":" + seconds.format("%02d");
			} else {
				var hours = n / 3600;
				n = n % 3600;
				
				var minutes = n / 60;
				n = n % 60;
				
				var seconds = n;
				return hours.format("%02d") + ":" + minutes.format("%02d") + ":" + seconds.format("%02d");
			}
		}
	}
	
	function update() {
		System.println("Time.");
		WatchUi.requestUpdate();
	}
}