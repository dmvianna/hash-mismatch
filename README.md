# hash-mismatch

This repo is a minimal example that fails to build a virtual machine
image in my local system, but succeeds elsewhere.

## Symptoms

```
❯ nix build #example
error: builder for '/nix/store/izn7vn2vmnzia0q74ypqs7prxniadm3q-google-compute-image.drv' failed with exit code 1;
       last 25 log lines:
       > copying path '/nix/store/4h20q5nm4qzkak28xqzgj5rbcps7a6lp-shadow-4.14.3-man' to 'local'...
       > copying path '/nix/store/knwmzmz566n49zz5qz35s6kq0aa19nwq-runuser.pam' to 'local'...
       > copying path '/nix/store/jvfhzshp2djbh9lk3jxrscb8dnq90a4d-rules-checkrules-checked' to 'local'...
       > copying path '/nix/store/20ch4pydzrk3i862ngb508s546d9414v-sound-theme-freedesktop-0.8' to 'local'...
       > error: hash mismatch importing path '/nix/store/jvfhzshp2djbh9lk3jxrscb8dnq90a4d-rules-checkrules-checked';
       >          specified: sha256:0phrw2p8q5hlxshm62ns310rlrg32g9y4rjn2d3191x2n83i6wmv
       >          got:       sha256:0ip26j2h11n1kgkz36rl4akv694yz65hr72q4kv4b3lxcbi65b3p
       > copying path '/nix/store/7pq6gz7i2ljm60kzkcs30rv9kq07zgwc-stub-ld-i686-unknown-linux-musl' to 'local'...
       > copying path '/nix/store/986s7f4r1accyqpcvp6psmyw48jkqxfp-stub-ld-x86_64-unknown-linux-musl' to 'local'...
       > copying path '/nix/store/w1qa2pbha6xd0fyf90z1ycn8pd1arlbd-sudo.pam' to 'local'...
       > copying path '/nix/store/gq49a89mfcawpr77swi6i4c2x7q4nhyh-sudoers' to 'local'...
       > copying path '/nix/store/a8557hhvi2xvw5skax3qmqvgsd8r8gyr-system-generators' to 'local'...
       > copying path '/nix/store/nnxndk0fwiy1rkljpl3qnjrm2arq7wl4-system-shutdown' to 'local'...
       > copying path '/nix/store/1v6d5xd3s27p4fkxvpnn6rf25whiz3xg-systemd-255.2-man' to 'local'...
       > copying path '/nix/store/lb1z8nckdwx4kmwy19znh1bl1p63wxhv-tzdata-2024a' to 'local'...
       > copying path '/nix/store/xy0h1d9asscgas3ambw9zrfys4is97wc-unit-40-eth0.link' to 'local'...
       > copying path '/nix/store/mcgcw88jfdfirnjsnr3ycpk0n7ga5k2w-unit-dbus.socket' to 'local'...
       > copying path '/nix/store/chyw7jd5ijlnzjy351k94ngh5zrh5j8b-unit-nixos-fake-graphical-session.target' to 'local'...
       > copying path '/nix/store/zqd769kn01lfwqzkscrfvpjsyjz15g8a-useradd' to 'local'...
       > copying path '/nix/store/yrxdabhka34pzkfy0zfwc2bqb8crfqwj-util-linux-2.39.3-man' to 'local'...
       > copying path '/nix/store/hihnkpyd5av509x6cz2i5zhf04j57fyh-xgcc-13.2.0-libgcc' to 'local'...
       > copying path '/nix/store/4ma067fj4pia7sfn61ll2dnqfd3b1y7b-xz-5.4.6-doc' to 'local'...
       > copying path '/nix/store/01h0wg24n16ljxghslnccbwcw3bg5wmy-xz-5.4.6-man' to 'local'...
       > copying path '/nix/store/bqfd70zg7c6pr5zkrbhpy8lmddm30rk4-zstd-1.5.5-man' to 'local'...
       > error: build of '/nix/store/i7jhlgqn7z0brwplfmmrvgsq9vh0fc7r-nixos-system-unnamed-24.05.20240224.73de017' failed
       For full logs, run 'nix log /nix/store/izn7vn2vmnzia0q74ypqs7prxniadm3q-google-compute-image.drv'.
```
There is a _hash mismatch_ in
`/nix/store/jvfhzshp2djbh9lk3jxrscb8dnq90a4d-rules-checkrules-checked`,
which is not a file, but a symlink to
`/nix/store/79anwpzm0jsz27yfyh52y71skvrv8s2k-prometheus.rules`. The
most aggravating thing is that the latter is an **empty file**, both
in my machine and in the other machines that build successfully.

## What did I try already?

- `nix build #example --option build-fallback true` -- fails as above
- `nix store verify --all --no-trust` -- returns nothing
- `rm -rf /nix`;
  `rm -rf ~/.cache/nix ~/.nix-channels ~/.nix-defexpr
  ~/.nix-profile`; `sudo rm -rf /etc/nix`;
  `sh <(curl -L https://nixos.org/nix/install) --no-daemon`
  -- removing **Nix** and reinstalling it did not fix the problem
- `nix flake update` -- still failing the same way
- Update the `nix`  binary from 2.19 to 2.20.3 -- no change

## Is there a build log?
[Yes.](./build.log)

## What kind of OS am I using?
 - system: `"x86_64-linux"`
 - host os: `Linux 6.7.5-200.fc39.x86_64, Fedora Linux, 39 (Workstation Edition), nobuild`
 - multi-user?: `no`
 - sandbox: `yes`
 - version: `nix-env (Nix) 2.20.3`
 - nixpkgs: `/home/dmvianna/.nix-defexpr/channels/nixpkgs`

## What kind of OS builds this correctly?

 - system: `"x86_64-linux"`
 - host os: `Linux 6.1.69, NixOS, 23.05 (Stoat), 23.05.5533.70bdadeb94ff`
 - multi-user?: `yes`
 - sandbox: `yes`
 - version: `nix-env (Nix) 2.15.3`
 - channels(root): `"nixos-23.05, nixos-hardware, unstable"`
 - nixpkgs: `/nix/var/nix/profiles/per-user/root/channels/nixos`
