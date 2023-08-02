To test and run OpenSwitch, you can follow these steps:

1. To start the FreeSwitch service, use the command:
   

   docker-compose up -d
   


2. To stop the FreeSwitch service, use the command:
   

   docker-compose down -d
   


3. To interact with the FreeSwitch server, you can use the `fs_cli` command-line interface. It allows you to manage and control various aspects of the FreeSwitch system. To access it, log in to the container or service by running:
   

   docker-compose exec -it freeswitch /bin/bash
   


4. Once inside the container, run the command `fs_cli` to start the FreeSwitch CLI.

5. To check the number of registrations, use the command `show registrations`. The output will display the registered users, realms, tokens, URLs, expiration times, network IP addresses, network ports, network protocols, hostnames, and metadata.

   Example output:
   

   freeswitch@freeswitch> show registrations
   reg_user,realm,token,url,expires,network_ip,network_port,network_proto,hostname,metadata
   1001,192.168.1.8,Y2MwZDI1ZDExYWNmOTk1ZjcwNzgzZGI1YTZmN2M4OTc.,sofia/internal/sip:1001@192.168.1.8:41983;rinstance=23f52c1009d21ccb;transport=TCP,1690977826,192.168.1.8,51760,tcp,freeswitch,
   1 total.
   freeswitch@freeswitch>
   


To check SIP traffic, you can use the following tools:

SNGREP: NGREP is a command-line tool for displaying SIP message flow in the terminal. It can capture SIP packets and save them in PCAP files for further analysis with tools like SNGREP, Tcpdump, or Wireshark.

SNGREP is a powerful tool for troubleshooting SIP problems. It allows you to see the SIP messages exchanged between endpoints, identify any issues with SIP signaling, view SIP dialogs, and track call progress.

   To use SNGREP, log in to the container by running:
   

   docker-compose exec -it freeswitch /bin/bash
   


   Then, to view SIP traffic, run:
   

   sngrep

----------------------------

Test it with sip client such as zoiper

username : 1001
pass: 1234

host: ur public ip   

