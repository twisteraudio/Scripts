import time
import datetime

daytoday = datetime.datetime.now().timetuple().tm_yday

if int(daytoday) == 359:
	print("YES, REJOICE")
elif int(daytoday) < 359:
	print("NO")
elif int(daytoday) > 359:
	print("NO")
	
