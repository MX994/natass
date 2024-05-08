import socket 

class Event:
    def __init__(self, event):
        self.executed = False
        self.event = event
        self.response = b''
        self.id = 0
        return
    
    def run(self, wk_socket : socket.socket):
        if not self.executed:
            # Send the command to the worker.
            print(f'[Event {self.id} ~ Command] C2 -> Client: "{self.event}"')
            wk_socket.send(self.event.encode())
            
            # Mark as executed (so we don't accidentally run it twice).
            self.executed = True

    def __str__(self):
        return self.event
    
