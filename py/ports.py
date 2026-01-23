import socket
import os
import sys
import datetime

while True:

    remoteserver = input('enter a remote host to scan: ')
    remoteserverIP = socket.gethostbyname(remoteserver)

    print('-' *8)
    print('please wait while the scan begins')
    print('-' *8)

    tn = datetime.datetime.now()

    try:
        for port in range(1,1025):
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            result = sock.connect_ex((remoteserverIP, port))
            if result == 0:
                print('port{}:          open'.format(port))
            sock.close()
    except KeyboardInterrupt:
        print('you pressed ctrl+c')
        os.system('cls')
    except socket.gaierror:
        print('Hostname could not be resolved...')
        sys.exit()
    except socket.error:
        print('could not connect to server...')
        sys.exit()

    tn2 = datetime.datetime.now()

    total = tn2 - tn

    print('Scan completed in:', total)