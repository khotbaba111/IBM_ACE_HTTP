# Base image: IBM ACE v11 (already downloaded locally)
FROM ibmcom/ace:11.0.0.6.3-amd64

# Accept license and set environment variables
ENV LICENSE=accept
ENV LANG=en_US.UTF-8
ENV MQSI_BASE_DIRECTORY=/opt/ibm/ace-11


# Copy your BAR file into the image
COPY docker.bar /home/aceuser/initial-config/bars/

# Optional: Copy custom server config
# COPY server.conf.yaml /home/aceuser/initial-config/

# Switch to non-root user
USER aceuser

# Start Integration Server
CMD ["IntegrationServer", "--name", "MyIntegrationServer2", "--work-dir", "/home/aceuser/ace-server"]
