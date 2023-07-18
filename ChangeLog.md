# MG_CLUSTER_STATUS ChangeLog

## Version 1.x.x - Template

### Minor updates - 1.x.x

- **Additional components/features to the Main script server project.** (Placeholder for future additions)

### Release updates - 1.x.x

- **Add more test cases and reference.** (Placeholder for future additions)

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

- Provide examples to run the script to be run from the Source Repository in the README.md file (issue #5)
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
