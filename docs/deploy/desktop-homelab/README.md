# Desktop homelab activation

The desktop configuration enables Syncthing, Tailscale, Docker with the Nvidia
container toolkit, Ollama with `qwen3:8b`, GPU-backed Wyoming Faster Whisper,
Immich, and LiteLLM.

Before switching the system, create the two root-owned secret files from the
adjacent examples:

```sh
sudo install -d -m 0750 /etc/immich /etc/litellm
openssl rand -hex 32 | sudo tee /etc/immich/immich.env >/dev/null
sudo sed -i 's/^/DB_PASSWORD=/' /etc/immich/immich.env
openssl rand -hex 32 | sudo tee /etc/litellm/litellm.env >/dev/null
sudo sed -i 's/^/LITELLM_MASTER_KEY=/' /etc/litellm/litellm.env
sudo chown root:root /etc/immich/immich.env
sudo chmod 0600 /etc/immich/immich.env
sudo chown root:litellm /etc/litellm/litellm.env
sudo chmod 0640 /etc/litellm/litellm.env
```

Set the Raspberry Pi's static LAN address in
`nix/hosts/desktop/configuration.nix` before applying:

```nix
alkade.desktopHomelab = {
  enable = true;
  homeAssistantAddress = "192.168.1.20";
};
```

Replace the existing single `enable = true` assignment rather than adding a
second one. This allows only that address to reach Immich (2283), Wyoming STT
(10300), and LiteLLM (4000). The default `null` value keeps those ports blocked.

Apply with:

```sh
cd /home/alkade/dotfiles/nix
sudo nixos-rebuild switch --flake .#desktop
```

After the first boot:

1. authenticate Tailscale with `sudo tailscale up`;
2. pair the laptop in the local Syncthing GUI at `http://127.0.0.1:8384` and
   create the shared workspace folder;
3. add the desktop's `desktop.lan:10300` and Pi's `127.0.0.1:10200` Wyoming
   services in Home Assistant;
4. configure Home Assistant's authenticated OpenAI-compatible client to use
   `http://desktop.lan:4000/v1` and the value from `/etc/litellm/litellm.env`;
5. open Immich from the LAN, create the initial account, then deploy the Pi
   Caddy configuration and test the public hostname.

The first Ollama and Whisper starts download their selected model files. Monitor
progress with `systemctl status ollama-model-loader wyoming-faster-whisper` and
verify GPU use during inference with `nvidia-smi`.
