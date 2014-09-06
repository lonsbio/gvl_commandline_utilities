
"""
Write out a dashboard index.html file for a particular user.
"""

import subprocess
import getpass
import os.path


dashboard_file = "private_html/index.html"
dashboard_template = "dashboard_template.html"

def main():
    """ Body of script. """

    with open(dashboard_template, "r") as t:
        dashboard_text=t.read()

    dashboard_fullpath = os.path.join(os.path.expanduser("~"), dashboard_file)
    ip_addr = cmd_output("ifconfig | grep -A 1 eth0 | grep inet | sed -nr 's/.*?addr:([0-9\\.]+).*/\\1/p'")

    with open(dashboard_fullpath, "wb") as f:
        f.write(dashboard_text.format( ip_address = ip_addr,
                                    username = getpass.getuser() ))


def cmd_output(command):
    """Run a shell command and get the standard output, ignoring stderr."""
    return run_cmd(command)[0].strip()

def run_cmd(command):
    """ Run a shell command. """
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    return process.communicate()

if __name__=="__main__":
    main()
