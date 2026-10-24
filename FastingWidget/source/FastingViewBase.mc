//! Shared rendering logic for device-specific fasting view layouts.

using Toybox.WatchUi;
using Toybox.Graphics;

class FastingViewBase extends WatchUi.View {
	
	var resource_manager;
	var fast_manager;
	var toolbox;
	
	var center_x;
	var center_y;
	
	var streak_reset_threshold;
	var streak_inc_threshold;
	var layout;
	var pen_width_regular;
	var pen_width_overtime;
	var pen_width_streak_goal;
	var calories_icon_offset_x;
	var calories_icon_offset_y;
	
    function initialize() {
        View.initialize();
        fast_manager = Application.getApp().fast_manager;
        resource_manager = Application.getApp().resource_manager;
        toolbox = Application.getApp().toolbox;
        streak_reset_threshold = resource_manager.streak_reset_threshold;
        streak_inc_threshold = resource_manager.streak_inc_threshold;
    }

    function configureLayout() {
        layout = {
            :summary_title => [-70, Graphics.FONT_SMALL],
            :summary_duration => [-30, Graphics.FONT_TINY],
            :summary_duration_value => [0, Graphics.FONT_MEDIUM],
            :summary_calories => [40, Graphics.FONT_TINY],
            :summary_calories_value => [70, Graphics.FONT_MEDIUM],
            :streak_increment_title => [-70, Graphics.FONT_SMALL],
            :streak_increment_next => [-30, Graphics.FONT_NUMBER_MILD],
            :streak_increment_current => [20, Graphics.FONT_NUMBER_HOT],
            :streak_increment_previous => [70, Graphics.FONT_NUMBER_MILD],
            :streak_reset_zero => [-10, Graphics.FONT_NUMBER_THAI_HOT],
            :streak_reset_title => [-70, Graphics.FONT_SMALL],
            :streak_reset_previous => [60, Graphics.FONT_NUMBER_MEDIUM],
            :streak_title => [-25, Graphics.FONT_MEDIUM],
            :streak_value => [0, Graphics.FONT_NUMBER_HOT],
            :streak_value_fallback => [0, Graphics.FONT_LARGE],
            :streak_last_fast => [60, Graphics.FONT_SMALL],
            :streak_fast_label => [60, Graphics.FONT_MEDIUM],
            :open_mode => [-70, Graphics.FONT_TINY],
            :open_time => [-36, Graphics.FONT_MEDIUM],
            :open_since => [0, Graphics.FONT_TINY],
            :open_start => [52, Graphics.FONT_MEDIUM],
            :goal_mode => [-70, Graphics.FONT_TINY],
            :goal_time => [-36, Graphics.FONT_MEDIUM],
            :goal_conjunction => [0, Graphics.FONT_TINY],
            :goal_date => [36, Graphics.FONT_MEDIUM],
            :goal_progress => [75, Graphics.FONT_MEDIUM],
            :calories_value => [15, Graphics.FONT_NUMBER_HOT],
            :calories_units => [70, Graphics.FONT_MEDIUM]
        };
        pen_width_regular = 8;
        pen_width_overtime = 18;
        pen_width_streak_goal = 6;
        calories_icon_offset_x = -32;
        calories_icon_offset_y = -90;
    }

    function drawLayoutText(dc, key, text) {
        var item = layout[key];
        dc.drawText(center_x, center_y + item[0], item[1], text, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function drawLayoutTextAboveFontHeight(dc, key, text) {
        var item = layout[key];
        dc.drawText(center_x, center_y + item[0] - dc.getFontHeight(item[1]), item[1], text, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function clearView(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
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
    	
    	clearView(dc);
		
		drawLayoutText(dc, :summary_title, resource_manager.string_summary.toUpper());
		drawLayoutText(dc, :summary_duration, resource_manager.string_duration.toUpper());
		drawLayoutText(dc, :summary_duration_value, duration_label);
		drawLayoutText(dc, :summary_calories, resource_manager.string_calories.toUpper());
		drawLayoutText(dc, :summary_calories_value, calories_label);
		
		drawProgressArc(dc);
    }
    
    //! Draws the reward screen, where your current streak is increased by 1, after a successful fast
    //! @param [Object] dc Device Context
    function drawStreakIncrement(dc) {
    	var streak = fast_manager.streak;
    	
    	clearView(dc);
		
		drawLayoutText(dc, :streak_increment_title, resource_manager.string_streak.toUpper());
		
		dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
		drawLayoutText(dc, :streak_increment_next, streak + 1);
		
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		drawLayoutText(dc, :streak_increment_current, streak);
		
		if (streak > 0) {
			dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
			drawLayoutText(dc, :streak_increment_previous, streak - 1);
		}
		
		drawProgressArc(dc);
    }
    
    //! Draws the "punishment" screen, where your streak is reset to zero, after you cancel a fast.
    //! Just don't cancel your fasts and you will be fine.
    //! @param [Object] dc Device Context
    function drawStreakReset(dc) {
    	var streak = fast_manager.streak_old;
    	
    	clearView(dc);
		
		drawLayoutText(dc, :streak_reset_title, resource_manager.string_streak.toUpper());
	
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		drawLayoutText(dc, :streak_reset_zero, "0");
		
		dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
		drawLayoutText(dc, :streak_reset_previous, streak);
		
		drawProgressArc(dc);
    }

 	//! Draws the current streak view
    //! @param [Object] dc Device Context
	function drawStreak(dc) {
		var streak_label = fast_manager.streak.toString();
		var streak_font = layout[:streak_value][1];
		var streak_fallback_font = layout[:streak_value_fallback][1];
		var streak_goal = resource_manager.streak_goal;
		
		if (streak_goal > 0) {
			streak_label = streak_label + "/" + resource_manager.streak_goal;
		}

		if (dc.getTextWidthInPixels(streak_label, streak_font) > dc.getWidth() - 15) {
			streak_font = streak_fallback_font;
		}
		
		clearView(dc);
			
		drawLayoutTextAboveFontHeight(dc, :streak_title, resource_manager.string_streak.toUpper());
		var streak_layout = layout[:streak_value];
		dc.drawText(center_x, center_y + streak_layout[0], streak_font, streak_label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		
		if (fast_manager.fast.is_active == false && resource_manager.show_time_since_last == true) {
			var last_fast = fast_manager.getTimeSinceLastFast().toUpper();
			var last_fast_label = resource_manager.string_since.toUpper();
				
			drawLayoutText(dc, :streak_last_fast, last_fast);
		} else {
			var fast_label = resource_manager.string_fast_pl.toUpper();
		
			if (streak_label.equals("1")) {
				fast_label = resource_manager.string_fast_sg.toUpper();
			}
			
			if (resource_manager.nominalization == true) {
					fast_label = "x " + fast_label;
			}
			
			drawLayoutText(dc, :streak_fast_label, fast_label);
		}
		
		if (streak_goal > 0) {
			drawStreakGoalProgress(dc);
		}
	}
	
	//! Draws the elapsed screen for fasts without a set goal. Start date and time are split into two rows. 
	//! The progress arc will still change colors according to the user settings, but will remain full at all times.
    //! @param [Object] dc Device Context
	function drawFastWithoutGoal(dc) {
		clearView(dc);
		
		var mode_label = resource_manager.string_elapsed.toUpper();
		var time_label = fast_manager.getElapsed().toUpper();
		var start_label = toolbox.momentToString(fast_manager.getStartMoment(), true);
		
		drawLayoutText(dc, :open_mode, mode_label);
		drawLayoutText(dc, :open_time, time_label);
		drawLayoutText(dc, :open_since, resource_manager.string_since.toUpper());
		drawLayoutText(dc, :open_start, start_label);
		drawProgressArc(dc);
	}
	
	//! Draws the elapsed or remaining screen and shows the current progress of the fast both with an arc and as a number.
    //! @param [Object] dc Device Context
	function drawFastWithGoal(dc, show_remaining) {
		clearView(dc);
		
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
		
		drawLayoutText(dc, :goal_mode, mode_label);
		drawLayoutText(dc, :goal_time, time_label);
		drawLayoutText(dc, :goal_conjunction, conjunction);
		drawLayoutText(dc, :goal_date, date_label);
		drawLayoutText(dc, :goal_progress, progress_label);
		
		drawProgressArc(dc);
	}
	
	//! Draws the current calories.
    //! @param [Object] dc Device Context
	function drawCalories(dc) {
		clearView(dc);
		
		var calories_label = fast_manager.getCalories().format("%.1f");
		
		if (calories_icon_offset_x != null) {
			dc.drawBitmap(center_x + calories_icon_offset_x, center_y + calories_icon_offset_y, resource_manager.bitmap_burn);
		}
		drawLayoutText(dc, :calories_value, calories_label);
		drawLayoutText(dc, :calories_units, resource_manager.string_kcal.toUpper());
	}
	
	//! Draws the progess arc according to the percentage of completion. The colors represent a traffic light system,
	//! the user can choose when it turns from red to yellow and green. If the fast is cancelled during the yellow stage, 
	//! the streak will not increase, but will not be reset either. Once it turns green the user receives an A for effort and the 
	//! streak will be increased as well.
    //! @param [Object] dc Device Context
	function drawProgressArc(dc) {
		var has_goal = fast_manager.fast.has_goal;
		var percent = 1.0;
		var degrees_arc_start;
		var arc_start = 0;
		var degrees_progress = 0;
		var degrees_overtime = 0;
		var arc_end;
		var arc_end_overtime = null;
		var arc_color;
		
		if (has_goal == true) {
		
			percent = fast_manager.getProgress();
			
			if (percent > 1.0) {
				degrees_overtime = 360 * (percent - 1.0);
				
				if (percent > 2.0) {
					degrees_overtime = 360;
				}
				
				if (degrees_overtime < 90) {
					arc_end_overtime = 90 - degrees_overtime;
				} else {
					arc_end_overtime = 360 - (degrees_overtime - 90);
				}
				
				dc.setPenWidth(pen_width_regular);
				dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_TRANSPARENT);
				dc.drawArc(center_x, center_y, dc.getHeight() / 2, dc.ARC_CLOCKWISE, 90, 90);
				
				dc.setPenWidth(pen_width_overtime);
				dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
				dc.drawArc(center_x, center_y, dc.getHeight() / 2, dc.ARC_CLOCKWISE, 90, arc_end_overtime);	
			} else {
				
				if (resource_manager.single_color_progress == false) {
					if (percent == 0.0) {
						degrees_progress = 1;
					}
					
					degrees_progress = 360 * percent;
					
					if (degrees_progress < 90) {
						arc_end = 90 - degrees_progress;
					} else {
						arc_end = 360 - (degrees_progress - 90);
					}
					
					dc.setPenWidth(pen_width_regular);
					dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
					dc.drawArc(center_x, center_y, dc.getHeight() / 2, dc.ARC_CLOCKWISE, 90, arc_end);
					
					if (percent >= streak_reset_threshold) {
						degrees_progress = 360 * (percent - streak_reset_threshold);
						
						degrees_arc_start = 360 * streak_reset_threshold;
						
						if (degrees_arc_start < 90) {
							arc_start = 90 - degrees_arc_start;
						} else {
							arc_start = 360 - (degrees_arc_start - 90);
						}
						
						if (degrees_arc_start + degrees_progress < 90) {
							arc_end = 90 - (degrees_arc_start + degrees_progress);
						} else {
							arc_end = 360 - (degrees_arc_start + degrees_progress - 90);
						}
						
						dc.setPenWidth(pen_width_regular);
						dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
						dc.drawArc(center_x, center_y, dc.getHeight() / 2, dc.ARC_CLOCKWISE, arc_start, arc_end);
					}
					
					if (percent >= streak_inc_threshold) {
						degrees_progress = 360 * (percent - streak_inc_threshold);
						
						degrees_arc_start = 360 * streak_inc_threshold;
						
						if (degrees_arc_start < 90) {
							arc_start = 90 - degrees_arc_start;
						} else {
							arc_start = 360 - (degrees_arc_start - 90);
						}
						
						if (degrees_arc_start + degrees_progress < 90) {
							arc_end = 90 - (degrees_arc_start + degrees_progress);
						} else {
							arc_end = 360 - (degrees_arc_start + degrees_progress - 90);
						}
						
						dc.setPenWidth(pen_width_regular);
						dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
						dc.drawArc(center_x, center_y, dc.getHeight() / 2, dc.ARC_CLOCKWISE, arc_start, arc_end);
					}
				} else {
					if (percent == 0.0) {
						degrees_progress = 1;
					}
					
					degrees_progress = 360 * percent;
					
					if (degrees_progress < 90) {
						arc_end = 90 - degrees_progress;
					} else {
						arc_end = 360 - (degrees_progress - 90);
					}
				
					if (percent > 1.0) {
						arc_color = Graphics.COLOR_DK_GREEN;
					} else if (percent >= streak_inc_threshold) {
						arc_color = Graphics.COLOR_GREEN;
					} else if (percent >= streak_reset_threshold) {
						arc_color = Graphics.COLOR_YELLOW;
					} else {
						arc_color = Graphics.COLOR_RED;
					}
					
					dc.setPenWidth(pen_width_streak_goal);
					dc.setColor(arc_color, Graphics.COLOR_TRANSPARENT);
					dc.drawArc(center_x, center_y, dc.getHeight() / 2, dc.ARC_CLOCKWISE, 90, arc_end);
				}
			}
		} else {
			dc.setPenWidth(pen_width_regular);
			dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
			dc.drawArc(center_x, center_y, dc.getHeight() / 2, dc.ARC_CLOCKWISE, 90, 90);
		}
	}
	
	//! Draws the progess arc according to the percentage of streak goal completion.
	//! Once the goal is reached the arc turns green. 
    //! @param [Object] dc Device Context
	function drawStreakGoalProgress(dc) {
		var progress = fast_manager.streak / resource_manager.streak_goal.toFloat();
	
		var degrees_progress;
		var arc_end;
		var arc_color;
			
		if (progress != 0) {
		
			degrees_progress = 360 * progress;
			
			if (degrees_progress < 90) {
				arc_end = 90 - degrees_progress;
			} else {
				arc_end = 360 - (degrees_progress - 90);
			}
		
			if (progress >= 1.0) {
				arc_color = Graphics.COLOR_GREEN;
				arc_end = 90;
			} else {
				arc_color = Graphics.COLOR_WHITE;
			}
			
			dc.setPenWidth(pen_width_regular);
			dc.setColor(arc_color, Graphics.COLOR_TRANSPARENT);
			dc.drawArc(center_x, center_y, dc.getHeight() / 2, dc.ARC_CLOCKWISE, 90, arc_end);
		}
	}
}
