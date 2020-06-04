// round-390x390

using Toybox.WatchUi;
using Toybox.Graphics;

class FastingView extends WatchUi.View {
	
	var resource_manager;
	var fast_manager;
	var toolbox;
	
	var center_x;
	var center_y;
	
	var streak_reset_threshold;
	var streak_inc_threshold;
	
    function initialize() {
        View.initialize();
        fast_manager = Application.getApp().fast_manager;
        resource_manager = Application.getApp().resource_manager;
        toolbox = Application.getApp().toolbox;
        streak_reset_threshold = resource_manager.streak_reset_threshold;
        streak_inc_threshold = resource_manager.streak_inc_threshold;
    }

    // Load your resources here
    function onLayout(dc) {
        center_x = dc.getWidth() / 2;
        center_y = dc.getHeight() / 2;
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        
        switch (fast_manager.getPage()) {
        	case fast_manager.STREAK:
        		drawStreak(dc);
        		break;
        	
        	case fast_manager.ELAPSED:
        		drawFastWithGoal(dc, false);
        		break;
        	
        	case fast_manager.REMAINING: 
        		drawFastWithGoal(dc, true);
        		break;
        		
        	case fast_manager.OPEN:
        		drawFastWithoutGoal(dc);
        		break;
        	
        	case fast_manager.CALORIES:
        		drawCalories(dc);
        		break;
        		
        	case fast_manager.SUMMARY:
        		drawSummary(dc);
        		break;
        	
        	case fast_manager.STREAKINC:
        		drawStreakIncrement(dc);
        		break;
        		
        	case fast_manager.STREAKRES:
        		drawStreakReset(dc);
        		break;
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	
    }
    
    
    //! Draws the summary of the last fast, e.g. total time and calories
    //! @param [Object] dc Device Context
    function drawSummary(dc) {
    	
    	var duration_label = fast_manager.getElapsed();
    	var calories_label = fast_manager.getCalories().format("%.1f");
    	
    	dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.clear();
		
		dc.drawText(center_x, center_y - 120, Graphics.FONT_SMALL, resource_manager.string_summary.toUpper(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y - 60, Graphics.FONT_TINY, resource_manager.string_duration.toUpper(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y - 15, Graphics.FONT_MEDIUM, duration_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y + 50, Graphics.FONT_TINY, resource_manager.string_calories.toUpper(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y + 95, Graphics.FONT_MEDIUM, calories_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		
		drawProgressArc(dc);
    }
    
    //! Draws the reward screen, where your current streak is increased by 1, after a successful fast
    //! @param [Object] dc Device Context
    function drawStreakIncrement(dc) {
    	var streak = fast_manager.streak;
    	
    	dc.clear();
		
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.drawText(center_x, center_y + 30, Graphics.FONT_NUMBER_HOT, streak, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

		dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
		dc.drawText(center_x, center_y - 60, Graphics.FONT_NUMBER_MILD, streak + 1, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.drawText(center_x, center_y - 120, Graphics.FONT_SMALL, resource_manager.string_streak.toUpper(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		
		if (streak > 0) {
			dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
			dc.drawText(center_x, center_y + 124, Graphics.FONT_NUMBER_MILD, streak - 1, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		}
		
		drawProgressArc(dc);
    }
    
    //! Draws the "punishment" screen, where your streak is reset to zero, after you cancel a fast.
    //! Just don't cancel your fasts and you will be fine.
    //! @param [Object] dc Device Context
    function drawStreakReset(dc) {
    	var streak = fast_manager.streak_old;
    	
    	dc.clear();
	
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.drawText(center_x, center_y - 10, Graphics.FONT_NUMBER_THAI_HOT, "0", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.drawText(center_x, center_y - 120, Graphics.FONT_SMALL, resource_manager.string_streak.toUpper(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		
		dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
		dc.drawText(center_x, center_y + 115, Graphics.FONT_NUMBER_MEDIUM, streak, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		
		drawProgressArc(dc);
    }

 	//! Draws the current streak view
    //! @param [Object] dc Device Context
	function drawStreak(dc) {
		var streak_label = fast_manager.streak;
		
		var fast_label = resource_manager.string_fast_pl.toUpper();
		
		if (streak_label == 1) {
			fast_label = resource_manager.string_fast_sg.toUpper();
		}
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.clear();
		
		dc.drawText(center_x, center_y - 25 - dc.getFontHeight(Graphics.FONT_MEDIUM), Graphics.FONT_MEDIUM, resource_manager.string_streak.toUpper(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y, Graphics.FONT_NUMBER_HOT, streak_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		if (resource_manager.nominalization == true) {
			fast_label = "x " + fast_label;
		}
		dc.drawText(center_x, center_y + 80, Graphics.FONT_MEDIUM, fast_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
	}
	
	//! Draws the elapsed screen for fasts without a set goal. Start date and time are split into two rows. 
	//! The progress arc will still change colors according to the user settings, but will remain full at all times.
    //! @param [Object] dc Device Context
	function drawFastWithoutGoal(dc) {
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.clear();
		
		var mode_label = resource_manager.string_elapsed.toUpper();
		var time_label = fast_manager.getElapsed().toUpper();
		var start_label = toolbox.momentToString(fast_manager.getStartMoment(), true);
		
		dc.drawText(center_x, center_y - 120, Graphics.FONT_TINY, mode_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y - 60, Graphics.FONT_MEDIUM, time_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y, Graphics.FONT_TINY, resource_manager.string_since.toUpper(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y + 90, Graphics.FONT_MEDIUM, start_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
	
		drawProgressArc(dc);
	}
	
	//! Draws the elapsed or remaining screen and shows the current progress of the fast both with an arc and as a number.
    //! @param [Object] dc Device Context
	function drawFastWithGoal(dc, show_remaining) {
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.clear();
		
		var mode_label = resource_manager.string_elapsed.toUpper();
		var conjunction = resource_manager.string_since.toUpper();
		var time_label = fast_manager.getElapsed().toUpper();
		var date_label = toolbox.momentToString(fast_manager.getStartMoment(), false).toUpper();
		
		if (show_remaining == true) {
			mode_label = resource_manager.string_remaining.toUpper();
			conjunction = resource_manager.string_until.toUpper();
			
			if (fast_manager.getProgress() > 1.0) {
				mode_label = resource_manager.string_overtime.toUpper();
				conjunction = resource_manager.string_since.toUpper();
			}
			
			time_label = fast_manager.getRemaining().toUpper();
			date_label = toolbox.momentToString(fast_manager.getGoalMoment(), false).toUpper();
		}
		
		
		var progress = fast_manager.getProgress();
		var progress_label = (progress * 100.0).format("%.1f") + "%";
		
		dc.drawText(center_x, center_y - 120, Graphics.FONT_TINY, mode_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y - 60, Graphics.FONT_MEDIUM, time_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y, Graphics.FONT_TINY, conjunction, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y + 60, Graphics.FONT_MEDIUM, date_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y + 124, Graphics.FONT_MEDIUM, progress_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		
		drawProgressArc(dc);
	}
	
	//! Draws the current calories.
    //! @param [Object] dc Device Context
	function drawCalories(dc) {
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.clear();
		
		var calories_label = fast_manager.getCalories().format("%.1f");
		
		dc.drawText(center_x, center_y + 10, Graphics.FONT_NUMBER_HOT, calories_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawBitmap(center_x - 32, center_y - 140, resource_manager.bitmap_burn);
		dc.drawText(center_x, center_y + 115, Graphics.FONT_MEDIUM, resource_manager.string_kcal.toUpper(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
	}
	
	//! Draws the progess arc according to the percentage of completion. The colors represent a traffic light system,
	//! the user can choose when it turns from red to yellow and green. If the fast is cancelled during the yellow stage, 
	//! the streak will not increase, but will not be reset either. Once it turns green the user receives an A for effort and the 
	//! streak will be increased as well.
    //! @param [Object] dc Device Context
	function drawProgressArc(dc) {
		var has_goal = fast_manager.fast.has_goal;
		var percent = 1.0;
		var degrees;
		var arc_end;
		var arc_color;
		
		if (has_goal == true) {
			percent = fast_manager.getProgress();
			
			degrees = 360 * percent;
			
			if (percent > 1.0) {
				degrees = 360;
			}
			
			if (percent == 0.0) {
				degrees = 1;
			}
			
			if (degrees < 90) {
				arc_end = 90 - degrees;
			} else {
				arc_end = 360 - (degrees - 90);
			}
		
			if (percent >= streak_inc_threshold) {
				arc_color = Graphics.COLOR_GREEN;
			} else if (percent >= streak_reset_threshold) {
				arc_color = Graphics.COLOR_YELLOW;
			} else {
				arc_color = Graphics.COLOR_RED;
			}
		} else {
			arc_end = 90;
			arc_color = Graphics.COLOR_BLUE;
		}
		
		dc.setPenWidth(12);
		dc.setColor(arc_color, Graphics.COLOR_BLACK);
		dc.drawArc(center_x, center_y, dc.getHeight() / 2, dc.ARC_CLOCKWISE, 90, arc_end);
	}
}
