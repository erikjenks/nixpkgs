# Nix Config

This is a simple nix flake for managing my dotfiles with home-manager.

## I like your funny words, magic man

Not sure what this all means?

Take a look at [the learn hub on the NixOS
website](https://nixos.org/learn.html) (scroll down to guides, the manuals, and
the other awesome learning resources).

Learning the basics of what Nix (the package manager) is, how the Nix language
works, and a bit of NixOS basics should get you up and running. Don't worry if
it seems a little confusing at first. Get confortable with the basic concepts
and come back here to get your feet wet, it's the best way to learn!

## Bootstrapping

To get everything up and running, you need flake-enabled nix and home-manager.

First off, check your nix version using `nix --version`.

### Version < 2.4

Bummer, your nix version does not support flakes. But fear not!

You _don't_ need to mess around with channels to get up and running.

Just run:
```bash
nix-shell
```

Wow, that was easy. Our `shell.nix` file will detect you can't evaluate (nor
lock) the flake, and will grab `nix` and `home-manager` from the latest
`nixos-unstable` versions, just for you.

### Version >= 2.4

Congrats, your nix version supports flakes! It's just hidden behind a feature flag.

You can bootstrap with: 
```bash
nix develop
```

The shell will also enable those experimental features, so no need to pass that
argument while you're inside (or after installation, if you set the option that
enables them globally).

This should generate a `flake.lock`. Remember to commit it, as this will make
future bootstraps reproductible.

## Usage

- Run `darwin-rebuild switch --flake .#erik@elastic` (or `erik@home`) to apply your
  configuration.
- This is aliased to the `reload` command.

And that's it, really! You're ready to have fun with your configurations using
the latest and greatest nix3 flake-enabled command UX.

# What next?

## User password and secrets

You have basically two ways of setting up default passwords:
- By default, you'll be prompted for a root password when installing with
  `nixos-install`. After you reboot, be sure to add a password to your own
  account and lock root using `sudo passwd -l root`.
- Alternatively, you can specify `initialPassword` for your user. This will
  give your account a default password, be sure to change it after rebooting!
  If you do, you should pass `--no-root-passwd` to `nixos-install`, to skip
  setting a password on the root account.

If you don't want to set your password imperatively, you can also use
`passwordFile` for safely and declaratively setting a password from a file
outside the nix store.

There's also [more advanced options for secret
management](https://nixos.wiki/wiki/Comparison_of_secret_managing_schemes),
including some that can include them (encrypted) into your config repo and/or
nix store, be sure to check them out if you're interested.

## Dotfile management with home-manager

Besides just adding packages to your environment, home-manager can also manage
your dotfiles. I strongly recommend you do, it's awesome!

For full nix goodness, check out the home-manager options with `man
home-configuration.nix`. Using them, you'll be able to fully configure any
program with nix syntax and its powerful abstractions.

Alternatively, if you're still not ready to rewrite all your configs to nix
syntax, there's home-manager options (such as `xdg.configFile`) for including
files from your config repository into your usual dot directories. Add your
existing dotfiles to this repo and try it out!

## Adding custom packages

Something you want to use that's not in nixpkgs yet? You can easily build and
iterate on a derivation (package) from this very repository.

Create a folder with the desired name inside `pkgs`, and add a `default.nix`
file containing a derivation. Be sure to also `callPackage` them on
`pkgs/default.nix`.

You'll be able to refer to that package from anywhere on your
home-manager/nixos configurations, build them with `nix build .#package-name`,
or bring them into your shell with `nix shell .#package-name`.

See [the manual](https://nixos.org/manual/nixpkgs/stable/) for some tips on how
to package stuff.

## Adding overlays

Found some outdated package on nixpkgs you need the latest version of? Perhaps
you want to apply a patch to fix a behaviour you don't like? Nix makes it easy
and manageble with overlays!

Use the `overlay/default.nix` file for this.

If you're creating patches, you can keep them on the `overlay` folder as well.

See [the wiki article](https://nixos.wiki/wiki/Overlays) to see how it all
works.

## Adding more hosts or users

You can organize them by hostname and username on `nixos` and `home-manager`
directories, be sure to also add them to `flake.nix`.

NixOS makes it easy to share common configuration between hosts (you might want
to create a common directory for these), while keeping everything in sync.
home-manager can help you sync your environment (from editor to WM and
everything in between) anywhere you use it. Have fun!

# Bootstrapping on a New Mac

This covers how to get from a fresh macOS install to a fully configured system using this flake.

## Prerequisites

### 1. Install Nix

Use the Determinate Systems installer — it handles macOS-specific quirks better than the official installer and ships with flakes enabled out of the box:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Open a new terminal after installation so `nix` is on your PATH.

### 2. Install Xcode Command Line Tools

Required for some build steps:

```bash
xcode-select --install
```

### 3. Fix `/etc/zshrc` conflict

nix-darwin manages `/etc/zshrc` and `/etc/bashrc`, but macOS ships with its own versions. Move them out of the way before proceeding:

```bash
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
```

## Clone the Repo

```bash
git clone https://github.com/erikjenks/nixpkgs.git ~/nixpkgs
cd ~/nixpkgs
git checkout 25.11
```

## Bootstrap the Dev Shell

Enter the dev shell to get `home-manager` and flake support available:

```bash
nix develop
```

## First-Time nix-darwin Install

`darwin-rebuild` doesn't exist yet on a fresh machine, so the first activation uses `nix run`:

```bash
nix run nix-darwin -- switch --flake .#erik@elastic
```

Swap `erik@elastic` for `erik@home` if you're setting up a personal machine. After this completes, `darwin-rebuild` will be on your PATH.

## All Future Rebuilds

```bash
darwin-rebuild switch --flake .#erik@elastic
# or the alias:
reload
```

---

## Troubleshooting

### Hash mismatch on Apple Fonts

If `nix develop` fails with a `hash mismatch` error on one of the SF font `.dmg` files (SF-Compact, SF-Pro, etc.), the file has been updated at Apple's download URL without the flake hash being updated. The error output will show you both the old hash and the correct new one:

```
specified: sha256-<old-hash>
got:       sha256-<new-hash>
```

Open the relevant file in `nix/apple-fonts/` and replace the `sha256` with the value shown in the `got:` line, then re-run `nix develop`. Commit the fix so future bootstraps work cleanly.

### Tree-sitter grammar 404 errors

If the first `darwin-rebuild switch` fails with an HTTP 404 on a tree-sitter grammar archive (e.g. `tree-sitter-go-template`), the pinned commit no longer exists upstream. You have three options:

**Remove the grammar** (quickest, if you don't use that language):

Find and remove the grammar entry from your helix config in `nix/`.

**Update to a valid commit:**

```bash
nix-prefetch-url --unpack "https://github.com/<owner>/<grammar-repo>/archive/HEAD.tar.gz"
```

Update both the `rev` and `sha256` in your grammar definition to match.

**Bump the helix input:**

```bash
nix flake update helix
```

This pulls the latest helix release and its updated grammar pins. Update `flake.nix` to point at a newer release tag if you want to stay pinned.

### Hostname mismatch

nix-darwin matches the flake target to your machine's hostname. If the build fails to find your configuration, check:

```bash
hostname
```

Pass the target explicitly to work around it:

```bash
nix run nix-darwin -- switch --flake .#erik@elastic
```

To rename your Mac to match: **System Settings → General → About → Name**.
