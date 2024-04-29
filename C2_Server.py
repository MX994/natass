import socket

def main():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind(('192.168.0.229', 90))
    s.listen(5)

    while True:
        conn, addr = s.accept()
        conn.settimeout(3)
        print(f'Connection from {addr}')
        buf = conn.recv(1024)
        print(buf)
        conn.close()