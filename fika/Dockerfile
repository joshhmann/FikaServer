##
## Dockerfile
## FIKA LINUX Container
##

# Use Ubuntu as the base image for both the build and final image
FROM ubuntu:latest AS builder

# Set environment variables to non-interactive (useful for apt-get)
ENV DEBIAN_FRONTEND=noninteractive

# Set build arguments
ARG FIKA_TAG=v0.9.8892.36315
ARG SPT=HEAD^
ARG SPT_BRANCH=3.8.1
ARG NODE=20.11.1

# Update and install necessary packages
RUN apt update && apt install -y git git-lfs curl

# Install Node Version Manager and Node.js
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && . $HOME/.nvm/nvm.sh \
    && nvm install $NODE && \
    node --version && npm --version

# Clone the SPT AKI repository
WORKDIR /fika
RUN git clone --branch $SPT_BRANCH https://dev.sp-tarkov.com/SPT-AKI/Server.git /fika/server

# Navigate to the project directory, checkout to the specific commit, and pull LFS files
WORKDIR /fika/server/project
RUN git checkout $SPT \
    && git-lfs pull

# Check directory contents to debug
RUN ls -la  # Lists current directory contents

## remove the encoding from aki - todo: find a better workaround
RUN if [ -f "src/Program.ts" ]; then sed -i '/setEncoding/d' src/Program.ts; fi

# Install npm dependencies and run build
ARG ARCH
RUN . $HOME/.nvm/nvm.sh && \
    if [ "$(uname -m)" = "aarch64" ]; then \
    ARCH="arm64"; \
    else \
    ARCH="x64"; \
    fi && \
    echo "Building for architecture: $ARCH" && \
    npm install && \
    npm run build:release -- --arch=$ARCH --platform=linux > build.log 2>&1 || cat build.log && \
    ls -la  # List directory contents to verify build folder exists

# Move the built server to a separate directory to clean up the source
RUN if [ -d "build/" ]; then mv build/ /fika/build; else echo "Build directory not found"; fi

# Clone and setup the FIKA Server Mod using the build argument for the tag
RUN git clone https://github.com/project-fika/Fika-Server.git /fika/server/user/mods/fika-server
RUN . $HOME/.nvm/nvm.sh && \
    cd /fika/server/user/mods/fika-server && \
    git checkout tags/${FIKA_TAG} && \
    npm install && \
    rm -rf /fika/server/user/mods/fika-server/.git

# Copy data into the build directory
COPY server-data/Aki_Data /fika/build/Aki_Data
COPY server-data/user /fika/build/user

# Start a new stage for the final image to keep it clean and small
FROM ubuntu:latest

# Install required packages
RUN apt update && apt install -y dos2unix

# Set the working directory
WORKDIR /fika

# Copy the server build from the builder stage
COPY --from=builder /fika/build /fika/build

# Copy the custom script and fix any Windows encoding issues
COPY fcpy.sh /fika/fcpy.sh
RUN dos2unix /fika/fcpy.sh && chmod +x /fika/fcpy.sh

# Set permissions for all files to be accessible
RUN chmod o+rwx -R /fika

# Expose necessary ports
EXPOSE 6969 6970 6971

# Set the default command to run the script that starts the server
CMD ["bash", "/fika/fcpy.sh"]
