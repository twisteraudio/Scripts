import socket, os, sys, datetime,argparse

def main():
    parser = argparse.ArgumentParser(description = "Python IP Port scan")
    parser.add_argument("-i", "--IP", help="IP Address you would like to scan")
    args = parser.parse_args()

    remoteserver = args.IP
    remoteserverIP = socket.gethostbyname(remoteserver)

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
        os.system('exit')
    except socket.gaierror:
        print('Hostname could not be resolved...')
        sys.exit()
    except socket.error:
        print('could not connect to server...')
        sys.exit()

    tn2 = datetime.datetime.now()

    total = tn2 - tn

    print('Scan completed in:', total)

print('-' *8)
print('please wait while the scan begins')
print('-' *8)

if __name__ == "__main__":
    main()
