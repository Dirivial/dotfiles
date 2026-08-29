# Raspberry Pi public edge

Install Caddy on the Home Assistant Raspberry Pi and deploy `Caddyfile` to
`/etc/caddy/Caddyfile`, after replacing `immich.example.com` with the public
hostname. Cloudflare must be DNS-only for that record.

Forward only TCP 80 and 443 on the home router to the Pi. The Pi must have a
static DHCP lease. On the desktop, set
`alkade.desktopHomelab.homeAssistantAddress` to the Pi's static LAN address;
that enables the firewall exception allowing the Pi to reach Immich.

Do not add Caddy routes for Ollama, LiteLLM, Whisper, Syncthing, or the Caddy
admin API.
