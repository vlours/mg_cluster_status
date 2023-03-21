# mg_cluster_status

This bash script will provide the overall status of the must-gather

## Installation and updates

### Requirements

The script use the command `omc` (OpenShift Must-Gather Client)
This command should be installed and available in your PATH on your laptop/server. It's available from download from github <https://github.com/gmeghnag/omc/README.md>

### Installation

* pull the repository

```text
git clone https://github.com/vlours/mg_cluster_status
```

* Create the alias `mg_check` for `mg_cluster_status.sh` in your .bashrc profile (_optional_)

```bash
echo -e "\nalias mg_check=${PWD}/mg_cluster_status/mg_cluster_status.sh" >> ${HOME}/.bashrc
source ${HOME}/.bashrc
```

### Update to latest version (_based on the alias_)

To update to the latest version, you simply have to pull the script from the repository.

```bash
mg_cluster_status_dir=$(dirname $(alias mg_check | cut -d"'" -f2))
cd ${mg_cluster_status_dir}
git pull origin main
```

### Remove the script (_based on the alias_)

```bash
mg_cluster_status_dir=$(dirname $(alias mg_check | cut -d"'" -f2))
if [[ -d ${mg_cluster_status_dir} ]]; then rm ${mg_cluster_status_dir}; fi
sed -i -e "/alias mg_check/d" ${HOME}/.bashrc
```

## Usage

### Basic Usage

* Set the Must-gather to use in `omc` and run the script

```bash
omc use <must-gather-folder>
```

* Run the script with the desired options (_without any parameter the script will run all checks_)

```bash
mg_check 
```

### Advanced Usage

#### Script Options

using the `-h` option will display the help and provide the list of the available options, and the version of the script.

```text
Usage: mg_cluster_status.sh [-acevmnop|-h]
  -a: display the ALERTS
  -c: display the CLUSTER CONTEXT
  -e: display the ETCD status
  -v: display the EVENTS
  -m: display the MCO status
  -n: display the NODES status
  -o: display the OPERATORS status
  -p: display the PODS status
  -h: display this help

version: 1.1.1
```

You can mix the options to display only the desired status:

```bash
mg_check -ae # will only display the alerts and etcd status
mg_check -vp # will only display the events and pods status
mg_check -acevmnop # will have the same display as running the script without options
```

#### Customizable VARIABLES (_optional_)

Before running the script you can set some variables which allow you to customize your outputs

```bash
export OC=/usr/bin/omc    # Where to locate the `omc` command     - Default: omc
export ALERT_TRUNK=100    # Length to trunk alerts descriptions   - Default: 100
export OPERATOR_TRUNK=220 # Length to trunk Operator descriptions - Default: 220
export MIN_RESTART=5      # Minimal restart count for PODs        - Default: 5
```
