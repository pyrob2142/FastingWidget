# Fasting Widget for Garmin devices

This Fasting Widget for Garmin devices allows you to keep track of your fast right on your wrist.

## Sections
1. [Features](https://github.com/pyrob2142/FastingWidget#features)
2. [Installation](https://github.com/pyrob2142/FastingWidget#installation)
3. [Supported devices](https://github.com/pyrob2142/FastingWidget#supported-devices)
4. [Supported languages](https://github.com/pyrob2142/FastingWidget#supported-languages)
5. [Settings](https://github.com/pyrob2142/FastingWidget#settings)
6. [Real-time Calories Estimation](https://github.com/pyrob2142/FastingWidget#real-time-calories-estimation)
7. [Credits](https://github.com/pyrob2142/FastingWidget#credits)
8. [License](https://github.com/pyrob2142/FastingWidget#license)
9. [Screenshots](https://github.com/pyrob2142/FastingWidget#screenshots)


## Features
* Set yourself a goal by choosing from various popular fast lengths, set up to 3 personal goal durations or fast freely without any commitment
* Keep track of your fast's duration and how long you have left until you meet your goal.
* Get an estimate of your real-time calorie burn based on implementations of BMR and activity formulas (see section [Real-time Calories Estimation](https://github.com/pyrob2142/FastingWidget#real-time-calories-estimation) for details)
* Keep yourself accountable by maintaining a streak
* The widget can be configured via Garmin Connect Mobile or Garmin Express
* No account or registration required. All data comes from either your user settings (birthday, body fat percentage) or your user profile (weight, height) and is only used during runtime for the calorie calculations

## Installation
You can get the widget from the [ConnectIQ store](https://apps.garmin.com/en-US/apps/d3823345-7e22-402d-ab00-c06f58e1c6b2) 

## Supported devices
Due to the differences in display, memory and button configurations only the following devices are supported at the moment:

* Captain Marvel
* D2™ Charlie
* D2™ Delta
* D2™ Delta PX
* D2™ Delta S
* Darth Vader™
* Descent™ Mk1
* fēnix® 5 / quatix® 5
* fēnix® 5 Plus
* fēnix® 5S
* fēnix® 5S Plus
* fēnix® 5X / tactix® Charlie
* fēnix® 5X Plus
* fēnix® 6
* fēnix® 6 Pro
* fēnix® 6S
* fēnix® 6S Pro
* fēnix® 6X Pro
* fēnix® Chronos
* First Avenger
* Forerunner® 245
* Forerunner® 245 Music
* Forerunner® 645
* Forerunner® 645 Music
* Forerunner® 935
* Forerunner® 945
* MARQ™ Adventurer
* MARQ™ Athlete
* MARQ™ Aviator
* MARQ™ Captain
* MARQ™ Commander
* MARQ™ Driver
* MARQ™ Expedition
* Rey™
* Venu
* vívoactive® 3
* vívoactive® 3 Mercedes-Benz® Collection
* vívoactive® 3 Music
* vívoactive® 3 Music LTE
* vívoactive® 4
* vívoactive® 4S

## Supported Languages:
I try to support as many languages as possible, but require the help of volunteers to provide translations. For now the widget is available in the following languages:
* Croatian (notefolio)
* English (pyrob2142)
* German (pyrob2142)

If you want to provide a translation for the widget please feel free to edit the respective column in the [translation sheet](https://docs.google.com/spreadsheets/d/1SsTI2uS_bSHyEUOPEC_kIoC_L1SxvAgFt5AfdP6ME7Q/edit?usp=sharing).

## Settings
* Long press threshold (ms): Set how long you have to hold the start button to open up the menus (Default: 2000 ms)
* Initial page (with goal): Set the startup page for when your fast has a goal (Default: Show time remaining)
* Initial page (without goal): Set the startup page for when your fast has no goal (Default: Show time elapsed)
* Default goal: Avoid having to scroll through the options by setting your default fast duration (Default: 16 hours)
* Custom goals 1-3: Set up to 3 custom goal times by entering the amount of hours. Set to 0 to clear.
* Activity level: Set your activity level to increase the accuracy of your calorie estimate (Default: Moderate)
* Date of birth: Set your date of birth to further increase the accuracy of your calorie estimate (Default: 30)
* BMR calculation based on: Select from a variety of formulas (details below) for estimating your real-time calorie burn.
* Body fat (%): Required by the Katch-McArdle formula (Default: 23%)
* Reset streak below (% of completion): Count your fast as failed and reset your streak, if your fast does not reach a certain threshold of completion (Default: 50%)
* Increase streak above(% of completion): Count your fast as successful and increase your streak, if you reached at least this threshold of completion (Default: 75%)
* Overwrite Streak: Allows you to overwrite the streak in case the settings get reset. Don't cheat!
* Overwrite date format: While we provide a default format for your language, you are always free to customize it. Simply enter your desired format as a string: e.g. dd.mm.yy, mm/dd/yy, yy|mm|dd, ...
* Time format: Choose if you want the labels for elapsed and remaining time shown with time units or in regular clock style
* Switch to days after (hours): Select after how many hours you want the elasped and remaining time converted into days. E.g. 48H 00MIN 00S -> 02D 00H 00MIN / 02:00:00:00

## Real-time Calories Estimation
The widget uses a combination of your BMR (basal metabolic rate) and activity level to estimate your daily calorie burn, which is then divided by 86400 (seconds in a day) to get your calories per second. Multiplying with the amount of seconds elapsed since you started your fast, results in an estimate of how many calories you should have burned at this point in your fast. Do note that while these equations are backed by statistics their accuracy is limited. For more information please see: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3572798/

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
fire.png made by [Freepik](https://www.flaticon.com/authors/freepik) from [www.flaticon.com](www.flaticon.com).

Translators are credited next to their respective languages.

## License
This project is licensed under the terms of the [GNU General Public License v3.0](LICENSE.md) license.

## Screenshots
<img src="/Screenshots/streak_view.png" height="425" /> <img src="/Screenshots/new_fast.png" height="425" />
<img src="/Screenshots/goal_hours.png" height="425" /> <img src="/Screenshots/goal_days_weeks.png" height="425" />
<img src="/Screenshots/elapsed_view.png" height="425" /> <img src="/Screenshots/remaining_view.png" height="425" />
<img src="/Screenshots/calories_view.png" height="425" /> <img src="/Screenshots/end_fast.png" height="425" />
<img src="/Screenshots/menu_cancel.png" height="425" /> <img src="/Screenshots/summary.png" height="425" />
<img src="/Screenshots/streak_increase.png" height="425" /> <img src="/Screenshots/streak_reset.png" height="425" />
