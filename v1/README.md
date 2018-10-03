1 Requirements
==============
- docker
- docker-compose

`sudo apt-get install docker.io -y && sudo apt-get install docker-compose -y`

2 Avoid typing sudo
==============
`sudo groupadd docker`
`sudo usermod -aG docker $USER`

Then restart your computer.

3 Run
==============
`docker-compose up`

4 Control
==============
Open a browser and navigate to `127.0.0.1/jenkins`

5 Stop
==============
Type CTRL+C in the terminal or 
`docker-compose down`
