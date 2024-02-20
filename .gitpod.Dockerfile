# Use a base image with Gitpod workspace features
FROM gitpod/workspace-full:latest

# Install dependencies
USER root
RUN sudo apt-get update && \
    sudo apt-get install -y \
    python3 \
    python3-pip \
    && sudo rm -rf /var/lib/apt/lists/*

# Create and activate a virtual environment in /workspace
USER gitpod
RUN python3 -m venv /workspace/venv
ENV PATH="/workspace/venv/bin:$PATH"

# Enable virtual environment by default
RUN echo "source /workspace/venv/bin/activate" >> /home/gitpod/.bashrc

# Install JupyterLab
RUN /workspace/venv/bin/pip install jupyterlab

# Expose the JupyterLab port
EXPOSE 8888

# Create a custom Jupyter configuration directory
RUN mkdir -p /home/gitpod/.jupyter

USER root
# Copy your jupyter_server_config.json to /home/gitpod/.jupyter/ and set permissions
COPY jupyter_server_config.json /home/gitpod/.jupyter/jupyter_server_config.json
RUN chown -R gitpod:gitpod /home/gitpod/.jupyter

USER gitpod
RUN echo "c.ServerApp.allow_remote_access = True" > /home/gitpod/.jupyter/jupyter_notebook_config.py

# Set the default command to start JupyterLab
CMD ["/workspace/venv/bin/jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
