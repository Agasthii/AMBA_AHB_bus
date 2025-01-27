
![image](https://github.com/user-attachments/assets/22a702e8-ceb0-4a80-801d-5e97c7401b16)

The Bus hus has 2 masters and 3 slaves. Master 1 has priority, and one slave is split-supported. The slave sizes are as follows,
  * Slave 1: 4 K (Split supported)
  * Slave 2: 4 K
  * Slave 3: 2 K

When communicating with the other team, if we are to read/write data from a slave module in the other team, our master connects to their bus bridge and requests/transmits data from/to their slave.

### Master

![image](https://github.com/user-attachments/assets/539fbb54-7375-4bec-b982-3f6e9e285943)

### Slave

![image](https://github.com/user-attachments/assets/aadbf93c-4a92-40b8-8274-d4408c7fe72b)

### Arbiter

![image](https://github.com/user-attachments/assets/5b09ba29-7abb-4e3e-ac36-10ba2a972db5)

