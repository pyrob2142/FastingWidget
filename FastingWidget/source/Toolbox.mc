using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Math;

class Toolbox {
	
	function initialize() {
	
	}
	
	// Convert weight from g to kg
	function convertWeight(weight) {
		return weight / 1000.0;
	}
	
	// Convert height from cm to m
	function convertHeight(height) {
		return height / 100.0;
	}
	
	// Calculate user age by taking birthday in UNIX epoch
	function calculateAge(birthday) {
		var m_bday = new Time.Moment(birthday);
		var m_now = Time.now();
		
		var d_age = m_now.subtract(m_bday);
		
		return d_age.value() / Gregorian.SECONDS_PER_YEAR;
	}
	
	// Calculate BMI
	function calculateBMI(weight, height) {
		return weight / Math.pow(convertHeight(height), 2);
	}
	
	// Convert seconds into DD:HH:MM or HH:MM:SS
	function convertSeconds(value) {
		var n = value;
		
		var days = n / (24 * 3600);
		n = n % (24 * 3600);
		
		var hours = n / 3600;
		n = n % 3600;
		
		var minutes = n / 60;
		n = n % 60;
		
		var seconds = n;
		
		if (days > 0) {
			return days.format("%02d") + "D " + hours.format("%02d") + "H " + minutes.format("%02d") + "MIN";
		} else {
			return hours.format("%02d") + "H " + minutes.format("%02d") + "MIN " + seconds.format("%02d") + "S";
		}
	}
	
	function momentToString(moment, year, line_break) {
		var moment_info = Gregorian.info(moment, Time.FORMAT_SHORT);
		
		var date_string;
		
		if (year == true) {
			date_string = moment_info.day.format("%02d") + "."
				+ moment_info.month.format("%02d") + "." + moment_info.year.toString().substring(2,4);
		} else {
			date_string = moment_info.day.format("%02d") + "."
				+ moment_info.month.format("%02d") + ".";
		}	 
		var time_string = moment_info.hour.format("%02d") + ":" + moment_info.min.format("%02d");
		
		if (line_break) {
			return date_string + "\n" + time_string;
		} else {
			return date_string + ", " + time_string;
		}
	}
	
	function calculateDate(hours) {
		var duration = new Time.Duration(hours * 3600);
		var date = Time.now().add(duration);
		var date_info = Gregorian.info(date, Gregorian.FORMAT_MEDIUM); 
		return date_info.day_of_week + " " + momentToString(date, true, false);
	}
	
	function hoursToDays(value) {
		var days = value / 24;
		var hours = value % 24;
		
		var result;
		if (hours != 0) {
			result = days.format("%d") + " 1/2 Days";
		} else {
			result = days.format("%d") + " Days";
		}
		return result;
	}
}