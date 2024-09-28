# Use the official Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set environment variable to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install necessary packages:
# - git: to clone repositories
# - python3: Python interpreter
# - python3-venv: to create virtual environments
# - python3-pip: Python package installer
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-venv \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Clone the internal custody repository
RUN git clone https://github.com/Chia-Network/internal-custody.git

# Set the working directory to the cloned repository
WORKDIR /internal-custody

# Create a Python virtual environment named 'venv'
RUN python3 -m venv venv

# Activate the virtual environment and install the custody tool
# Note:
# - Each RUN command in Dockerfile runs in a new shell, so activation and installation
#   need to be done in the same RUN command.
RUN /bin/bash -c "source venv/bin/activate && \
    pip install --upgrade pip && \
    pip install --extra-index-url https://pypi.chia.net/simple/ chia-internal-custody"

# Optionally, set the PATH to prioritize the virtual environment's binaries
ENV PATH="/internal-custody/venv/bin:$PATH"

# Specify the default command to run when the container starts
# Here, it starts a bash shell. You can change this to run your application.
CMD ["bash"]

