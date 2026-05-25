#goal: create a randomized twister spin

from random import choice as rc
import array
import os

while True:

    print("Type 's' to spin")
    user_input = input('>> ')

    if user_input == 'q':
        os.system('exit')
        break

    elif user_input == 's':
        os.system('cls')

        color = ['red', 'blue', 'green', 'yellow']
        hand = ['left foot', 'right foot', 'left hand', 'right hand']

        player = []
        player.append(rc(color))
        player.append(rc(hand))
        print(player)
    
    else:
        os.system('cls')
        print('please try again...')


