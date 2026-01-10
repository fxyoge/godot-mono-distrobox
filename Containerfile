FROM ubuntu:24.04

# renovate: datasource=github-releases packageName=godotengine/godot versioning=loose
ARG GODOT_VERSION=4.5.1-stable

# Install dependencies for Godot Mono with GPU/audio support
# See:
# * https://universal-blue.discourse.group/t/godot-setup-with-c/10236
# * https://www.reddit.com/r/Bazzite/comments/1md0v20/help_artifacting_and_poor_performance_in_distrobox/
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --install-suggests -y \
    mesa-vulkan-drivers mesa-utils vulkan-tools libvulkan1 libxshmfence1 \
    libxcursor1 libxrandr2 libxinerama1 libxi6 libxext6 libx11-6 \
    pulseaudio \
    dotnet-sdk-10.0 \
    wget unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Download and extract Godot Mono
RUN mkdir -p /opt/godot && \
    cd /opt/godot && \
    wget -O godot.zip "https://downloads.godotengine.org/?version=${GODOT_VERSION%-stable}&flavor=stable&slug=mono_linux_x86_64.zip&platform=linux.64" && \
    unzip godot.zip && \
    rm godot.zip && \
    chmod +x Godot_*/Godot_*_mono_linux.x86_64 && \
    ln -s $(find /opt/godot -name "Godot_*_mono_linux.x86_64" -type f) /opt/godot/godot

# Install desktop file
COPY godot.desktop /usr/share/applications/godot.desktop

# Set environment variables for Nvidia GPU support
ENV VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json
ENV VK_LAYER_PATH=/usr/share/vulkan/explicit_layer.d
