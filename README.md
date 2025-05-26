# mg_cluster_status

This bash script will provide the overall cluster status from live `oc` commands or from a `must-gather`.

## Installation and updates

### Requirements

For live analysis, the `oc` command should be available and logged into the desired cluster.

For the Must-gather analysis, the script use the command `omc` (OpenShift Must-Gather Client)
This command should be installed and available in your PATH on your laptop/server. It's available for download from github <https://github.com/gmeghnag/omc/#readme>

The variable `OC` needs to be set accordingly to the context.

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
mg_cluster_status_dir=$(dirname $(alias mg_check | cut -d"'" -f2)); cd ${mg_cluster_status_dir}; git pull origin main; cd -
```

### Remove the script (_based on the alias_)

```bash
mg_cluster_status_dir=$(dirname $(alias mg_check | cut -d"'" -f2))
if [[ -d ${mg_cluster_status_dir} ]]; then rm ${mg_cluster_status_dir}; fi
sed -i -e "/alias mg_check/d" ${HOME}/.bashrc
```

## Usage

### Basic Usage

1. Must-gather analysis

    * Set the Must-gather to use in `omc` and run the script

      ```bash
      omc use <must-gather-folder>
      ```

    * Run the script with the desired options (_without any parameter the script will run all checks_)

      ```bash
      mg_check
      ```

2. Live cluster analysis

    * login to the cluster and set the `OC` variable

      ```bash
      oc login URI:6443 -u <username>
      export OC=$(which oc | awk '{print $NF}')
      ```

    * Run the script with the desired options (_without any parameter the script will run all checks_)

      ```bash
      mg_check
      ```

### Advanced Usage

#### Script Options

Using the `-h` option will display the help and provide the list of the available options, and the version of the script.
Adding the `-d` option with the `-h` option will display the customizable variables (including colors for colorblind persons)

```text
usage: mg_cluster_status.sh [-acevMmnopsS] [-N namespace] [-d] [-h]
|---------------------------------------------------------------------------------------|
| Options | Description                                                     | [Details] |
|---------|-----------------------------------------------------------------|-----------|
|      -a | display the ALERTS                                              |           |
|      -c | display the CLUSTER CONTEXT                                     |           |
|      -e | display the ETCD status                                         |           |
|      -v | display the EVENTS                                              |           |
|      -M | display the MACHINES status                                     | [Y]       |
|      -m | display the MCO status                                          | [Y]       |
|      -N | set a namespace to filter the SCC and PODs                      |           |
|      -n | display the NODES status                                        | [Y]       |
|      -o | display the OPERATORS status                                    | [Y]       |
|      -p | display the PODS status                                         | [Y]       |
|      -s | display the STATIC PODs status                                  | [Y]       |
|      -S | display the SecurityContextConstraints                          | [Y]       |
|---------|-----------------------------------------------------------------|-----------|
|         | Additional Options:                                             |           |
|---------|-----------------------------------------------------------------|-----------|
|      -d | display additional details on specific Options (as noted above) |           |
|      -h | display this help and check for updated version                 | [Y]       |
|---------------------------------------------------------------------------------------|

Customizable variables before running the script (Optional):
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Options                           | Type         | Description                                                                                  | [Default]  | [Current] |
|-----------------------------------|--------------|----------------------------------------------------------------------------------------------|------------|-----------|
| export OC=                        | <executable> | #Change the must-gather tool (use 'oc' to run the script against live cluster)               | [omc]      |           |
| export ALERT_TRUNK=               | <interger>   | #Change the length of the Alert Descriptions                                                 | [100]      |           |
| export CONDITION_TRUNK=           | <interger>   | #Change the length of the Operator Message in 'oc get co'                                    | [220]      |           |
| export POD_TRUNK=                 | <interger>   | #Change the length of the POD Message in 'oc get pod'                                        | [100]      |           |
| export POD_WIDE=                  | <boolean>    | #Enable/Disable the '-o wide' option in the command 'oc get pod'                             | [true]     |           |
| export MIN_RESTART=               | <integer>    | #Change the minimal number of restart when checking the POD restarts                         | [10]       |           |
| export NODE_TRANSITION_DAYS=      | <interger>   | #Change the value to highlight the conditions[].lastTransitionTime for the Nodes & SCC       | [30]       |           |
| export OPERATOR_TRANSITION_DAYS=  | <interger>   | #Change the value to highlight the conditions[].lastTransitionTime for the Cluster Operators | [2]        |           |
| export TAIL_LOG=                  | <integer>    | #Change the number of lines displayed from logs ('tail')                                     | [15]       |           |
| export graytext=                  | <color_code> | #Replace the gray color used in the script                                                   | [\x1B[30m] |           |
| export redtext=                   | <color_code> | #Replace the red color used in the script                                                    | [\x1B[31m] |           |
| export greentext=                 | <color_code> | #Replace the green color used in the script                                                  | [\x1B[32m] |           |
| export yellowtext=                | <color_code> | #Replace the yellow color used in the script                                                 | [\x1B[33m] |           |
| export bluetext=                  | <color_code> | #Replace the blue color used in the script                                                   | [\x1B[34m] |           |
| export purpletext=                | <color_code> | #Replace the purple color used in the script                                                 | [\x1B[35m] |           |
| export cyantext=                  | <color_code> | #Replace the cyan color used in the script                                                   | [\x1B[36m] |           |
| export whitetext=                 | <color_code> | #Replace the white color used in the script                                                  | [\x1B[37m] |           |
| export resetcolor=                | <color_code> | #Replace the color used to rest colors in the script                                         | [\x1B[0m]  |           |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

Current Version:  X.Y.Z - The script is up-to-date. Thanks
```

You can mix the options to display only the desired status:

```bash
mg_check -ae # will only display the alerts and etcd status
mg_check -vp # will only display the events and pods status
mg_check -acevMmnopsS # will have the same display as running the script without options
```

You can filter on a specific Namespace for the SCC and POD options:

```bash
mg_check -pSd -N openshift-etcd
```

#### Customizable VARIABLES (_optional_)

Before running the script you can set some variables which allow you to customize your outputs

```bash
export OC=/usr/bin/omc    # Where to locate the `omc` command     - Default: omc
export ALERT_TRUNK=100    # Length to trunk alerts descriptions   - Default: 100
export OPERATOR_TRUNK=220 # Length to trunk Operator descriptions - Default: 220
export MIN_RESTART=5      # Minimal restart count for PODs        - Default: 5
```

#### Pulling and running the script from the Source repository

In some case, you may want to run the script again a live cluster and cannot pull or deploy the script on a server.
This is totaly faisable if you have internet access from your server.
The only requirement will be to have `curl` installed, then you should be able to run the command:

```bash
export OC=$(which oc | awk '{print $NF}')                                         #Set the OC variable to your `oc` command
URI=raw.githubusercontent.com/vlours/mg_cluster_status/main/mg_cluster_status.sh  #Ensure you are accessing the RAW version of the script
bash <(curl -s https://${URI})                                                    #This will pull the script from the Repo and execute it from memory.
```

And if you want to use the script with an option, simply add it at the end of the command:

```bash
bash <(curl -s https://${URI}) -h
```

Finally, if your DNS is providing IPV4 and IPV6 resolution and you want to force the connection through the IPV4 (or IPV6), simply add the `-4` (or `-6`) option in the curl command:

```bash
bash <(curl -s -4 https://${URI})
```
