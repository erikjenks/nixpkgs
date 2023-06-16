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
nix --experimental-features develop "nix-command flakes" .#bridge
```

The shell will also enable those experimental features, so no need to pass that
argument while you're inside (or after installation, if you set the option that
enables them globally).

This should generate a `flake.lock`. Remember to commit it, as this will make
future bootstraps reproductible.

## Usage

- Run `home-manager switch --flake .#bridge` to apply your home
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
