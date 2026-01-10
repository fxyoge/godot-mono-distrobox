default:
    @just --list

distrobox-name := "godot-mono-ubuntu"

build: clean-distrobox
    podman image exists "localhost/{{distrobox-name}}" || podman build -t {{distrobox-name}} -f Containerfile .
    distrobox create --name {{distrobox-name}} --image "localhost/{{distrobox-name}}" --nvidia || true
    distrobox enter {{distrobox-name}} -- distrobox-export --bin /opt/godot/godot --export-path ~/.local/bin
    distrobox enter {{distrobox-name}} -- distrobox-export --app /usr/share/applications/godot.desktop --export-path ~/.local/share/applications
    echo "✓ Build complete! Run 'godot' to launch Godot Engine."

shell:
    distrobox enter {{distrobox-name}}

[private]
clean-distrobox:
    distrobox rm -f {{distrobox-name}} || true

clean: clean-distrobox
    podman rmi -f {{distrobox-name}} || true
