# Converts a csv-file into a working strings.xml file
# It's not pretty, but it gets the job done.
# Requires pandas

import os
import sys
import argparse
import pandas

def get_options(args=sys.argv[1:]):
    parser = argparse.ArgumentParser(description="Parses command.")
    parser.add_argument("-i", "--input", help="The csv file to convert.")
    parser.add_argument("-l", "--language", help="The language you want to generate.")
    options = parser.parse_args(args)
    return options

def get_short(language):
    return {
        'Arabic': 'ara',
        'Bulgarian': 'bul',
        'Chinese (Simplified)': 'zhs',
        'Chinese (Traditional)': 'zht',
        'Croatian': 'hrv',
        'Czech': 'ces',
        'Danish': 'dan',
        'Dutch': 'dut',
        'English': 'eng',
        'Estonian': 'est',
        'Finnish': 'fin',
        'French': 'fre',
        'German': 'deu',
        'Greek': 'gre',
        'Hebrew': 'heb',
        'Hungarian': 'hun',
        'Indonesian': 'ind',
        'Italian': 'ita',
        'Japanese': 'jpn',
        'Korean': 'kor',
        'Latvian': 'lav',
        'Lithuanian': 'lit',
        'Norwegian': 'nob',
        'Polish': 'pol',
        'Portuguese': 'por',
        'Romanian': 'ron',
        'Russian': 'rus',
        'Slovak': 'slo',
        'Slovenian': 'slv',
        'Spanish': 'spa',
        'Standard (Bahasa) Malay': 'zsm',
        'Swedish': 'swe',
        'Thai': 'tha',
        'Turkish': 'tur',
        'Ukrainian': 'ukr',
        'Vietnamese': 'vie'
    }[language]

options = get_options()

directory = 'FastingWidget'
csv_file = options.input
data_frame = pandas.read_csv(csv_file)
language = options.language
lang_short = get_short(language)

print(data_frame.head())

column = data_frame['%s' % (language)]
column.tolist()

translator = column[0]
app_name = column[1]

long_press_threshold_title = column[2]

default_page_goal_title = column[3]
default_page_no_goal_title = column[4]
page_streak = column[5]
page_elapsed = column[6]
page_remaining = column[7]
page_calories = column[8]

default_goal_title = column[9]
hours = column[10]
days = column[11]
week = column[12]
weeks = column[13]

activity_level_title = column[14]
activity_level_0 = column[15]
activity_level_1 = column[16]
activity_level_2 = column[17]
activity_level_3 = column[18]
activity_level_4 = column[19]

birthday_title = column[20]
bmr_formula_title = column[21]
bmr_mifflin = column[22]
bmr_harris = column[23]
bmr_katch = column[24]
body_fat_title = column[25]

streak_reset_threshold_title = column[26]
streak_inc_threshold_title = column[27]
streak_title = column[28]
overwrite_date_format_title = column[29]
time_format_title = column[30]
show_days_title = column[31]

summary = column[32]
duration = column[33]
calories = column[34]
streak = column[35]
fast_sg = column[36]
fast_pl = column[37]
nominalization = column[38]
elapsed = column[39]
remaining = column[40]
since = column[41]
until = column[42]
kcal = column[43]
overtime = column[44]

fast_type_menu_title = column[45]
fast_set_goal = column[46]
fast_no_goal  = column[47]
end_fast_title = column[48]
cancel_fast_title = column[49]
goal_menu_title = column[50]
yes = column[51]
no = column[52]

symbol_days = column[53]
symbol_hours = column[54]
symbol_minutes = column[55]
symbol_seconds = column[56]
default_date_format = column[57]

time_format_1 = "x" + symbol_days + " x" + symbol_hours + " x" + symbol_minutes
time_format_2 = symbol_days + ":" + symbol_hours + ":" + symbol_minutes 

# Write the new strings.xml file in the corresponding resources folder
file_name = directory + os.path.sep + 'resources-%s' % (lang_short) + os.path.sep + 'strings.xml'
os.makedirs(os.path.dirname(file_name), exist_ok = True)

with open(file_name, "w+", encoding='utf-8') as f:
    f.write('<!-- TRANSLATOR: %s -->\n' % (translator))
    f.write('<resources>\n')
    f.write('\t<!-- APP NAME -->\n')
    f.write('\t<string id="AppName">%s</string>\n' % (app_name))
    f.write('\n')
    f.write('\t<!-- USER SETTINGS -->\n')
    f.write('\t<string id="longpress_threshold_title">%s</string>\n' % (long_press_threshold_title))
    f.write('\n')
    f.write('\t<string id="default_page_goal_title">%s</string>\n' % (default_page_goal_title))
    f.write('\t<string id="default_page_no_goal_title">%s</string>\n' % (default_page_no_goal_title))
    f.write('\t<string id="page_streak">%s</string>\n' % (page_streak))
    f.write('\t<string id="page_elapsed">%s</string>\n' % (page_elapsed))
    f.write('\t<string id="page_remaining">%s</string>\n' % (page_remaining))
    f.write('\t<string id="page_calories">%s</string>\n' % (page_calories))
    f.write('\n')
    f.write('\t<string id="default_goal_title">%s</string>\n' % (default_goal_title))
    f.write('\t<string id="goal_8">8 %s</string>\n' % (hours))
    f.write('\t<string id="goal_12">12 %s</string>\n' % (hours))
    f.write('\t<string id="goal_14">14 %s</string>\n' % (hours))
    f.write('\t<string id="goal_16">16 %s</string>\n' % (hours))
    f.write('\t<string id="goal_20">20 %s</string>\n' % (hours))
    f.write('\t<string id="goal_24">24 %s</string>\n' % (hours))
    f.write('\t<string id="goal_36">36 %s</string>\n' % (hours))
    f.write('\t<string id="goal_48">48 %s</string>\n' % (hours))
    f.write('\t<string id="goal_60">60 %s</string>\n' % (hours))
    f.write('\t<string id="goal_72">72 %s</string>\n' % (hours))
    f.write('\t<string id="goal_84">84 %s</string>\n' % (hours))
    f.write('\t<string id="goal_96">96 %s</string>\n' % (hours))
    f.write('\t<string id="goal_108">4½ %s</string>\n' % (days))
    f.write('\t<string id="goal_120">5 %s</string>\n' % (days))
    f.write('\t<string id="goal_132">5½ %s</string>\n' % (days))
    f.write('\t<string id="goal_144">6 %s</string>\n' % (days))
    f.write('\t<string id="goal_156">6½ %s</string>\n' % (days))
    f.write('\t<string id="goal_168">1 %s</string>\n' % (week))
    f.write('\t<string id="goal_336">2 %s</string>\n' % (weeks))
    f.write('\t<string id="goal_504">3 %s</string>\n' % (weeks))
    f.write('\t<string id="goal_672">4 %s</string>\n' % (weeks))
    f.write('\n')
    f.write('\t<string id="activity_level_title">%s</string>\n' % (activity_level_title))
    f.write('\t<string id="activity_level_0">%s</string>\n' % (activity_level_0))
    f.write('\t<string id="activity_level_1">%s</string>\n' % (activity_level_1))
    f.write('\t<string id="activity_level_2">%s</string>\n' % (activity_level_2))
    f.write('\t<string id="activity_level_3">%s</string>\n' % (activity_level_3))
    f.write('\t<string id="activity_level_4">%s</string>\n' % (activity_level_4))
    f.write('\n')
    f.write('\t<string id="birthday_title">%s</string>\n' % (birthday_title))
    f.write('\t<string id="bmr_formula_title">%s</string>\n' % (bmr_formula_title))
    f.write('\t<string id="bmr_mifflin">%s</string>\n' % (bmr_mifflin))
    f.write('\t<string id="bmr_harris">%s</string>\n' % (bmr_harris))
    f.write('\t<string id="bmr_katch">%s</string>\n' % (bmr_katch))
    f.write('\t<string id="body_fat_title">%s</string>\n' % (body_fat_title))
    f.write('\n')
    f.write('\t<string id="streak_reset_threshold_title">%s</string>\n' % (streak_reset_threshold_title))
    f.write('\t<string id="streak_inc_threshold_title">%s</string>\n' % (streak_inc_threshold_title))
    f.write('\t<string id="streak_title">%s</string>\n' % (streak_title))
    f.write('\t<string id="overwrite_date_format_title">%s</string>\n' % (overwrite_date_format_title))
    f.write('\t<string id="time_format_title">%s</string>\n' % (time_format_title))
    f.write('\t<string id="show_days_title">%s</string>\n' % (show_days_title))
    f.write('\n')
    f.write('\t<!-- FastingView.mc -->\n')
    f.write('\t<string id="summary">%s</string>\n' % (summary))
    f.write('\t<string id="duration">%s</string>\n' % (duration))
    f.write('\t<string id="calories">%s</string>\n' % (calories))
    f.write('\t<string id="streak">%s</string>\n' % (streak))
    f.write('\t<string id="fast_sg">%s</string>\n' % (fast_sg))
    f.write('\t<string id="fast_pl">%s</string>\n' % (fast_pl))
    f.write('\t<string id="nominalization">%s</string>\n' % (nominalization))
    f.write('\t<string id="elapsed">%s</string>\n' % (elapsed))
    f.write('\t<string id="remaining">%s</string>\n' % (remaining))
    f.write('\t<string id="since">%s</string>\n' % (since))
    f.write('\t<string id="until">%s</string>\n' % (until))
    f.write('\t<string id="kcal">%s</string>\n' % (kcal))
    f.write('\t<string id="overtime">%s</string>\n' % (overtime))
    f.write('\n')
    f.write('\t<!-- MenuHandler.mc -->\n')
    f.write('\t<string id="fast_type_menu_title">%s</string>\n' % (fast_type_menu_title))
    f.write('\t<string id="fast_set_goal">%s</string>\n' % (fast_set_goal))
    f.write('\t<string id="fast_no_goal">%s</string>\n' % (fast_no_goal))
    f.write('\t<string id="end_fast_title">%s</string>\n' % (end_fast_title))
    f.write('\t<string id="cancel_fast_title">%s</string>\n' % (cancel_fast_title))
    f.write('\t<string id="goal_menu_title">%s</string>\n' % (goal_menu_title))
    f.write('\t<string id="yes">%s</string>\n' % (yes))
    f.write('\t<string id="no">%s</string>\n' % (no))
    f.write('\n')
    f.write('\t<!-- Toolbox.mc -->\n')
    f.write('\t<string id="symbol_days">%s</string>\n' % (symbol_days))
    f.write('\t<string id="symbol_hours">%s</string>\n' % (symbol_hours))
    f.write('\t<string id="symbol_minutes">%s</string>\n' % (symbol_minutes))
    f.write('\t<string id="symbol_seconds">%s</string>\n' % (symbol_seconds))
    f.write('\t<string id="days">%s</string>\n' % (days))
    f.write('\t<string id="default_date_format">%s</string>\n' % (default_date_format))
    f.write('\t<string id="time_format_1">%s</string>\n' % (time_format_1))
    f.write('\t<string id="time_format_2">%s</string>\n' % (time_format_2))
    f.write('</resources>')
    f.close()
