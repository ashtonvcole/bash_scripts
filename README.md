# Bash Scripts

The following is a collection of quality-of-life shortcut scripts I use for my own workflows.

## Installation and Usage

After cloning this repository, copy or symbolically link desired scripts to a location contained in your `$PATH` variable. Scripts are then ready to use.

I recommend against tampering with sudo-protected locations like `/usr/local/bin`. The path variable can be appended to in `.bashenv` or `.zshenv`.

```
cp path/to/bash_scripts/figuregen.sh $HOME/.local/bin/figuregen
```

```
ln -s path/to/bash_scripts/figuregen.sh $HOME/.local/bin/figuregen
```

## Contents

- [`apptainer_wrapper.sh`](apptainer_wrapper.sh): Generic wrapper for running a containerized program with Apptainer.
- [`apptainer_wrapper_mpi.sh`](apptainer_wrapper.sh): Generic wrapper for running a MPI-parallelized containerized program with Apptainer.
- [`figuregen-serial.sh`](figuregen-serial.sh): Containerized plotting program for [ADCIRC](https://adcirc.org/).
- [`figuregen.sh`](figuregen-serial.sh): MPI-parallelized containerized plotting program for [ADCIRC](https://adcirc.org/).
- [`gwa.sh`](gwa.sh): Shortcut for `git worktree add`. This is meant to be used in tandem with `gwc`.
- [`gwc.sh`](gwc.sh): Shortcut for `git clone` with special options to set up a clean worktree hierarchy.
