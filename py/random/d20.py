import random,time,os

life = 0
death = 0

print("Starting death save...")
time.sleep(2)
os.system('cls' if os.name == 'nt' else 'clear')

#color text
CRED = '\033[91m'
CGREEN = '\033[92m'
CYELLOW = '\033[93m'
CBLUE = '\033[94m'
CEND = '\033[0m'

def dice():
    global life
    global death
    d20 = random.randint(1,20)

    #life +1
    if (10 <= d20 <= 19):
        life += 1

    #nat20 life +2
    elif (d20 == 20):
        life += 2

    #nat1 life -2
    elif (d20 == 1):
        death += 2

    #life -1
    elif (2 <= d20 <= 9):
        death += 1

    print(CYELLOW + str(d20) + CEND)

for x in range(5):
    dice()
    #print("Life: " + str(life) + " / Death: " + str(death))
    time.sleep(1)

if (life < 3):
    print(CRED + "You died" + CEND)
else:
    print(CGREEN + "You lived!" + CEND)

life = 0
