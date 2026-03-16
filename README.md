# NixOS on precision

An overview and quick reference of Evie's development laptop.

## Contents

- [Documentation links](#documentation)
- [Common tasks](#common-tasks)
- [Flake configuration](#flake-configuration)
- [Document search and tagging](#document-search-and-tagging)
- [Thermal management and stress testing](#thermal-management-and-stress-testing)
- [Monitoring with prometheus and grafana](#monitoring-with-prometheus-and-grafana)
- [BTRFS snapshot monitoring services](#btrfs-snapshot-monitoring-services)
- [Resource isolation via systemd slices](#resource-isolation-via-systemd-slices)
- [Profiling with BPF](#profiling-with-bpf)
- [Conceptual overview of Nix and NixOS](#conceptual-overview-of-nix-and-nixos)

## Documentation links

- [Arch Wiki](https://wiki.archlinux.org/index.php/Main_Page)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nix Language Basics](https://nix.dev/manual/nix/stable/language/)
- [NixOS Wiki](https://nixos.wiki/)
- [Grafana Docs](https://grafana.com/docs/grafana/latest/)
- [Prometheus Docs](https://prometheus.io/docs/introduction/overview/)
- [bpftrace Reference](https://github.com/bpftrace/bpftrace/blob/master/docs/reference_guide.md)
- [BCC Tools](https://github.com/iovisor/bcc)

## Common tasks

```bash
# Install a package temporarily in an ephemeral shell,
# which is conceptually similar to a python venv,
# but works with system packages.
nix-shell -p $package

# Search for packages in the nixos repository.
nix search nixpkgs $query
# Get filesize and closure size of a nix package.
nix path-info -sS "nixpkgs#$packageName"

# List all bootable package combinations, known as generations.
nixos-rebuild list-generations
# Delete all old generations and garbage collect their store paths.
sudo nix-collect-garbage -d
# Remove any remaining orphaned store paths.
nix-store --gc

# Edit the system configuration.
nvim /etc/nixos/configuration.nix
# Realize the system configuration into the current system
# generation and create a boot entry for it.
sudo nixos-rebuild switch --flake /etc/nixos#precision
# Make the running system match the config without adding a bootloader entry.
sudo nixos-rebuild test --flake /etc/nixos#precision
# Roll back to a previous generation.
sudo nixos-rebuild switch --rollback

# Update flake inputs (nixpkgs and llm-agents).
nix flake update --flake /etc/nixos
# Update only the llm-agents input for latest AI tool versions.
nix flake update llm-agents --flake /etc/nixos

# Create manual snapshot of /home
snapper -c home create -d "before risky change"
# List snapshots of /home
snapper -c home list
# Compare snapshots of /home
snapper -c home diff $n..$n2
# Restore file from snapshot of /home
snapper -c home undochange $n..$n2 $path
# Delete specific snapshot of /home
snapper -c home delete $n
# Cleanup snapshots of /home by snapshot number
sudo snapper -c home cleanup number
```

## Flake configuration

The system configuration uses Nix flakes for reproducible builds and
access to frequently updated external packages.

The flake at `/etc/nixos/flake.nix` defines two inputs.
`nixpkgs` points to nixos-unstable for system packages.
`llm-agents` points to `github:numtide/llm-agents.nix`,
which provides AI coding tools updated daily.

AI tools from llm-agents include claude-code, amp, gemini-cli,
codex, opencode, and copilot-cli.
These update more frequently than nixpkgs,
so running `nix flake update llm-agents` fetches
the latest versions without touching the rest of the system.

The `flake.lock` file pins exact commit hashes for all inputs.
This ensures builds are reproducible across machines.
Running `nix flake update` refreshes all pins to their latest versions.

## Document search and tagging

I've attempted to organize my documents using tags and search.
CLI based pdf/docx search uses `rga`, GUI search uses `recoll`,
and tag-based file searching uses `tmsu`. Digikam is available for
photo management.

## Bookmark management with buku and bukuserver

Bookmarks are managed with `buku`,
a command-line bookmark manager backed by SQLite.
The database lives at `~/.local/share/buku/bookmarks.db`.
Use `buku` on the CLI for tagging, searching, and bulk operations.

Bukuserver provides a web UI and REST API
for browsing, searching, and adding bookmarks from the browser.
It reads and writes the same SQLite database as the CLI,
so changes on either side are immediately visible to the other.
The web UI runs at `http://127.0.0.1:5001`
and the Swagger API docs are at `http://127.0.0.1:5001/apidocs`.

Bukuserver is installed via `uv tool install "buku[server]"`
because the nixpkgs buku derivation has broken test dependencies
when `withServer = true` is enabled.
The PyPI release (5.1) was also missing the `apidocs/template.yml` file,
so it was copied from the nixpkgs store path into the uv tool environment.
The buku CLI itself is still managed by nixpkgs in `configuration.nix`.

A systemd user service at `~/.config/systemd/user/bukuserver.service`
starts bukuserver automatically on login.

```bash
# CLI bookmark operations
buku --nostdin -p              # print all bookmarks
buku --nostdin --stag          # list all tags with counts
buku --nostdin -s guitar       # search bookmarks
buku --nostdin -u 42 --tag foo # set tags on bookmark 42

# Bukuserver management
systemctl --user status bukuserver
systemctl --user restart bukuserver
```

Tags follow a `category-subcategory` convention.
Major categories include `music-`, `python-`, `lang-`,
`aws-`, `devops-`, `linux-`, `db-`, `hashicorp-`, and `misc-`.

## Thermal management and stress testing

The Dell Precision 5520 uses Intel DPTF for thermal policy management.
A systemd-tmpfiles rule activates the passive thermal policy at boot
by writing the appropriate UUID to `/sys/bus/platform/devices/INT3400:00/uuids/current_uuid`.
This is required since kernel 5.18 changed the default behavior.

The EC (Embedded Controller) handles fan control dynamically based on temperature.
Fans ramp from around 2500 RPM at idle (65°C) up to 5100 RPM under heavy load (90°C).
thermald runs with `--adaptive` mode for additional CPU power management via RAPL.

The EC is probably dying. Even after a repaste, replacing the
fans, and extensive troubleshooting, fans sometimes get pegged
to max, or don't spin, and the laptop turns into a space heater.
Even if I don't start an OS and leave it on the UEFI firmware
page, this still happens.

### Stress testing tools

```bash
# CPU stress test with all cores for 60 seconds
stress-ng --cpu 8 --timeout 60s

# GPU stress test with FurMark (OpenGL)
furmark
# Or the CLI version
FurMark_GUI

# GPU benchmark with glmark2
glmark2

# Monitor temperatures while stress testing
watch -n 1 'sensors | grep -E "Package|fan"'
```

### Thermal thresholds

| Temperature | Fan Speed | Status                      |
| ----------- | --------- | --------------------------- |
| ~65°C       | ~2500 RPM | Idle, quiet                 |
| ~80°C       | ~3500 RPM | Light load                  |
| ~85°C       | ~4100 RPM | Moderate load               |
| ~90°C       | ~5100 RPM | Heavy load, maximum cooling |
| 100°C       | N/A       | Thermal throttling begins   |

## Monitoring with Prometheus and Grafana

The monitoring stack tracks system health through six specialized exporters feeding into Prometheus, with Grafana dashboards that provision automatically on system rebuild. This replaces the previous setup where dashboards had to be manually imported.

Grafana runs at http://localhost:3000 for visualizing metrics and setting up alerts. Prometheus runs at http://localhost:9090 for storing time-series data and handling queries. The node_exporter on port 9100 exposes system metrics including CPU temperatures, fan speeds, memory, disk, and network statistics. The nvidia_gpu_exporter on port 9835 tracks GPU temperature, utilization, memory usage, and clock speeds.

The process-exporter on port 9256 solves the problem of identifying which specific process is consuming resources when the system is under load. Without it, you only see aggregate CPU and memory usage, which meant SSH-ing in to run top manually whenever something went wrong. The smartctl-exporter on port 9633 monitors disk health through SMART data, catching failing drives before they die by tracking reallocated sectors, wear indicators, and temperature trends. The cAdvisor instance on port 8080 provides container metrics for podman, and the libvirt-exporter on port 9177 tracks resource consumption of VMs.

The Dell Precision 5520 hardware monitoring dashboard shows CPU core temperatures and utilization per core, GPU metrics, both system fans with their actual RPM against target values, fan PWM duty cycle, NVMe temperature, chipset temperature, and the Dell SMM sensor readings. The dashboard updates every 5 seconds and uses color-coded thresholds so overheating is immediately visible.

Dashboards live in `/etc/nixos/dashboards/` and are version controlled alongside the system configuration. Changes to dashboards get picked up automatically on the next system rebuild.

## BTRFS snapshot monitoring services

Before this install, a broken snapper retention schedule
filled up the disk with thousands of BTRFS snapshots of /home,
so we have automatic cleanup scripts to prevent that.

The `btrfs-metadata-monitor` service runs every 15 minutes and alerts on high metadata usage, and `snapshot-watchdog` runs daily and forces cleanup if snapshots exceed 50.

## Resource isolation via systemd slices

We set up cgroup slices to prioritize the UI, since
IRQ storms from the touchpad caused resource contention that
slowed down the UI.

`session.slice` (CPUWeight 500, IOWeight 500) contains kwin, pipewire, and plasmashell.
`app.slice` (CPUWeight 100, IOWeight 100) contains Chrome, Zed, and user apps.
`background.slice` (CPUWeight 20, IOWeight 20) contains kactivitymanager and background jobs.

## Profiling with BPF

There are some tools installed for ad-hoc performance profiling.
The `bpftrace` and `bcc` packages provide CLI tools that let you
query performance info using BPF, which is a framework for running
arbitrary VM code in the memory space of the kernel.
It's a wonderfully versatile tool for visibility and troubleshooting.
Read up on Brendan Gregg and BPF to learn more.

```bash
# Find out who is doing disk IO right now.
sudo bpftrace -e 'tracepoint:block:block_rq_issue {
  printf("%s %d %d\n", comm, args.bytes, args.sector);
}'
# Find out which calls are slow with a syscall latency histogram.
sudo bpftrace -e 'tracepoint:raw_syscalls:sys_exit {
  @usecs = hist(nsecs - @start[tid]);
}
tracepoint:raw_syscalls:sys_enter {
  @start[tid] = nsecs;
}'
# Show which processes are waking up the CPU for power debugging.
sudo timeout 10 bpftrace -e 'tracepoint:sched:sched_wakeup {
  @[comm] = count();
}'
# Measure TCP connection latency.
sudo bpftrace -e 'kprobe:tcp_v4_connect {
  @start[tid] = nsecs;
}
kretprobe:tcp_v4_connect /@start[tid]/ {
  @us = hist((nsecs - @start[tid]) / 1000);
  delete(@start[tid]);
}'
# Display filesystem latency by operation.
sudo bpftrace -e 'kprobe:vfs_read {
  @start[tid] = nsecs;
} kretprobe:vfs_read /@start[tid]/ {
  @read_us = hist((nsecs - @start[tid]) / 1000);
  delete(@start[tid]);
}'
```

## Conceptual overview of Nix and NixOS

Nix is a combination of package manager
purely functional programming language,
configuration management tool,
and declarative configuration format.

All packages and configurations are represnted
as programs in the Nix language.
This is interesting because Nix
aspires to be functional.
Functional programs emphasize expressions that
evaluate input values to a result,
without performing side-effects.
Even though Nix doesn't have a pure seperation
of expression and side-effect,
it gets most of the way there.
The opportunities for randomness or IO
that make rpm spec builds difficult to reproduce
bit-by-bit are reduced.

Nix can describe entire systems as expressions.
The `/etc/nixos/configuration.nix` file
defines entire NixOS systems declaritively.
This includes not only package lists or boot options,
but possible configuration for every program.
You can put your vimrc in there.

The results of a package definition expression,
or config expression, against config inputs
results in precise build instructions known as a derivation
that the nix package manager can then use as a source
for execution. This execution phase by the package
manager is where file modifications and mutation happen.

If you run `nixos-rebuild switch`, the nix package manager
will evalute `configuration.nix`, create a derivation,
and then build that into a generation.

--- mark ---

To so do, first it will evalute the file.
Then it will build whatever packages or configs have changed,
and assembles the result into a bootable system state
called a generation, and switch the running state to the new generation.
That generation gets symlinked under `/nix/var/nix/profiles/system`
and an entry is added to the boot manager
so you can easily boot to a previous version.

When a derivation is built,
it produces an immutable artifact in `/nix/store`,
which is identified by a hash of all its inputs.
This means package contents on the FS aren't modified in
place like a traditional package manager would.
Instead a new build is added to its own directory
in the store and composed into a system profile
that gets symlinked to `/run/current-system`.
This gives you a lot of granularity.
Not only can you have multiple versions of a package at once,
you can have multiple builds of it,
all depending on their own libraries,
which I think of as a lightweight
mini-container without enforced isolation.

A closure is the set of all store paths that
a package depends on, directly or indirectly.
Because store paths are hash-addressed and immutable,
closures can coexist without conflict.
Two packages that need different versions of the same library
simply reference different store paths.

The central package repository is called nixpkgs, but
there are other repos available.
One unique thing about nix repos is that instead of splitting
the index and package definitions, the central repos actually
contain expressions for how to build all of the packages
they contain.

To refer to repos, we can use channels or flakes.

A channel is a named URL that points to a remote
set of Nix expressions (usually Nixpkgs).
Running nix-channel --update downloads the latest
channel contents to your machine.

Flakes are an alternative that pin repo names to
specific commit hashes. In a `flake.nix` file you
specify the repo name and url. In `flake.lock` the
specific commit hash of the repo at that time gets
recorded.
