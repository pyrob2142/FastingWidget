using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Math;

//! Provides a variety of useful functions, that aren't specific enough to fit
//! into a certain class.
class Toolbox {
	var resource_manager;
	
	function initialize() {
		
	}
	
	//! Converts weight from grams to kilograms.
	//! @param [Number] weight Weight in grams.
	//! @return [Number] Weight in kilograms.
	function convertWeight(weight) {
		return weight / 1000.0;
	}
	
	//! Converts height from centimeters to meters.
	//! @param [Number] height Height in centimeters.
	//! @return [Number] height in meters.
	function convertHeight(height) {
		return height / 100.0;
	}
	
	//! Calculates user age by taking the birthday in UNIX Epoch.
	//! Since the user profile is only storing the birth year,
	//! we calculate the exact age ourselves.
	//! @param [Number] birthday Birthday in UNIX Epoch.
	//! @return [Number] User age in years.
	function calculateAge(birthday) {
		var m_bday = new Time.Moment(birthday);
		var m_now = Time.now();
		
		var d_age = m_now.subtract(m_bday);
		
		return d_age.value() / Gregorian.SECONDS_PER_YEAR;
	}
	
	//! Calculates the user's BMI.
	//! @param [Number] weight Weight in kilogram.
	//! @param [Number] height Height in centimeters.
	//! @return [Number] BMI in kg/m^2.
	function calculateBMI(weight, height) {
		return weight / Math.pow(convertHeight(height), 2);
	}
	
	//! Converts seconds into DD:HH:MM or HH:MM:SS
	//! @param [Number] value Seconds to convert.
	//! @return [String] A pretty time string.
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
			return days.format("%02d") + resource_manager.symbol_days + " " + hours.format("%02d") 
				+ resource_manager.symbol_hours + " " + minutes.format("%02d") + resource_manager.symbol_minutes;
		} else {
			return hours.format("%02d") + resource_manager.symbol_hours + " " + minutes.format("%02d") 
				+ resource_manager.symbol_minutes + " " + seconds.format("%02d") + resource_manager.symbol_seconds;
		}
	}
	
	//! Creates a pretty date string from a Time.moment.
	//! @param [Time.Moment] moment The moment to be converted.
	//! @param [Boolean] year Set to true to include the year in the string.
	//! @param [Boolean] line_break Set to true to replace the comma with a new line.
	//! @return [String] A pretty date string.
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
	
	//! Calculates a Time.Moment a specific duration from Time.now() and returns it as a pretty string.
	//! @param [Number] hours Duration to add to current time in hours.
	//! @return [String] A pretty string representing a date in the future.
	function calculateDate(hours) {
		var duration = new Time.Duration(hours * 3600);
		var date = Time.now().add(duration);
		var date_info = Gregorian.info(date, Gregorian.FORMAT_MEDIUM); 
		return date_info.day_of_week + " " + momentToString(date, true, false);
	}
	
	//! Converts a duration in hours into a duration of pretty days.
	//! @param [Number] value Duration in hours.
	//! @return [String] A string of pretty days.
	function hoursToDays(value) {
		var days = value / 24;
		var hours = value % 24;
		
		var result;
		if (hours != 0) {
			result = days.format("%d") + "½ " + resource_manager.string_days;
		} else {
			result = days.format("%d") + " " + resource_manager.string_days;
		}
		return result;
	}
}