# FIKA Docker Setup Guide

This guide provides instructions on how to set up and run the SPTarkov server with Fika using Docker. This setup is designed to facilitate easy deployment and management of server files and configurations.

## Prerequisites

- Docker installed on your machine. [Get Docker](https://docs.docker.com/get-docker/)
- Docker Compose installed if you are using a Docker Desktop version that does not already include it. [Install Docker Compose](https://docs.docker.com/compose/install/)

## Quick Start

1. **Clone the Repository**

   First, clone this repository to your local machine:

   `git clone https://yourrepositoryurl.com/fika-server.git`
   `cd fika-server`

2. **Build the Docker Image**
    
    Build the Docker image using Docker Compose:
    
    `docker-compose up -d --build`
    
	This command builds the Docker image with the necessary environment for the FIKA server and starts it in detached mode.
    
3. **Verify the Installation**
    
    After the build completes, you can verify that the container is running successfully by checking the logs:
    
    `docker logs fika`
## Modifying Server Data

### Aki_Data and User Directories

To add or modify the data in the `Aki_Data` and `user` directories:

1. **Accessing the Files**
    
    The `server-data` directory in your project folder on the host is mapped to `/fika/build` inside the container. Any changes made to files in the `server-data/Aki_Data` and `server-data/user` directories on the host will reflect inside the container.
    
2. **Adding Mods to the User Directory**
    
    If you wish to add mods or make changes to the configurations:
    
    - Navigate to the `server-data/user` directory on your host.
    - Add or modify the files as needed. These changes will be reflected inside the container.
    
1. **Rebuilding the Container**
    
    If you make changes that require a rebuild (for example, major updates or initial setup), you can rebuild the container using
    
    `docker-compose up -d --build`
    
    This command will rebuild the image and restart the container with the updated data.
    

## Troubleshooting

If you encounter any issues with your Docker environment:

- Check the Docker logs using `docker logs fika`.
- Ensure all paths in your Dockerfile and docker-compose.yml are correct.
- Verify that Docker has the necessary permissions to access and modify the files in your `server-data` directory.

