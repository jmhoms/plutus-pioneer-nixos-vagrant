# plutus-pioneer-nixos-vagrant

## Description
This repository provides a Vagrantfile and a set of scripts to automate the deployment in a virtual machine of the tools needed to follow the Plutus Pioneer Program. I created it to facilitate my own experimentation with the Playground and with the compiler directly from a shell, for learning purposes.

I share it in the hope that someone may find it useful, if this is the case, just give me a star!

##### Why Vagrant
I chose Vagrant and VirtualBox for the virtualisation layer, because I'm familiar with them, and they provide great functionality like:
- Portability, same installation process for Windows, MacOSX and Linux, as long as Vagrant is available.  
- Isolation from the host OS helps avoiding workflow disruptions, as some of the recommended tools may be tricky to integrate with the existent toolset in the host.
- Automated deploy, easily reproducible. If I mess it up, I just start over from a clean state with no effort.
- Sweet spot between automation and flexibility, ability to change things and keep them over a try & learn process. If someone just wants to use the Playground's http client, a Docker deployment may be more convenient, see [alternatives](#Alternatives) below.
- Possibility to integrate with already existing frameworks in the host by using the /vagrant shared folder.

##### Why NixOS
I chose NixOS as the base operating system, not only for its out-of-the-box support of the Nix shell (which provides a convenient way to build the Plutus toolset), but to experiment with it, as I'm interested in its deterministic way to deploy systems.

## Requirements
- Working installation of VirtualBox   
https://www.virtualbox.org/manual/ch02.html
- Working installation of Vagrant  
https://www.vagrantup.com/docs/installation
- Minimum of 20 GB of HDD (Vagrantfile is setup to provision 35GB by default, change it if needed.)
- Minimum of 8GB of free RAM

## Usage

1. Clone the repository and enter its directory:  
    ```
    git clone https://github.com/jmhoms/plutus-pioneer-nixos-vagrant.git
    cd plutus-pioneer-nixos-vagrant
    ```

2. Install the plugin vagrant-disksize:
    ```
    vagrant plugin install vagrant-disksize
    ```

3. Customise anything you want, mainly by editing two files:
    - Vagrantfile: to change things like which weekly wrapper script to use, and the amount of memory and hard disk to be provisioned.
    - Nixos-Plutus-Scripts/configuration.nix: to change any configuration related to the deployment of the operating system, for example to include an additional package. For more information visit https://nixos.org/manual/nixos/stable/#sec-configuration-syntax

4. Deploy the service: this action may take around a half hour to download and build the system, depending on the resources available.
    ```
    vagrant up
    ```

5. Connect to the system when the previous process is finished.
    ```
    vagrant ssh
    ```

6. Plutus services may take some additional minutes to be ready once the system is up. The status and work in progress can be checked with the following commands.
    ```
    systemctl status PlutusPlaygroundServer
    systemctl status PlutusPlaygroundClient
    journalctl -f -u PlutusPlaygroundServer
    journalctl -f -u PlutusPlaygroundClient
    ```

7. Once the services are ready, the two listening ports (8080 and 8009) will be ready to accept connections. In order to check it, run the following command:
    ```
    netstat -an |grep -e 8080 -e 8009
    ```
    Proceed to connect to the Playground client using a web browser to the address:  
    https://127.0.0.1:8009  
    Accept any certificate warning to move forward.

8. To update Plutus to other versions required by weekly exercises, two options are provided along with doing it manually:
    - By using the week's appropriate wrapper script, i.e:
        ```
        /home/vagrant/NixOS-Plutus-Scripts/plutus-cohort02-week01.bash
        ```
    - Or by using the generic script passing a commit ID. Please note that the install command tries to install from scratch (deleting first), whereas the update command tries to update the installation in the existing directory.
        ```
        /home/vagrant/NixOS-Plutus-Scripts/plutus.bash install ea0ca4e9f9821a9dbfc5255fa0f42b6f2b3887c4
        ```
9. Find the exercises for every week under /opt/plutus-pioneer-program/, i.e. to compile week01 code:
    ```
    cd /opt/plutus
    nix-shell
    cd /opt/plutus-pioneer-program/code/week01/
    cabal update (only the first time)
    cabal build
    ```

10. Update the repository weekly as the pioneer program progreses, by
    - Running the script:
        ```
        /home/vagrant/NixOS-Plutus-Scripts/plutus-pioneer.bash
        ```
    - Or manually using git, i.e.:  
        ```
        cd /opt/plutus-pioneer-program
        git pull
        ```

11. If you want to access the exercises sources from the Host system to edit it with your usual tools, you can move the folder to /vagrant directory, i.e.:
    ```
    mv /opt/plutus-pioneer-program /vagrant/
    ```

12. Finally, remember to suspend/halt or even destroy the virtual machine when not in use according to your preferences using any of the following commands:
    ```
    vagrant suspend
    ```
    or
    ```
    vagrant halt
    ```
    or
    ```
    vagrant destroy
    ```
    Start it again by issuing another:
    ```
    vagrant up
    ```

## Todo
- Further testing.

- Add wrapper scripts for the next weeks.

- Evaluate other types of systemd services instead of "simple".

- Update NixOS version.

## Alternatives
Other options to deploy the Plutus Pioneer toolset are documented in this great community-driven documentation website:

https://docs.plutus-community.com/
