# MG_CLUSTER_STATUS ChangeLog

## Version 1.x.x - Template

### Minor updates - 1.x.x

- **Additional components/features to the Main script server project.** (Placeholder for future additions)

### Release updates - 1.x.x

- **Add more test cases and reference.** (Placeholder for future additions)

--------

## Version 1.2.9

### Minor updates - 1.2.9

- None

### Release updates - 1.2.9

- (NODE) Fixing the memory reserved check in the detail view as the json can have a single or multiple entries in items[].
- (NODE) Improve CSR visibility (sort by creationTimestamp, and highlight Approved CSRs)

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
