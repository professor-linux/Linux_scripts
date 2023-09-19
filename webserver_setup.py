import subprocess

# Check if apache is installed

check = "yum list installed httpd &> /dev/null"
checked = subprocess.run(check, stdout=PIPE, shell=True, text=True)

if checked.returncode == 0:
  print("Apache is installed, nothing to do.")
else:
  print("Apache is being installed..")
  subprocess.run("dnf install apache -y", stdout=PIPE, shell=True, text=True)
  

result = subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

print(result.stdout)
 
