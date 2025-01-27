
![image](https://github.com/user-attachments/assets/22a702e8-ceb0-4a80-801d-5e97c7401b16)

The Bus hus has 2 masters and 3 slaves. Master 1 has priority, and one slave is split-supported. The slave sizes are as follows,
* Slave 1: 4 K (Split supported)
..* Slave 2: 4 K
..* Slave 3: 2 K
When communicating with the other team, if we are to read/write data from a slave module in the other team, our master connects to their bus bridge and requests/transmits data from/to their slave.
