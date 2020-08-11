### General Documentation ###

__This page is regularly updated.__ | *__updated 7/16/2020__*
------------ | -------------:

**_pwhite&#064;mercy.edu_**

*Originally prepared as presentation notes (Feb 19, 2020)*

This will be expanded, updated and changed over time. Keep checking back. Suggestions welcome.

**_NOTE_**: Many links in this document are private and only available on campus.

#### Sections ####
- ##### [Overview](#OVERVIEW) #####
- ##### [Recent changes](#RECENT_CHANGES) #####
- ##### [Servers](#SERVERS) #####
- ##### [Lab Software](#SOFTWARE) #####

<a name="OVERVIEW"></a>
##### Overview #####

<a name="RECENT_CHANGES"></a>
##### Recent Changes #####

There have been many major changes over the last few semesters

- Redundancy redundancy redundancy
    - [Synology High Availability Cluster](http://172.31.48.200:5000) (IT has password if needed)
       - Two identical Synology devices act in tandem. They are each independently connected to the network switch, but share a single IP address (Primary cluster interface).
       - One is "Active" the other "Passive". Synchronization is continuous via a direct-connect ethernet "heartbeat" interface.
       - If active device fails, the passive device takes over and service availabilty is restored within minutes.
    - Backups
        - Historical (with retention schedule)
          - Uses Synology Hyper Backup
        - Folder Sync
          - Uses built-in "Shared Folder Sync" in Control Panel
          - Live mirror of Class Folders

- [Github](https://github.com/PWmercy/Mercy-Digital-Arts) and [Gists](https://gist.github.com/PWmercy)
   - Repositories for scripts (mostly Bash) and other useful info used for management of lab macs and servers.
    - Longer code in Github, code snippets and documentation (like the one you're reading now) in Gists.
    - Using plugin these can be displayed inside a Wordpress web page

- New Apple requirements
    - [MDM](https://mybusiness.mosyle.com)
      - Mosyle Device Manager
    - [Apple School Manager](https://mybusiness.mosyle.com)
    - Includes iPads
    - Privacy/Security
        - Tighter with each OS release
        - Examples: microphone, Wacom tablets, Adobe and Autodesk software

- Sync to cloud
    - Sync to OneDrive
        - During COVID closure, made campus server files available to students and faculty from home.
        - New OneDrive space created by IT for this purpose


<a name="SERVERS"></a>
##### Servers #####

1. Synology
 - Model RS3617RPxs
 - Serial # 1760NTN261200
 - 16GB
2. Synology
 - Specs
  - Model RS815RP+
  - Serial # 1750MSN107000
  - 6GB
- Services
 - Backup
3. Synology
 - Model RS3617RPxs
 - Serial # 1910NTN037900
 - 16GB
 - High Availability Cluster Failover
  - Mac Mini servers

##### Lab Computers #####

  - iMacs
  - Mac Minis
  - Mac Pro (2013)

##### Peripheral devices #####
  - Wacom Tablets

<a name="SOFTWARE"></a>
- ##### Software #####
- For All
   -   Microsoft Suite
   -   ExpanDrive
   -   Standard App Store
- For Design+Animation
   -   Adobe Creative Cloud
   -   Maya
   -   Substance Painter
   -   Marvelous Designer
   -   ZBrush
   -   KeyShot
   -   Quixel
   -   Houdini
   -   Nuke
   -   Vray
   -   [Qube](https://www.pipelinefx.com) Render Farm

- For Music Production+Recording Arts
    -   Pro Tools
    -   Reason
    -   Logic Pro
    -   Ableton Live
    -   Musition
    -   Native Instruments Komplete



### Hardware

iMacs

Mac Mini

iMac Pro

Mac Pro (2012)

Printers

### Software

Renewal calendar

#### All computers



### __Deployment and Maintenance__  

#### Apple updates

-   Reposado/Margarita

#### Software install and updates

-   Munki  
    Server at munki5.digiarts.mercy

#### Loops for GarageBand and Logic

-   [appleloops utility](https://github.com/carlashley/appleLoops)

#### Synology

-   Package Center

#### Management/Reporting

-   [Munki Report](http://munki5.digiarts.mercy/report/)
-   [KeyServer](http://license2.digiarts.mercy:8081/software)
-   [Mosyle MDM](https://mybusiness.mosyle.com)
-   [Apple School Manager](https://school.apple.com)


- Licensing - each administered differenlty
    - Adobe changes
    - Multiple license servers
        - [Reason](http://172.31.48.93:22352)
        - [ZBrush](http://172.31.48.93:5054/home.asp)
        - Keyshot
        - [VRay](http://172.31.48.94:30304/#/)
        - Musition (cloud)
          - Students and Faculty need an account set up locally through the Musition Cloud app.

- Many servers/many services
    - Synology
        - Private DNS
    - Docker
    - Mac minis
      - Mini Server 1 RETIRED
      - Mini Server 2
      - Mini Server 3
      - Mini Server 4
        - Out of service - New HD?
      - Mini Server 5
        - Munki
        - Munki Report
      - Mini Server 6
    - IT-managed VMs
        - Booked scheduling system
            - [Web access](https://booked.mercy.edu)
            - [Product support](https://www.bookedscheduler.com)

- Management tools
    - [MDM](https://mybusiness.mosyle.com)
    - [KeyServer](http://172.31.48.93:8081/maps)
        - Heat maps
    - [Docker](http://172.31.48.124:5000)
        - [Margarita/Reposado](http://172.31.48.124:8089)
        - Private support [web site](http://172.31.48.124:8081)

- Deployment tools
    - Munki
        - [Munki report](http://munki5.digiarts.mercy/report/index.php?/show/dashboard/default)
        - Customization and Branding

- MacAdmins
    - Slack channel
