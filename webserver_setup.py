import subprocess

# Check if apache is installed

check = "yum list installed httpd &> /dev/null"
checked = subprocess.run(check, stdout=subprocess.PIPE, shell=True, text=True)
reset = "for i in $(pidof httpd); do kill -9 $i; done"

def is_enabled():
  result = subprocess.run("systemctl is-enabled httpd", stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, shell=True)
  
  if result.returncode == 1:
     print("Apache is being enabled and started.")
     subprocess.run("systemctl enable --now httpd",  stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, shell=True)

  else:
    print("Apache is already enabled.")

def is_installed():
  if checked.returncode == 0:
    print("Apache is installed, nothing to do.")
    
  else:
    print("Apache is being installed..")
    subprocess.run("dnf install httpd -y", stdout=subprocess.PIPE, shell=True, text=True)

  
def if_failed():
  check = subprocess.run("systemctl status httpd", stdout=subprocess.PIPE, text=True, stderr=subprocess.PIPE,shell=True)
  ret_code = check.returncode

  if ret_code == 0:
    print("Apache HTTP Server is running.")
  else:
    print ("Apache HTTP Server is not running or encountered an error. Exit status: $EXIT_STATUS")
    print ("Closing all related PID's and re installing APACHE")
    
    subprocess.run(reset, stdout=subprocess.PIPE, stderr=subprocess.PIPE)


if_failed()
is_installed()
is_enabled()

