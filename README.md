# Bitninja Uninstaller

BitNinja Uninstaller helps to clean the server for any leftover BitNinja files thoroughly. 
This can be handy to save you some time. 

#### Important

The Uninstaller will not close the previously opened ports for you as this is Firewall dependent, kindly see the BitNinja docs for reference of the ports and close them by hand.

## Usage 

```
git clone git@github.com:sqpp/bitninja-uninstaller.git
cd bitninja-uninstaller
chmod +x uninstaller.sh
./uninstaller.sh [options]
```

### Options

- `./uninstall.sh full` -- Completely Removes All Files and Packages for BitNinja.
- `./uninstall.sh reinstall` -- Keeps the local configurations and only reinstalls [all] BitNinja packages.
- `./uninstall.sh -a` -- Fixes App_id errors (if the server was moved to a new BitNinja account this will not work)


## Support

BitNinja offers technical support @ bitninja.com; thus, this script has limited support. 
Also, use this script on your responsibility.
