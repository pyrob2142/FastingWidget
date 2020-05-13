# Fasting Widget for Garmin devices

This Fasting Widget for Garmin devices allows you to keep track of your fast right on your wrist.

## Features
* Set yourself a goal by choosing from various popular fast lengths or fast freely without any commitment
* Keep track of your fast's duration and how long you have left until you meet your goal.
* Get an estimate of your real-time calorie burn based on implementations of BMR and activity formulas (details below)
* Keep yourself on track by maintaining a streak
* The widget can be configured via Garmin Connect Mobile or Garmin Express
* No account or registration required. All data comes from either your user settings (birthday, body fat percentage) or your user profile (weight, height) and is only used during runtime for the calorie calculations

## Installation
You can get the widget from the ConnectIQ store [UPDATE AFTER RELEASE]

## Supported devices
Due to the differences in display, memory and button configurations only the following devices are supported at the moment:

* D2™ Charlie
* D2™ Delta
* D2™ Delta PX
* D2™ Delta S
* Descent™ Mk1
* fēnix® 5 / quatix® 5
* fēnix® 5 Plus
* fēnix® 5S Plus
* fēnix® 5X / tactix® Charlie
* fēnix® 5X Plus
* Forerunner® 245
* Forerunner® 245 Music
* Forerunner® 645
* Forerunner® 645 Music
* Forerunner® 935
* Forerunner® 945
* vívoactive® 3
* vívoactive® 3 Mercedes-Benz® Collection
* vívoactive® 3 Music
* vívoactive® 3 Music LTE

## Supported Languages:
I try to support as many languages as possible, but require the help of volunteers to provide translations. For now the widget is available in the following languages:
* English (default)
* German
* Croatian

If you want to provide a translation for the widget please feel free to edit the respective column in the [translation sheet](https://docs.google.com/spreadsheets/d/1SsTI2uS_bSHyEUOPEC_kIoC_L1SxvAgFt5AfdP6ME7Q/edit?usp=sharing). 

## Settings
* Long Press Threshold (ms): Set how long you have to hold the start button to open up the menus (Default: 2000 ms)
* Initial Page (with goal): Set the startup page for when your fast has a goal (Default: Show time remaining)
* Initial Page (without goal): Set the startup page for when your fast has no goal (Default: Show time elapsed)
* Default goal: Avoid having to scroll through the options by setting your default fast duration (Default: 36 hours)
* Activity level: Set your activity level to increase the accuracy of your calorie estimate (Default: Moderate)
* Birthday: Set your date of birth to further increase the accuracy of your calorie estimate (Default: 30)
* BMR calculation based on: Select from a variety of formulas (details below) for estimating your real-time calorie burn.
* Body fat (%): Required by the Katch-McArdle formula (Default: 23%)
* Reset streak below (% of completion): Count your fast as failed and reset your streak if your fast doesn't reach a certain threshold of completion (Default: 50%)
* Increase streak above(% of completion): Count your fast as successful and increase your streak if you reached at least this threshold of completion (Default: 75%)
* Overwrite Streak: Allows you to overwrite the streak in case the settings get reset. Don't cheat!

## Real-time Calories Estimation
The widget uses a combination of your BMR (basal metabolic rate) and activity level to calculate your daily calories. These are then divided by 86400 to get your calories per second, which lets us estimate how many calories you should have burned at any point of your fast.

The formulas available for BMR calculation are:
* Mifflin-St Jeor Equation:

  Men:     **BMR** = 10 * **W** + 6.25 * **H** - 5 * **A** + 5
  
  Women:   **BMR** = 10 * **W** + 6.25 * **H** - 5 * **A** - 161

* Revised Harris-Benedict Equation:
  
  Men:     **BMR** = 13.397 * **W** + 4.799 * **H** - 5.677 * **A** + 88.362

  Women:   **BMR** = 9.247 * **W** + 3.098 * **H** - 4.330 * **A** + 447.593

* Katch-McArdle Formula:

  **BMR** = 370 * 21.6 * (1 - **F**) * **W**

Where:

**BMR**     Basal Metabilic Rate

**W**       Weight in kilograms (kg)

**H**       Height in centimenters (cm)

**A**       Age in years

**F**       Body fat in percent (%)

Your activity level is determined as follows:
* Sedentary (little to no exercise): 1.2
* Lightly Active (light exercise 1-3 days per week): 1.375
* Moderately Active (moderate exercise 3-5 days per week): 1.55
* Very Active (hard exercise 6-7 days per week): 1.725
* Extra Active (very hard exercise/training or a physical job): 1.9

## Credits
fire.png made by [Freepik](https://www.flaticon.com/authors/freepik) from [www.flaticon.com](www.flaticon.com)
