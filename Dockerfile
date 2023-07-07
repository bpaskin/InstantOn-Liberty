FROM icr.io/appcafe/websphere-liberty:full-java17-openj9-ubi

COPY --chown=1001:0 target/modresorts-1.0.war /config/apps/modresorts-1.0.war
COPY --chown=1001:0 server.xml                /config/server.xml

RUN configure.sh
RUN checkpoint.sh afterAppStart

# Requires Linux Kernel 5.9 or later and criu installed
# For SELinux this may need to be set set: 
#   setsebool virt_sandbox_use_netlink 1
# To build the image:
#   podman build -t modresorts --cap-add=CHECKPOINT_RESTORE --cap-add=SYS_PTRACE --cap-add=SETPCAP --security-opt seccomp=unconfined . 
# To run the image:
#   podman run -d --name modresorts --cap-add=CHECKPOINT_RESTORE --cap-add=SETPCAP -p 9080:9080 modresort
