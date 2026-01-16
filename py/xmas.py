import time
import datetime

while True:
	daytoday = datetime.datetime.now().timetuple().tm_yday
	#chrsistmas number = 359

	#operation menu
	print("what is the date today? please enter in year, month, day")
	print("To exit program, type exit")
	user_input = input(" >>")
	
	#exit button incase program needs to end
	if user_input == "exit":
		break
	#checks date for today
	elif user_input == "date":
		print(daytoday)
	elif user_input == "check":
		#checks day number against the day number of xmas
		if int(daytoday) == 359:
			print("YES, REJOICE")
		elif int(daytoday) < 359:
			print("NO")
		elif int(daytoday) > 359:
			print("NO")
	#if input isn't anything in the above, it prints this
	else:
		print("this was supposed ot be a fun thing, now why did you have to put that there")
