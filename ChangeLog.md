# MG_CLUSTER_STATUS ChangeLog

## Version 1.x.x - Template

### Minor updates - 1.x.x

- **Additional components/features to the Main script server project.** (Placeholder for future additions)

### Release updates - 1.x.x

- **Add more test cases and reference.** (Placeholder for future additions)

--------

## Version 1.2.26

### Minor updates - 1.2.26

- None

### Release updates - 1.2.26

- (OPERATOR) sort the subscriptions by name to match the order used in CSVs.
- (ALERTS) Highlighting the 'ControlPlane' and 'Master' alerts.
- (ETCD) Fixing typo.
- (README) Update the content and fix the format

--------

## Version 1.2.25

### Minor updates - 1.2.25

- None

### Release updates - 1.2.25

- (ALERT) Create a new token for prometheus-ks8 when querying the prometheus API in a live cluster.
- (MCO) Review the format of the osImageURL conflict.
- (CONTEXT) fix the rule to retrieve the installation type and adding 'ROKS' with 'hypershift' installation type.

--------

## Version 1.2.24

### Minor updates - 1.2.24

- None

### Release updates - 1.2.24

- (ALERT) Extracting more label References (name, channel, poddisruptionbudget) from the Alerts
- (ALERT) Highlighting the 'major' severity.
- (Operator) Add the provider in the CSV list

--------

## Version 1.2.23

### Minor updates - 1.2.23

- None

### Release updates - 1.2.23

- (CO) Adding the subscription details
- (STATIC) ETCD encryption check in detailled view
- (ETCD) Highlight the number of 'take too long' and 'overloaded' messages from ETCD logs
- (NODE) Include the 'matchExpressions' selection in the machineConfigPoolSelector for the 'System Reserved' checkup.
- (CO) Update the 'Not Updated Cluster Operators' section to fix issue when the '.status.conditions' is not yet created.

--------

## Version 1.2.22

### Minor updates - 1.2.22

- None

### Release updates - 1.2.22

- (CO) List the COs that are not ready for update (for pro-active cases)
- (POD) Unhidden the Titles in the 'Unsuccessful Containers in PODs' section

--------

## Version 1.2.21

### Minor updates - 1.2.21

- None

### Release updates - 1.2.21

- (POD) Include the 'message' in addition of the 'reason' in the 'fct_restart_container_details' function.
- (CSV) highlighting the status 'Installing'.

--------

## Version 1.2.20

### Minor updates - 1.2.20

- None

### Release updates - 1.2.20

- (README) Quick fix updating the README with the new '-N namespace' option
- (ChangeLog) Fixing some markdownint issues

--------

## Version 1.2.19

### Minor updates - 1.2.19

- None

### Release updates - 1.2.19

- (MCO) Showing the 'unavailableMachineCount' in 'MCP state & versions' section
- (GLOBAL) fixing reference to 'oc' commandand enforcing the STD_ERR redirection
- (POD/SCC) ADDING the capability to focus on a specific Namespace using the '-N namespace' option
- (SCC) Usage the 'NODE_TRANSITION_DAYS' to add flexibility when reviewing the SCC creationTimestamps and POD creations

--------

## Version 1.2.18

### Minor updates - 1.2.18

- None

### Release updates - 1.2.18

- (OPERATOR) Reduce the number of OC requests.
- (OPERATOR) Ensure that some CO statuses are display even when 'unknown'.
- (MCO) Ensure the number returned in 'NODE_COUNT' is a number.

--------

## Version 1.2.17

### Minor updates - 1.2.17

- None

### Release updates - 1.2.17

- (ETCD) Hightlight details when running against a live cluster.
- (POD) Hightlight new type in the "Unsuccessful PODs" section.
- (NODE) ADD variable to manage and hightlight ALL recent transitions
- (MCO) Ensure nodes are not missing in MCP
- (OPERATOR) Show the transitions time when details are requested.
- (MAIN) Enforce the YQ substitution: sub("\n";" ";"g")
- (HELP/README) Adding description of exportable VARIABLEs for transition checks

--------

## Version 1.2.16

### Minor updates - 1.2.16

- None

### Release updates - 1.2.16

- (CONTEXT) Hightlight 'overrides' in the 'Clusterversion detailled' section.
- (Alert) Highlight on severity including uppercase first letter.
- (Alert) Fixed annotation tests and added '.annotations.summary' as third option.
- (Operator) Highlight the CSV status.

--------

## Version 1.2.15

### Minor updates - 1.2.15

- None

### Release updates - 1.2.15

- (NODE) Update the overcommitment details to include the POD count and node pod subnet.
- (CONTEXT) Include the installation type, based on the methode used in Insights.
- (CONTEXT) Advise if KeepAlive PODs are running in the cluster, to highlight cluster with VIPs.
- (POD) Highlight the 'Evicted' status in the 'Unsuccessful PODs' section,
- (POD) Merging ALL_PODS_WIDE in ALL_PODS to ensure to always have the node name display.
- (POD) Optimization of the fct_unsuccessful_container_details and fct_restart_container_details functions.
- (HELP) Explaining the new 'POD_WIDE' variable.
- (HELP) Flaging the detail option for the help (-h) option.

--------

## Version 1.2.14

### Minor updates - 1.2.14

- None

### Release updates - 1.2.14

- (MCO) Add the osImageURL conflict review in detailled view
- (SCC) Remove an useless grep condition
- (NODE) display overcommitment in detailled node view for Live cluster (RFE #20)

--------

## Version 1.2.13

### Minor updates - 1.2.13

- None

### Release updates - 1.2.13

- (NODE) Fixing an issue with the transition not highlithed when the status is 'UNKNOW'
- (POD) Fixing an issue when the '.state.[status].message' is empty.
- (HELP) Enable colours for the DETAILS_TAB in the 'Additional Options', to highlight the help details.

--------

## Version 1.2.12

### Minor updates - 1.2.12

- None

### Release updates - 1.2.12

- (SCC) highlighting the recent SCCs
- (MAIN) Remapping the STDERR and message exclusions as suggested in the issue #25
- (ALERT) Replacing the 'alerts rules' by the new omc feature 'prometheus alertrule' (omc version: 3.4.0)

--------

## Version 1.2.11

### Minor updates - 1.2.11

- None

### Release updates - 1.2.11

- (MAIN) Allowing to replace the colors by setting the variables before running the script (colorblind)
- (README) explaining the new '-d' option for the help
- (SCC) Adding the SecurityContextContraints data in the script
- (POD) Including the PodDisruptionBudget details.
- (MAIN) Avoiding content variables to be query twice.
- (MAIN) Replacing all Shell variables in JQ command by args
- (MAIN) Substituing '\n' characters in jq messages.

--------

## Version 1.2.10

### Minor updates - 1.2.10

- None

### Release updates - 1.2.10

- (MAIN) Replacing shotname objects by longname objects.
- (MAIN) Protecting the JQ commands by excluding the outputs '^No resources|^resource type'
- (MACHINE) Creating the machine and autoscaler health check (issue #1)
- (MACHINE) Calculating the total amount of resource to compare them with the clusterAutoscaler setting (issue #14)
- (HELP) Avoiding display current value identical to the default one.
- (README) Updating the help options.
- (NODE) Separating the status.conditions in the detailled output to include the transition dates.
- (VERSION) fixing a typo in the over days calculation.
- (STATIC) Improving the display of the installer POD details.
- (ALERT) Updating the JQ query to check if '.data != null'

--------

## Version 1.2.9.1

### Minor updates - 1.2.9.1

- None

### Release updates - 1.2.9.1

- (README) fixing incorrect URI for the 'omc' readme.

--------

## Version 1.2.9

### Minor updates - 1.2.9

- None

### Release updates - 1.2.9

- (NODE) Fixing the memory reserved check in the detail view as the json can have a single or multiple entries in items[].
- (NODE) Improving CSR visibility (sort by creationTimestamp, and highlight Approved CSRs).
- (ETCD) Improving visibility of the ETCD response time.
- (ETCD) Describing the ETCD defragmentation threshold.

--------

## Version 1.2.8

### Minor updates - 1.2.8

- None

### Release updates - 1.2.8

- (CONTEXT)  Deleting the '.status.availableUpdates' from the clusterversion output
- (EVENT)    Removing undesired "No Resources" message.
- (OPERATOR) Removing the COs not owned by the ClusterVersion when checking for the updated versions.

--------

## Version 1.2.7

### Minor updates - 1.2.7

- None

### Release updates - 1.2.7

- (POD) Caching the 'oc get pods' outputs in variable to improve the performance if the number of PODs is large.
- (HELP) Fixing incorrect variable name in the HELP output.
- (MCO) Displaying the machine-config-controller log when at least one MCP is in Updating state.
- (MCO) Adding colours when displaying the last 10 MCs, to help identify the current and previous version for each MCP.
- (NODE) Caching the 'oc get nodes' outputs in variable to improve the performance.
- (NODE) Adding detailled view for the NODEs, including the capacity vs allocatable values, kubeletconfig/systemreserved (if defined) and pressure conditions.

--------

## Version 1.2.6.1

### Minor updates - 1.2.6.1

- None

### Release updates - 1.2.6.1

- quick fix for a test condition in the function "fct_restart_container_details"

--------

## Version 1.2.6

### Minor updates - 1.2.6

- None

### Release updates - 1.2.6

- Displaying the log of nodes in Degraded state in the MCO section with detailled output.
- Including new customizable variable "DEFAULT_TAIL_LOG".
- Updating the README.md file to include the new variable.
- Adding autoformating for the pod restart detailled view (based on the longest container name)

--------

## Version 1.2.5

### Minor updates - 1.2.5

- None

### Release updates - 1.2.5

- Enforce cacheless curl commands
- Display Info message when the '-d' option is used in combination with option not having details.
- use a Variable 'STD_ERR' to redirect error message to '/dev/null' by default.
  This Variable can be overwritten with '/dev/stderr' to help debugging.
- Adding colors to the static PODS status.
- Updating the POD restart detailled ouput
  as the number of POD restart is equal to the sum of the restartCount from the containers running inside the POD.
- Reduce the error message outputs when the operators details are missing.
- Implementing an "ALL" variable to allow new options to be included by default.
- Creating separation between options

--------

## Version 1.2.4

### Minor updates - 1.2.4

- None

### Release updates - 1.2.4

- Fixing an issue in the help displaying the wrong script name when executed from the source.
- Fixing the display of the 'MCP state & versions' where the desired and status version were mixed.
- Adding colors in the help section to display the options, and the default and current settings.
- Implementing the Alerts for live clusters (Issue #6)
- Improving the Alerts display with additional colors

--------

## Version 1.2.3

### Minor updates - 1.2.3

- None

### Release updates - 1.2.3

- Improvements in the PODs `details` section
- Improving the help to display the Options with available details
- Enforcing the function `fct_title_details` for the related titles
- Providing guidance to run the command remotly using IPV4 or IPV6

--------

## Version 1.2.2

### Minor updates - 1.2.2

- None

### Release updates - 1.2.2

- Provide examples to run the script to be run from the Source Repository in the README.md file (Issue #5)
- Ensure that the `fct_version` will not trigger when the script will be called from a `curl` pull.
- Include the Static PODs status (Issue #3), allowing to display the revision ConfigMap and Installer status with the `-d` option.
- Ensure the Alerts are currently only displayed with `omc` and `omg` commands. Awaiting for the issue #6 to be implemented for the `oc` command.

--------

## Version 1.2.1

### Minor updates - 1.2.1

- None

### Release updates - 1.2.1

- Fix an issue with the mcp module where additional columns was displayed and the desired was still highlighted.

--------

## Version 1.2.0

### Minor updates - 1.2.0

- Introducing the **update version checker**, to allow the script to check for newer version from the Source repository
- Introduting the ChangeLog in the repository

### Release updates - 1.2.0

- Add reference to the README.md and ChangeLog.md inside the script.
- Enforce the parameter check in the script (blocking '-' or any text parameters).

--------

## Version 1.1.8

### Minor updates - 1.1.8

- None

### Release updates - 1.1.8

- Improve alerts details for nodes issues.
- Highlight current MCP config instead of the desired one.

--------

## Version 1.1.7

### Minor updates - 1.1.7

- None

### Release updates - 1.1.7

- Include new status in "Unsuccessful PODs"
- Allow to display detailled MCP degraded nodes state
- Rewriting Unhealthy COs as [inputs] jq function has bug

--------

## Version 1.1.6

### Minor updates - 1.1.6

- None

### Release updates - 1.1.6

- Allow to display detailled status for CO and
- Add lastTransitionTime CO and
- Add NotReady Node list with lastTransitionTime and
- Allow to display detailled POD status

--------

## Version 1.1.5

### Minor updates - 1.1.5

- None

### Release updates - 1.1.5

- Color fixed in Node

--------

## Version 1.1.4

### Minor updates - 1.1.4

- None

### Release updates - 1.1.4

- Add color filters in MCP outputs

--------

## Version 1.1.3

### Minor updates - 1.1.3

- None

### Release updates - 1.1.3

- Add variables names in the Help message

--------

## Version 1.1.2

### Minor updates - 1.1.2

- None

### Release updates - 1.1.2

- Fix filter for Unsuccessful PODs + titles updates

--------

## Version 1.1.1

### Minor updates - 1.1.1

- None

### Release updates - 1.1.1

- MCO manage (%) + README update

--------

## Version 1.1.0

### Minor updates - 1.1.0

- Adding colors

### Release updates - 1.1.0

- fixing typos

--------

## Version 1.0.0

### Minor updates - 1.0.0

- Initial Version

### Release updates - 1.0.0

- None
