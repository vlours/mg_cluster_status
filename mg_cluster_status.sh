#!/bin/bash
##################################################################
# Script      # mg_cluster_status.sh
# Description # Display basic health check on a Must-gather
# @VERSION    # 1.1
##################################################################
# Changelog   #
# 1.0         # Initial
# 1.1         # Adding colors and fixing typos
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
OPERATOR_TRUNK=${OPERATOR_TRUNK:-220}
# Minimal restart count for PODs
MIN_RESTART=${MIN_RESTART:-5}
# Color list
graytext="\x1B[30m"
redtext="\x1B[31m"
greentext="\x1B[32m"
yellowtext="\x1B[33m"
bluetext="\x1B[34m"
purpletext="\x1B[35m"
cyantext="\x1B[36m"
whitetext="\x1B[37m"
resetcolor="\x1B[0m"


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
  ${OC} get clusterversion | awk '{printf "%s|%s|",$1,$2; if($3 == "AVAILABLE"){printf "%s|",$3} else if($3 == "True"){printf "G%s|",$3}else{printf "R%s|",$3}; if($4 == "PROGRESSING"){printf "%s|",$4} else if($4 == "True"){printf "Y%s|",$4}else{printf "G%s|",$4}; printf "%s|%s|\n",$5,substr($0,index($0,$6))}' | column -t -s '|' | sed -e "s/G\([FT][a-z]*\)/${greentext}\1 ${resetcolor}/g" -e "s/Y\([FT][a-z]*\)/${yellowtext}\1 ${resetcolor}/g" -e "s/R\([FT][a-z]*\)/${redtext}\1 ${resetcolor}/g"
  fct_title "Clusterversion detailled"
  ${OC} get clusterversion version -o json | jq -r '. | del(.metadata.managedFields)'
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
  ${OC} get nodes -o wide | sed -e "s/SchedulingDisabled/${yellowtext}&${resetcolor}/" -e "s/NotReady/${redtext}&${resetcolor}/" -e "s/master/${cyantext}&${resetcolor}/" -e "s/worker/${purpletext}&${resetcolor}/" -e "s/infra/${yellowtext}&${resetcolor}/"
  fct_title "CSRs"
  ${OC} get csr | sed -e "s/Pending/${redtext}&${resetcolor}/"
fi

if [[ ! -z ${OPERATORS} ]]
then
  fct_header "OPERATOR STATUS"
  fct_title "Unhealthy Cluster Operators"
  ${OC} get co -o json | jq -r '"|NAME|VERSION|AVAILABLE|PROGRESSING|DEGRADED|MESSAGE",(.items[] | "|\(.metadata.name)|\(.status.versions[] | select(.name == "operator") | .version)|\(.status.conditions[] |select(.type == "Available") | .status)|\(.status.conditions[] |select(.type == "Progressing") | .status)|\(.status.conditions[] |select(.type == "Degraded") | .status)|\(if ((.status.conditions[] | select(.type == "Degraded") | .message) != null and (.status.conditions[] |select(.type == "Degraded") | .status) == "True") then "\(.status.conditions[] | select(.type == "Degraded") | .message)"  elif ((.status.conditions[] |select(.type == "Progressing") | .message) != null and (.status.conditions[] |select(.type == "Progressing") | .status) == "True") then "\(.status.conditions[] |select(.type == "Progressing") | .message)" else "" end)")' | grep -v "True|False|False" | grep "^|" | awk -F'|' -v trunk=${OPERATOR_TRUNK} '{printf "%s|%s|",$2,$3; if($4 == "AVAILABLE"){printf "%s|",$4} else if($4 == "True"){printf "G%s|",$4}else{printf "R%s|",$4}; if($5 == "PROGRESSING"){printf "%s|",$5} else if($5 == "True"){printf "Y%s|",$5}else{printf "G%s|",$5}; if($6 == "DEGRADED"){printf "%s|",$6} else if($6 == "True"){printf "R%s|",$6}else{printf "G%s|",$6}; desc=substr($7,1,trunk); printf "%s|\n",desc}' | column -t -s '|' | sed -e "s/G\([FT][a-z]*\)/${greentext}\1 ${resetcolor}/g" -e "s/Y\([FT][a-z]*\)/${yellowtext}\1 ${resetcolor}/g" -e "s/R\([FT][a-z]*\)/${redtext}\1 ${resetcolor}/g"
  CLUSTER_VERSION=$(${OC} get clusterversion version -o json | jq -r .status.desired.version)
  CO_MISS_VERSION_OUTPUT=$(${OC} get co | grep -v ${CLUSTER_VERSION})
  if [[ ! -z $(echo "${CO_MISS_VERSION_OUTPUT}" | grep -Ev "^NAME") ]]
  then
    fct_title "Not Updated Cluster Operators"
    echo "${CO_MISS_VERSION_OUTPUT}" | awk '{printf "%s|%s|",$1,$2; if($3 == "AVAILABLE"){printf "%s|",$3} else if($3 == "True"){printf "G%s|",$3}else{printf "R%s|",$3}; if($4 == "PROGRESSING"){printf "%s|",$4} else if($4 == "True"){printf "Y%s|",$4}else{printf "G%s|",$4}; if($5 == "DEGRADED"){printf "%s|",$5} else if($5 == "True"){printf "R%s|",$5}else{printf "G%s|",$5}; printf "%s|\n",$6}' | column -t -s '|' | sed -e "s/G\([FT][a-z]*\)/${greentext}\1 ${resetcolor}/g" -e "s/Y\([FT][a-z]*\)/${yellowtext}\1 ${resetcolor}/g" -e "s/R\([FT][a-z]*\)/${redtext}\1 ${resetcolor}/g" -e "s/4.[0-9]\{1,2\}.[0-9]\{1,2\}/${redtext}&${resetcolor}/" -e "s/^[a-z\-]*/${purpletext}&${resetcolor}/"
  fi
  fct_title "CSV"
  #CSV=$(${OC} get csv -A -o json | jq -r '(.items | sort_by(.metadata.name) | .[] | "\(.metadata.name) | \(.spec.displayName) | \(.spec.version) | \(.status.phase)")' 2>/dev/null | sort -u)
  echo -e "Name | Display Name | Version | Phase\n$(${OC} get csv -A -o json | jq -r '(.items | sort_by(.metadata.name) | .[] | "\(.metadata.name) | \(.spec.displayName) | \(.spec.version) | \(.status.phase)")' 2>/dev/null | sort -u)" | column -t -s"|"
fi

if [[ ! -z ${MCO} ]]
then
  fct_header "MACHINE CONFIG OPERATOR STATUS"
  fct_title "MCP status"
  ${OC} get mcp | awk '{printf "%s|%s|",$1,$2; if($3 == "UPDATED"){printf "%s|",$3} else if($3 == "True"){printf "G%s|",$3}else{printf "R%s|",$3}; if($4 == "UPDATING"){printf "%s|",$4} else if($4 == "True"){printf "Y%s|",$4}else{printf "G%s|",$4}; if($5 == "DEGRADED"){printf "%s|",$5} else if($5 == "True"){printf "R%s|",$5}else{printf "G%s|",$5}; printf "%s|",$6; if($7 == "READYMACHINECOUNT"){printf "%s|",$7} else if($7 != $6){printf "R%s|",$7}else{printf "G%s|",$7}; if($8 == "UPDATEDMACHINECOUNT"){printf "%s|",$8} else if($8 != $6){printf "Y%s|",$8}else{printf "G%s|",$8}; if($9 == "DEGRADEDMACHINECOUNT"){printf "%s|",$9} else if($9 != 0){printf "Y%s|",$9}else{printf "G%s|",$9}; printf "%s \n",$10}' | column -t -s '|' | sed -e "s/G\([FT]*[a-z0-9]\+\)/${greentext}\1 ${resetcolor}/g" -e "s/Y\([FT]*[0-9a-z]\+\)/${yellowtext}\1 ${resetcolor}/g" -e "s/R\([FT]*[0-9a-z]\+\)/${redtext}\1 ${resetcolor}/g" -e "s/master/${cyantext}&${resetcolor}/" -e "s/worker/${purpletext}&${resetcolor}/" -e "s/infra/${yellowtext}&${resetcolor}/"
  fct_title "Latest MachineConfigs"
  ${OC} get mc -o json | jq -r '.items| sort_by(.metadata.creationTimestamp,.metadata.name) | .[] | "\(.metadata.creationTimestamp) - \(.metadata.name)"' | tail -10
  fct_title "MCP state & versions"
  ${OC} get mcp -o json | jq -r '"MCP Name | Desired Rendered | Current Rendered | Paused | maxUnavailable",(.items[] | "\(.metadata.name) | \(.spec.configuration.name) | \(.status.configuration.name) | \(.spec.paused) | \(if (.spec.maxUnavailable != null) then .spec.maxUnavailable else 1 end )")' | column -t -s'|' | sed -e "s/ [1-9]\+[0-9]$/${yellowtext}&${resetcolor}/" -e "s/ true /${redtext}&${resetcolor}/" -e "s/master/${cyantext}&${resetcolor}/" -e "s/worker/${purpletext}&${resetcolor}/" -e "s/infra/${yellowtext}&${resetcolor}/"
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
  ${OC} get pod -A -o wide | grep -Ev "Running|Completed|Succeeded|Error" | sed -e "s/ [Terminating|Pending|ContainerCreation] /${yellowtext}&${resetcolor}/"
  fct_title "Uncomplete POD started"
  ${OC} get pod -A -o wide | grep -Ev "Completed|Succeeded|1/1|2/2|3/3|4/4|5/5|6/6|7/7|8/8|9/9|10/10|11/11|12/12|13/13|14/14|15/15" | sed -e "s/ [0-9]*\/[0-9]* /${yellowtext}&${resetcolor}/"
  fct_title "High number POD restart"
  ${OC} get pod -A -o wide | awk -v min_restart=${MIN_RESTART} '($5 > min_restart)' | sed -e "s/ [0-9]\+ /${yellowtext}&${resetcolor}/"
fi

if [[ ! -z ${ETCD} ]]
then
  fct_header "ETCD STATUS"
  fct_title "ETCD Health"
  ${OC} etcd health | sed -e "s/ [0-9]\{3,9\}.*ms /${redtext}&${resetcolor}/" -e "s/ false /${redtext}&${resetcolor}/" -e "s/ true /${greentext}&${resetcolor}/"
  fct_title "ETCD status"
  ${OC} etcd status | sed -e "s/ [3-9][0-9]% /${yellowtext}&${resetcolor}/" -e "s/ true /${greentext}&${resetcolor}/"
fi

if [[ ! -z ${ALERTS} ]]
then
  fct_header "ALERTS STATUS"
  fct_title "Alerts"
  ${OC} alerts rules -s firing | sed -e "s/^Kube[a-zA-Z]* /${purpletext}&${resetcolor}/" -e "s/^Cluster[a-zA-Z]* /${purpletext}&${resetcolor}/"
  fct_title "Firing Alerts rules"
  ${OC} alerts rules -o json | jq "\"ALERTNAME|LAST ACTIVE|NAMESPACE|WORKLOAD,LABEL,ENDPOINT,JOB OR SERVICE|SEVERITY|DESCRIPTION|\",(.data[] | select(.state == \"firing\") | .alerts | sort_by(.activeAt) | .[] | \"\(.labels.alertname)|\(.activeAt)|\(.labels.namespace)|\(if (.labels.workload != null) then .labels.workload elif (.labels.pod != null) then .labels.pod elif (.labels.endpoint != null) then .labels.endpoint elif (.labels.job != null) then .labels.job else .labels.service end)|\(.labels.severity)|\(.annotations.description[0:${ALERT_TRUNK}])\")" | column -t -s'|' | sed -e 's/^"//' -e 's/"$//' | sed -e "s/ warning /${yellowtext}&${resetcolor}/" -e "s/ info /${greentext}&${resetcolor}/" -e "s/ critical /${redtext}&${resetcolor}/"
fi
