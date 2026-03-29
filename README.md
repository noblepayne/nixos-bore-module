# bore-server

NixOS module for running your own [bore](https://github.com/ekzhang/bore) tunnel server.

## Quick Start

```nix
{
  inputs.bore-server.url = "github:Properly-effortless/bore-server";

  imports = [inputs.bore-server.nixosModules.bore-server];

  services.bore-server = {
    enable = true;
    minPort = 19990;
    maxPort = 19992;
  };
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | bool | `false` | Enable bore server |
| `bindAddress` | string | `"0.0.0.0"` | Bind address |
| `minPort` / `maxPort` | int | `1024` / `65535` | Port range |
| `credentialsFile` | path | `null` | Auth secret file |

## Security

Hardened systemd service: dynamic user, capability bounding, private tmp/system/home.

MIT