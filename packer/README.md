# Talos Packer

This directory contains the packer configuration to create a Talos snapshot.

## Create Talos Snapshot

For the terraform scripts to run, we need to have the talos snapshot available. To create the snapshot, follow the steps below:

```bash
# Initialize Packer
packer init

# Build the snapshot
packer build
```
