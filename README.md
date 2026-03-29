# bore-server NixOS module

A NixOS module for running your own [bore](https://github.com/ekzhang/bore) tunnel server.

## Usage

```nix
{
  inputs = {
    bore-server.url = "github: Properly-effortless/bore-server";
  };

  imports = [inputs.bore-server.nixosModules.bore-server];

  services.bore-server = {
    enable = true;
    bindAddress = "0.0.0.0";
    minPort = 19990;
    maxPort = 19992;
    credentialsFile = "/etc/nixos/secrets/bore";
  };
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | bool | `false` | Enable the bore server |
| `package` | package | `pkgs.bore-cli` | The bore-cli package |
| `bindAddress` | string | `"0.0.0.0"` | Address to bind to |
| `minPort` | int | `1024` | Minimum tunnel port |
| `maxPort` | int | `65535` | Maximum tunnel port |
| `credentialsFile` | path | `null` | Path to auth secret file |

## Security

The module runs bore with a hardened systemd service:
- Dynamic user
- Capabilities limited to `CAP_NET_BIND_SERVICE`
- Private tmp, system, home

## License

MIT
