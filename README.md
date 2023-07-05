# KinesisDigitalAuditUtilities

I am *not* a Kinesis.money employee. Just a user of the system. 

Very intent on seeing sound money systems based on precious metals (gold and silver) spread around the world.

Creating this repository because the security bot at the user forum "https://forum.kinesis.money/" has blocked most IPs I have used so far. 
These IPs are all from a standard VPN provider. This means any other user using this VPN provider will also be blocked!

According to forum moderators I was uploading too much bash code and awk code (source code).
Source code apparently presents a risk of "buffer overflow".

I must not take that too personally as this may be due to relative inexperience in matters technical of the moderators.

bash, awk are interpreted and any experienced linux user can figure out within 5 seconds whether anything I upload presents any 
form of security risk.

My purpose was and is is to provide copy/ paste-able tools (under linux) that anybody with a dew days experience in linux could use.
Trying to sow the seeds of techie fun.

My username on the forum is

ZürichGnome
as opposed to

ZuerichGnome
here at github.

There are at least 2 parts to a precious metal provider audit:

the physical audit
the digital audit

I am of the firm belief that most of the digital audit could (and perhaps should !) be done by relatively techie users.

This may be a dream as Kinesis consists of:

1) a Stellar Blockchain called Horizon (?)
2) the KMS Exchange accessible by clients through a GUI and via some API code.
3) ABX mint (no blockchain, just a GUI, no APIs)

1-3):
https://explorer.kinesis.money/
https://kinesis.money/
https://forum.kinesis.money/

To retrieve flat file data extracts from (1), go here:

https://watcher.aboutkinesis.com/operations

By mouse-clicking on the "operations" tab (top left) and making sure the 

"Set custom network" tab upper right is set to either

https://kag.aboutkinesis.com
or
https://kau.aboutkinesis.com

you can at current data volumes (low) pull a CSV extract at bottom of that web page.

"Export data as CSV"

5-10 minutes elapsed
KAG is smaller and thus faster than KAU ( O(10 minutes) elapsed.

I do not know any current way of pulling this data in batch mode from the command line.

