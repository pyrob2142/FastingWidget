using Toybox.WatchUi;
using Toybox.Graphics;

class FastingView extends WatchUi.View {

	var center_x;
	var center_y;
	

    function initialize() {
        View.initialize();
        
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
        drawStreak(dc);   
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

	function drawStreak(dc) {
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.clear();
		
		dc.drawText(center_x, center_y - 25 - dc.getFontHeight(Graphics.FONT_MEDIUM), Graphics.FONT_MEDIUM, "STREAK", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y, Graphics.FONT_NUMBER_HOT, "1000", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y + 60, Graphics.FONT_MEDIUM, "FASTS", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
	}
	
	function drawFast(dc) {
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.clear();
		
		dc.drawText(center_x, center_y - 46 - dc.getFontHeight(Graphics.FONT_TINY), Graphics.FONT_TINY, "REMAINING", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y - dc.getFontHeight(Graphics.FONT_LARGE), Graphics.FONT_MEDIUM, "50D 18H 20MIN", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y, Graphics.FONT_TINY, "UNTIL", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y + 36, Graphics.FONT_MEDIUM, "06.05.20, 07:26", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center_x, center_y + 75, Graphics.FONT_MEDIUM, "85.5%", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		
		drawProgressArc(dc, 1);
	}
	
	function drawProgressArc(dc, percent) {
		var degrees = 360 * percent;
		var arc_end = 0;
		
		if (degrees < 90) {
			arc_end = 90 - degrees;
		} else {
			arc_end = 360 - (degrees - 90);
		}
	
		dc.setPenWidth(10);
		dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
		dc.drawArc(center_x, center_y, 115, dc.ARC_CLOCKWISE, 90, arc_end);
	}
}
