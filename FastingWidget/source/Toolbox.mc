using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Math;

class Toolbox {
	
	function initialize() {
	
	}
	
	// Convert weight from g to kg
	function convertWeight(weight) {
		return weight / 1000;
	}
	
	// Convert height from cm to m
	function convertHeight(height) {
		return height / 100;
	}
	
	// Calculate the age by taking birthday in UNIX Epoch
	function calculateAge(birthday) {
		var m_bday = new Time.Moment(birthday);
		var m_now = Time.now();
		
		var d_age = m_now.subtract(m_bday);
		
		return d_age / Time.SECONDS_PER_YEAR;
	}
	
	// Calculate BMI
	function calculateBMI(weight, height) {
		return weight / pow(convertHeight(height), 2);
	}
}