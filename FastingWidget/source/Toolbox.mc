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
	
	// Calculate the age by taking birthday in UNIX Epoch
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
		
		if (hours < 10) {
			hours = "0" + hours;
		}
		
		if (minutes < 10) {
			minutes = "0" + minutes;
		}
		
		if (days > 0) {
			if (days < 10) {
				days = "0" + days;
			}
			
			return days + "D " + hours + "H " + minutes + "MIN";
			
		} else {
			if (seconds < 10) {
				seconds = "0" + seconds;
			}
				
			return hours + "H " + minutes + "MIN " + seconds + "S";
		}
	}
	
	function momentToString(moment, line_break) {
		var moment_info = Gregorian.info(moment, Time.FORMAT_SHORT);
		
		if (line_break) {
			return moment_info.day + "." + moment_info.month + "." + moment_info.year 
			+ "\n" + moment_info.hour + ":" + moment_info.min;
		} else {
			return moment_info.day + "." + moment_info.month + "." + moment_info.year 
			+ ", " + moment_info.hour + ":" + moment_info.min;
		}
	}
}