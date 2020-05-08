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
        
        fast_manager.update();
        
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
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

	function drawStreak(dc) {
		var streak_label = fast_manager.getStreak();
	
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.clear();
		
		dc.drawText(center_x, center_y - 25 - dc.getFontHeight(Graphics.FONT_MEDIUM), Graphics.FONT_MEDIUM, "STREAK", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y, Graphics.FONT_NUMBER_HOT, streak_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y + 60, Graphics.FONT_MEDIUM, "SESSIONS", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
	}
	
	function drawFastWithoutGoal(dc) {
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.clear();
		
		var mode_label = "ELAPSED";
		var time_label = fast_manager.getElapsed();
		var start_label = toolbox.momentToString(fast_manager.getStartMoment(), true, true);
		
		dc.drawText(center_x, center_y - 46 - dc.getFontHeight(Graphics.FONT_TINY), Graphics.FONT_TINY, mode_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y - dc.getFontHeight(Graphics.FONT_LARGE), Graphics.FONT_MEDIUM, time_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
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
	
		dc.setPenWidth(10);
		
		var elapsed = fast_manager.fast.d_elapsed.value();
		
		if (elapsed >= arc_yellow_threshold) {
			arc_color = Graphics.COLOR_YELLOW;
		} else if (elapsed >= arc_green_threshold) {
			arc_color = Graphics.COLOR_GREEN;
		} else {
			arc_color = Graphics.COLOR_RED;
		}
		
		dc.setColor(arc_color, Graphics.COLOR_BLACK);
		dc.drawArc(center_x, center_y, 115, dc.ARC_CLOCKWISE, 90, arc_end);
	}
}
