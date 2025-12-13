# Alpine Linux ~5 MB
FROM alpine:latest

# Install minimal prerequisites
RUN apk add --no-cache \
    bash \
    curl \
    git \
    sudo \
    zsh

# Create non-root user
RUN adduser -D -s /bin/bash testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER testuser
WORKDIR /home/testuser

# Copy dotfiles
COPY --chown=testuser:testuser . /home/testuser/dotfiles

WORKDIR /home/testuser/dotfiles

# Run setup in dry-run mode
CMD ["./setup.sh", "--dry-run"]
