using Toybox.WatchUi;
using Toybox.Graphics;

class FastingView extends WatchUi.View {
	
	var resource_manager;
	var fast_manager;
	var toolbox;
	
	var center_x;
	var center_y;
	
	var arc_yellow_threshold;
	var arc_green_threshold;
	
    function initialize() {
        View.initialize();
        fast_manager = Application.getApp().fast_manager;
        resource_manager = Application.getApp().resource_manager;
        toolbox = Application.getApp().toolbox;
        arc_yellow_threshold = resource_manager.arc_yellow_threshold;
        arc_green_threshold = resource_manager.arc_green_threshold;
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
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
    
    function drawSummary(dc) {
    	
    	var duration_label = fast_manager.getElapsed();
    	var calories_label = fast_manager.getCalories().format("%.1f");
    	
    	dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.clear();
		
		dc.drawText(center_x, center_y - 70, Graphics.FONT_SMALL, "SUMMARY", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y - 30, Graphics.FONT_TINY, "DURATION", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y, Graphics.FONT_MEDIUM, duration_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y + 40, Graphics.FONT_TINY, "CALORIES", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y + 70, Graphics.FONT_MEDIUM, calories_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		
		var arc_color;
		
		if (fast_manager.fast.is_complete == true) {
			arc_color = Graphics.COLOR_GREEN;
		} else {
			arc_color = Graphics.COLOR_RED;
		}
		
		dc.setColor(arc_color, Graphics.COLOR_BLACK);
		dc.setPenWidth(7);
		dc.drawArc(center_x, center_y, 118, dc.ARC_CLOCKWISE, 0, 360);
    }
    
    function drawStreakIncrement(dc) {
    	var streak = fast_manager.streak;
    	
    	dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.clear();
		
		dc.drawText(center_x, center_y - 70, Graphics.FONT_SMALL, "STREAK", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		
		dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
		dc.drawText(center_x, center_y - 30, Graphics.FONT_NUMBER_MILD, streak + 1, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.drawText(center_x, center_y + 20, Graphics.FONT_NUMBER_HOT, streak, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		
		if (streak > 0) {
			dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
			dc.drawText(center_x, center_y + 70, Graphics.FONT_NUMBER_MILD, streak - 1, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		}
		
		dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
		dc.setPenWidth(7);
		dc.drawArc(center_x, center_y, 118, dc.ARC_CLOCKWISE, 0, 360);
    }
    
    function drawStreakReset(dc) {
    	var streak = fast_manager.streak_old;
    	
    	dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.clear();
		
		dc.drawText(center_x, center_y - 70, Graphics.FONT_SMALL, "STREAK", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
	
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.drawText(center_x, center_y - 10, Graphics.FONT_NUMBER_THAI_HOT, "0", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		
		dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
		dc.drawText(center_x, center_y + 60, Graphics.FONT_NUMBER_MEDIUM, streak, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		
		dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
		dc.setPenWidth(7);
		dc.drawArc(center_x, center_y, 118, dc.ARC_CLOCKWISE, 0, 360);
    }

	function drawStreak(dc) {
		var streak_label = fast_manager.streak;
		var fast_label = "FASTS";
		
		if (streak_label == 1) {
			fast_label = "FAST";
		}
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.clear();
		
		dc.drawText(center_x, center_y - 25 - dc.getFontHeight(Graphics.FONT_MEDIUM), Graphics.FONT_MEDIUM, "STREAK", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y, Graphics.FONT_NUMBER_HOT, streak_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y + 60, Graphics.FONT_MEDIUM, fast_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
	}
	
	function drawFastWithoutGoal(dc) {
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.clear();
		
		var mode_label = "ELAPSED";
		var time_label = fast_manager.getElapsed();
		var start_label = toolbox.momentToString(fast_manager.getStartMoment(), true, true);
		
		dc.drawText(center_x, center_y - 46 - dc.getFontHeight(Graphics.FONT_TINY), Graphics.FONT_TINY, mode_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y - dc.getFontHeight(Graphics.FONT_MEDIUM) - 2, Graphics.FONT_MEDIUM, time_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y, Graphics.FONT_TINY, "SINCE", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y + 55, Graphics.FONT_MEDIUM, start_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		
		drawProgressArc(dc, 1.0);
	}
	
	function drawFastWithGoal(dc, show_remaining) {
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.clear();
		
		var mode_label = "ELAPSED";
		var time_label = fast_manager.getElapsed();
		
		if (show_remaining == true) {
			mode_label = "REMAINING";
			time_label = fast_manager.getRemaining();
		}
		
		var end_label = toolbox.momentToString(fast_manager.getGoalMoment(), true, false);
		var progress = fast_manager.getProgress();
		var progress_label = (progress * 100.0).format("%.1f") + "%";
		
		dc.drawText(center_x, center_y - 46 - dc.getFontHeight(Graphics.FONT_TINY), Graphics.FONT_TINY, mode_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y - dc.getFontHeight(Graphics.FONT_LARGE), Graphics.FONT_MEDIUM, time_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y, Graphics.FONT_TINY, "UNTIL", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y + 36, Graphics.FONT_MEDIUM, end_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y + 75, Graphics.FONT_MEDIUM, progress_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		
		drawProgressArc(dc, progress);
	}
	
	function drawCalories(dc) {
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.clear();
		
		var calories_label = fast_manager.getCalories().format("%.1f");
		
		dc.drawBitmap(center_x - 32, center_y - 100, resource_manager.bitmap_burn);
		dc.drawText(center_x, center_y + 10, Graphics.FONT_NUMBER_HOT, calories_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y + 70, Graphics.FONT_MEDIUM, "KCAL", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
	}
	
	function drawProgressArc(dc, percent) {
		var degrees = 360 * percent;
		var arc_end = 0;
		var arc_color;
		
		if (degrees < 90) {
			arc_end = 90 - degrees;
		} else {
			arc_end = 360 - (degrees - 90);
		}
	
		dc.setPenWidth(7);
		
		var elapsed = fast_manager.fast.d_elapsed.value();
		
		if (elapsed >= arc_yellow_threshold) {
			arc_color = Graphics.COLOR_YELLOW;
		} else if (elapsed >= arc_green_threshold) {
			arc_color = Graphics.COLOR_GREEN;
		} else {
			arc_color = Graphics.COLOR_RED;
		}
		
		dc.setColor(arc_color, Graphics.COLOR_BLACK);
		dc.drawArc(center_x, center_y, 118, dc.ARC_CLOCKWISE, 90, arc_end);
	}
}
