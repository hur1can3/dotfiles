#!/usr/bin/python
# -*- coding: utf-8 -*-
###############################################################################
import time
import calendar
import re
import locale
import string

locale.setlocale(locale.LC_ALL, '')

localtime = time.localtime(time.time())
calendar.setfirstweekday(calendar.SUNDAY)
cal = calendar.month(localtime[0], localtime[1],w=2,l=1)

parts = cal.split('\n')
cal = '${voffset -12}' + '\n${offset 36}'.join(parts)

regex = '(?<= )%s(?= )|(?<=\n)%s(?= )|(?<= )%s(?=\n)' % (localtime[2], localtime[2], localtime[2])
replace = '${font Droid Sans:style=bold:size=8}${color1}%s${color}${font Droid Sans Mono:size=7}' % localtime[2]
cal = re.sub(regex, replace, cal)

year = str(localtime[0])
month = str(calendar.month_name[localtime[1]])

cal = cal.replace(year,"")
cal = cal.replace(month,"")

print cal

