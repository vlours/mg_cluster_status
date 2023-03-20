#!/bin/bash
##################################################################
# Script      # mg_cluster_status.sh
# Description # Display basic health check on a Must-gather
# @VERSION    # 1.0
##################################################################

##### Functions
fct_help(){
  VERSION=$(grep "@VERSION" $(which $0) 2>/dev/null | cut -d'#' -f3)
  VERSION=${VERSION:-" N/A"}
  echo "Usage: $(basename $0) [-acevmnop|-h]"
  echo "  -a: display the ALERTS"
  echo "  -c: display the CLUSTER CONTEXT "
  echo "  -e: display the ETCD status"
  echo "  -v: display the EVENTS"
  echo "  -m: display the MCO status"
  echo "  -n: display the NODES status"
  echo "  -o: display the OPERATORS status"
  echo "  -p: display the PODS status"
  echo -e "  -h: display this help\n\nversion:${VERSION}"
  exit 0
}

fct_header(){
  HEADER_LENGTH=$[ 4 + $(printf "$*" | wc -c | awk '{print $1}')]
  echo
  printf '%0.s*' $(seq 1 $HEADER_LENGTH)
  echo -e "\n* $* *"
  printf '%0.s*' $(seq 1 $HEADER_LENGTH)
  echo
}

fct_title() {
  echo -e "\n===== $* ======"
}

##### Variables
# OC command to use - Default: omc
OC=${OC:-"omc"}
# Length to trunk alerts descriptions - Default: 100
ALERT_TRUNK=${ALERT_TRUNK:-100}
# Minimal restart count for PODs
MIN_RESTART=${MIN_RESTART:-5}


##### Main
if [[ $# != 0 ]]
then
  while getopts acevmnoph arg; do
  case $arg in
      h)
	fct_help
	;;
      a)
  	ALERTS=true
    	;;
      c)
  	CONTEXT=true
    	;;
      e)
  	ETCD=true
    	;;
      m)
  	MCO=true
    	;;
      n)
  	NODES=true
    	;;
      o)
  	OPERATORS=true
    	;;
      p)
  	PODS=true
    	;;
      v)
  	EVENTS=true
    	;;
      ?)
	echo -e "Invalid option: ${1}\n"
	fct_help && exit 1
	;;
    esac
  done
else
  ALERTS=true
  CONTEXT=true
  ETCD=true
  EVENTS=true
  MCO=true
  NODES=true
  OPERATORS=true
  PODS=true
fi

if [[ ! -f $(which ${OC} 2>/dev/null) ]]
then
  echo -e "${OC}: command not found!\nPlease check your PATH, or set the variable OC with the right value"
  exit 2
fi

${OC} project default >/dev/null 2>&1
if [[ ! -z ${CONTEXT} ]]
then
  fct_header "CLUSTER CONTEXT"
  fct_title "Clusterversion"
  ${OC} get clusterversion -o yaml
  fct_title "Infrastructure"
  ${OC} get infrastructures cluster -o json | jq -r .status
  fct_title "Network Config"
  ${OC} get network cluster -o json | jq -r .spec
  fct_title "Proxy config"
  ${OC} get proxy cluster -o json | jq -r .spec
fi

if [[ ! -z ${NODES} ]]
then
  fct_header "NODE STATUS"
  fct_title "Nodes"
  ${OC} get nodes -o wide
  fct_title "CSRs"
  ${OC} get csr
fi

if [[ ! -z ${OPERATORS} ]]
then
  fct_header "OPERATOR STATUS"
  fct_title "Unhealthy Cluster Operators"
  #${OC} get co | grep -Ev "True *False *False"
  ${OC} get co -o json | jq -r '"|NAME | VERSION | AVAILABLE| PROGRESSING | DEGRADED | MESSAGE",(.items[] | "|\(.metadata.name) | \(.status.versions[0].version) | \(.status.conditions[] |select(.type == "Available") | .status) | \(.status.conditions[] |select(.type == "Progressing") | .status) | \(.status.conditions[] |select(.type == "Degraded") | .status) | \(if ((.status.conditions[] | select(.type == "Degraded") | .message) != null and (.status.conditions[] |select(.type == "Degraded") | .status) == "True") then "\(.status.conditions[] | select(.type == "Degraded") | .message)"  elif ((.status.conditions[] |select(.type == "Progressing") | .message) != null and (.status.conditions[] |select(.type == "Progressing") | .status) == "True") then "\(.status.conditions[] |select(.type == "Progressing") | .message)" else "" end)")' | grep -v "True | False | False" | grep "^|" |  column -t -s '|' | sed -e "s/^	//"
  fct_title "CSV"
  #CSV=$(${OC} get csv -A -o json | jq -r '(.items | sort_by(.metadata.name) | .[] | "\(.metadata.name) | \(.spec.displayName) | \(.spec.version) | \(.status.phase)")' 2>/dev/null | sort -u)
  echo -e "Name | Display Name | Version | Phase\n$(${OC} get csv -A -o json | jq -r '(.items | sort_by(.metadata.name) | .[] | "\(.metadata.name) | \(.spec.displayName) | \(.spec.version) | \(.status.phase)")' 2>/dev/null | sort -u)" | column -t -s"|"
fi

if [[ ! -z ${MCO} ]]
then
  fct_header "MACHINE CONFIG OPERATOR STATUS"
  fct_title "MCP status"
  ${OC} get mcp
  fct_title "Latest MachineConfigs"
  ${OC} get mc -o json | jq -r '.items| sort_by(.metadata.creationTimestamp,.metadata.name) | .[] | "\(.metadata.creationTimestamp) - \(.metadata.name)"' | tail -10
  fct_title "MCP state & versions"
  ${OC} get mcp -o json | jq -r '"MCP Name | Desired Rendered | Current Rendered | Paused | maxUnavailable",(.items[] | "\(.metadata.name) | \(.spec.configuration.name) | \(.status.configuration.name) | \(.spec.paused) | \(if (.spec.maxUnavailable != null) then .spec.maxUnavailable else 1 end )")' | column -t -s'|'
  fct_title "MCO by node"
${OC} get nodes -ojson | jq -r '"Node Name | Desired MC | Current MC | MC State",(.items| sort_by(.metadata.name,.metadata.annotations."machineconfiguration.openshift.io/desiredConfig",.metadata.annotations."machineconfiguration.openshift.io/currentConfig") | .[]  | "\(.metadata.name) | \(.metadata.annotations."machineconfiguration.openshift.io/currentConfig") |  \(.metadata.annotations."machineconfiguration.openshift.io/desiredConfig") | \(.metadata.annotations."machineconfiguration.openshift.io/state")")' | column -t -s'|'
fi

if [[ ! -z ${EVENTS} ]]
then
fct_header "DEFAULT EVENTS"
fct_title "Default Events"
${OC} get events -n default -o json | jq -r '"creationTimestamp | Name | Reason | Host | Component | Message",(.items | sort_by(.metadata.creationTimestamp) | .[] | "\(.metadata.creationTimestamp) | \(.metadata.name) | \(.reason) | \(.source.host) | \(.source.component) | \(.message)")' | column -t -s'|'
fi

if [[ ! -z ${PODS} ]]
then
fct_header "POD STATUS"
fct_title "Unsuccessful PODs"
${OC} get pod -A -o wide | grep -Ev "Running|Completed|Succeeded|Error"
fct_title "Uncomplete POD started"
${OC} get pod -A -o wide | grep -Ev "Completed|Succeeded|1/1|2/2|3/3|4/4|5/5|6/6|7/7|8/8|9/9|10/10|11/11|12/12|13/13|14/14|15/15"
fct_title "High number POD restart"
${OC} get pod -A -o wide | awk -v min_restart=${MIN_RESTART} '($5 > min_restart)'
fi

if [[ ! -z ${ETCD} ]]
then
fct_header "ETCD STATUS"
fct_title "ETCD Health"
${OC} etcd health
fct_title "ETCD status"
${OC} etcd status
fi

if [[ ! -z ${ALERTS} ]]
then
fct_header "ALERTS STATUS"
fct_title "Alerts"
${OC} alerts rules | grep -i firing
fct_title "Firing Alerts rules"
${OC} alerts rules -o json | jq ".data[] | select(.state == \"firing\") | .alerts[] | \"\(.labels.alertname)|\(.activeAt)|\(.labels.namespace)|\(if (.labels.workload != null) then .labels.workload elif (.labels.pod != null) then .labels.pod elif (.labels.endpoint != null) then .labels.endpoint elif (.labels.job != null) then .labels.job else .labels.service end)|\(.labels.severity)|\(.annotations.description[0:${ALERT_TRUNK}])\"" | column -t -s'|' | sort -k2 | sed -e 's/^"//' -e 's/"$//'
fi