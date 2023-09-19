import subprocess

command = "who | awk '{print $1}' | uniq "

result = subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

print(result.stdout)
 
