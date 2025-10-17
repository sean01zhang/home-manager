# Home manager configuration

## Usage

There are `N` machines using this configuration.

```c
enum Machines {
    seanspc = 0,
    vw,
    mbp,
    N
}

```

Example:

```
nix run home-manager -- switch --flake .#seanspc
```
