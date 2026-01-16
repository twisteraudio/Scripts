#input ip address you wish to check then run script

import os
ret = os.system("ping 192.168.86.1")

while True:

    os.system("color 07")
    print("Welcome to the IP checker, this program checks to see if an IP is still active")
    print("type 'verify' to verify your ip")
    print("type 'check' to check ip")
    print("type 'quit' to exit")
    user_input = input(">> ")

    if user_input == 'quit':
        os.system("cls")
        break
    elif user_input == 'verify':
        os.system("cls")
        os.system("ipconfig -ipv4")
    elif user_input == 'check':
        os.system("cls")
        ret = os.system("ping 192.168.86.1 -quiet")
        if ret != 0:
            os.system("color 0b")
            print("pc still alive")
        else:
            os.system("color 0c")
            print("pc gone")