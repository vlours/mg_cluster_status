#!/bin/bash
##################################################################
# Script       # mg_cluster_status.sh
# Description  # Display basic health check on a Must-gather
# @VERSION     # 1.2.24
##################################################################
# Changelog.md # List the modifications in the script.
# README.md    # Describes the repository usage
##################################################################

##### Functions
fct_help(){
  Script=$(which $0 2>${STD_ERR})
  if [[ "${Script}" != "bash" ]] && [[ ! -z ${Script} ]]
  then
    ScriptName=$(basename $0)
  fi
  echo -e "usage: ${cyantext}${ScriptName} [-acevMmnopsS] [-N namespace] ${purpletext}[-d] [-h]${resetcolor}"
  OPTION_TAB=8
  DESCR_TAB=63
  DETAILS_TAB=10
  printf "|%${OPTION_TAB}s---%-${DESCR_TAB}s---%-${DETAILS_TAB}s|\n" |tr \  '-'
  printf "|%${OPTION_TAB}s | %-${DESCR_TAB}s | %-${DETAILS_TAB}s|\n" "Options" "Description" "[Details]"
  printf "|%${OPTION_TAB}s | %-${DESCR_TAB}s | %-${DETAILS_TAB}s|\n" |tr \  '-'
  printf "|${cyantext}%${OPTION_TAB}s${resetcolor} | %-${DESCR_TAB}s | ${greentext}%-${DETAILS_TAB}s${resetcolor}|\n" "-a" "display the ALERTS" ""
  printf "|${cyantext}%${OPTION_TAB}s${resetcolor} | %-${DESCR_TAB}s | ${greentext}%-${DETAILS_TAB}s${resetcolor}|\n" "-c" "display the CLUSTER CONTEXT" ""
  printf "|${cyantext}%${OPTION_TAB}s${resetcolor} | %-${DESCR_TAB}s | ${greentext}%-${DETAILS_TAB}s${resetcolor}|\n" "-e" "display the ETCD status" ""
  printf "|${cyantext}%${OPTION_TAB}s${resetcolor} | %-${DESCR_TAB}s | ${greentext}%-${DETAILS_TAB}s${resetcolor}|\n" "-v" "display the EVENTS" ""
  printf "|${cyantext}%${OPTION_TAB}s${resetcolor} | %-${DESCR_TAB}s | ${greentext}%-${DETAILS_TAB}s${resetcolor}|\n" "-M" "display the MACHINES status" "[Y]"
  printf "|${cyantext}%${OPTION_TAB}s${resetcolor} | %-${DESCR_TAB}s | ${greentext}%-${DETAILS_TAB}s${resetcolor}|\n" "-m" "display the MCO status" "[Y]"
  printf "|${cyantext}%${OPTION_TAB}s${resetcolor} | %-${DESCR_TAB}s | ${greentext}%-${DETAILS_TAB}s${resetcolor}|\n" "-N" "set a namespace to filter the SCC and PODs" ""
  printf "|${cyantext}%${OPTION_TAB}s${resetcolor} | %-${DESCR_TAB}s | ${greentext}%-${DETAILS_TAB}s${resetcolor}|\n" "-n" "display the NODES status" "[Y]"
  printf "|${cyantext}%${OPTION_TAB}s${resetcolor} | %-${DESCR_TAB}s | ${greentext}%-${DETAILS_TAB}s${resetcolor}|\n" "-o" "display the OPERATORS status" "[Y]"
  printf "|${cyantext}%${OPTION_TAB}s${resetcolor} | %-${DESCR_TAB}s | ${greentext}%-${DETAILS_TAB}s${resetcolor}|\n" "-p" "display the PODS status" "[Y]"
  printf "|${cyantext}%${OPTION_TAB}s${resetcolor} | %-${DESCR_TAB}s | ${greentext}%-${DETAILS_TAB}s${resetcolor}|\n" "-s" "display the STATIC PODs status" "[Y]"
  printf "|${cyantext}%${OPTION_TAB}s${resetcolor} | %-${DESCR_TAB}s | ${greentext}%-${DETAILS_TAB}s${resetcolor}|\n" "-S" "display the SecurityContextConstraints" "[Y]"
  printf "|%${OPTION_TAB}s-|-%-${DESCR_TAB}s-|-%-${DETAILS_TAB}s|\n" |tr \  '-'
  printf "|%${OPTION_TAB}s | %-${DESCR_TAB}s | %-${DETAILS_TAB}s|\n" "" "Additional Options:" ""
  printf "|%${OPTION_TAB}s-|-%-${DESCR_TAB}s-|-%-${DETAILS_TAB}s|\n" |tr \  '-'
  printf "|${purpletext}%${OPTION_TAB}s${resetcolor} | %-${DESCR_TAB}s | ${greentext}%-${DETAILS_TAB}s${resetcolor}|\n" "-d" "display additional details on specific Options (as noted above)" ""
  printf "|${purpletext}%${OPTION_TAB}s${resetcolor} | %-${DESCR_TAB}s | ${greentext}%-${DETAILS_TAB}s${resetcolor}|\n" "-h" "display this help and check for updated version" "[Y]"
  printf "|%${OPTION_TAB}s---%-${DESCR_TAB}s---%-${DETAILS_TAB}s|\n" |tr \  '-'

  if [[ ! -z ${DETAILS} ]] && [[ ! -z ${HELP} ]]
  then
    echo -e "\nCustomizable variables before running the script (Optional):"
    EXPORT_TAB=42
    COMMENT_TAB=92
    DEFAULT_TAB=10
    CURRENT_TAB=10
    if [[ ! -z ${OC} ]]
    then
      OC_LENGTH=$(echo "[${OC}]" | wc -c | awk '{print $1}')
      if [[ ${OC_LENGTH} -gt ${CURRENT_TAB} ]]
      then
        CURRENT_TAB=${OC_LENGTH}
      fi
    fi
    printf "|%-${EXPORT_TAB}s---%-${COMMENT_TAB}s---%-${DEFAULT_TAB}s---%-${CURRENT_TAB}s|\n" |tr \  '-'
    printf "|%-${EXPORT_TAB}s | %-${COMMENT_TAB}s | %-${DEFAULT_TAB}s | %-${CURRENT_TAB}s|\n" "Options" "Description" "[Default]" "[Current]"
    printf "|%-${EXPORT_TAB}s-|-%-${COMMENT_TAB}s-|-%-${DEFAULT_TAB}s-|-%-${CURRENT_TAB}s|\n" |tr \  '-'
    printf "|${purpletext}%-${EXPORT_TAB}s${resetcolor} | %-${COMMENT_TAB}s | ${greentext}%-${DEFAULT_TAB}s${resetcolor} | ${redtext}%-${CURRENT_TAB}s${resetcolor}|\n" "export OC=[omc|omg|oc]" "#Change the must-gather tool (use 'oc' to run the script against live cluster)" "[${DEFAULT_OC}]" "$(if [[ ! -z ${OC} ]] && [[ ${OC} != ${DEFAULT_OC} ]]; then echo "[${OC}]"; fi)"
    printf "|${purpletext}%-${EXPORT_TAB}s${resetcolor} | %-${COMMENT_TAB}s | ${greentext}%-${DEFAULT_TAB}s${resetcolor} | ${redtext}%-${CURRENT_TAB}s${resetcolor}|\n" "export ALERT_TRUNK=<interger>" "#Change the length of the Alert Descriptions" "[${DEFAULT_TRUNK}]" "$(if [[ ! -z ${ALERT_TRUNK} ]] && [[ ${ALERT_TRUNK} != ${DEFAULT_TRUNK} ]]; then echo "[${ALERT_TRUNK}]"; fi)"
    printf "|${purpletext}%-${EXPORT_TAB}s${resetcolor} | %-${COMMENT_TAB}s | ${greentext}%-${DEFAULT_TAB}s${resetcolor} | ${redtext}%-${CURRENT_TAB}s${resetcolor}|\n" "export CONDITION_TRUNK=<interger>" "#Change the length of the Operator Message in 'oc get co'" "[${DEFAULT_CONDITION_TRUNK}]" "$(if [[ ! -z ${CONDITION_TRUNK} ]] && [[ ${CONDITION_TRUNK} != ${DEFAULT_CONDITION_TRUNK} ]]; then echo "[${CONDITION_TRUNK}]"; fi)"
    printf "|${purpletext}%-${EXPORT_TAB}s${resetcolor} | %-${COMMENT_TAB}s | ${greentext}%-${DEFAULT_TAB}s${resetcolor} | ${redtext}%-${CURRENT_TAB}s${resetcolor}|\n" "export POD_TRUNK=<interger>" "#Change the length of the POD Message in 'oc get pod'" "[${DEFAULT_TRUNK}]" "$(if [[ ! -z ${POD_TRUNK} ]] && [[ ${POD_TRUNK} != ${DEFAULT_TRUNK} ]]; then echo "[${POD_TRUNK}]"; fi)"
    printf "|${purpletext}%-${EXPORT_TAB}s${resetcolor} | %-${COMMENT_TAB}s | ${greentext}%-${DEFAULT_TAB}s${resetcolor} | ${redtext}%-${CURRENT_TAB}s${resetcolor}|\n" "export POD_WIDE=<boolean>" "#Enable/Disable the '-o wide' option in the command 'oc get pod'" "[${DEFAULT_WIDE}]" "$(if [[ ! -z ${POD_WIDE} ]] && [[ ${POD_WIDE} != ${DEFAULT_WIDE} ]]; then echo "[${POD_WIDE}]"; fi)"
    printf "|${purpletext}%-${EXPORT_TAB}s${resetcolor} | %-${COMMENT_TAB}s | ${greentext}%-${DEFAULT_TAB}s${resetcolor} | ${redtext}%-${CURRENT_TAB}s${resetcolor}|\n" "export MIN_RESTART=<integer>" "#Change the minimal number of restart when checking the POD restarts" "[${DEFAULT_MIN_RESTART}]" "$(if [[ ! -z ${MIN_RESTART} ]] && [[ ${MIN_RESTART} != ${DEFAULT_MIN_RESTART} ]]; then echo "[${MIN_RESTART}]"; fi)"
    printf "|${purpletext}%-${EXPORT_TAB}s${resetcolor} | %-${COMMENT_TAB}s | ${greentext}%-${DEFAULT_TAB}s${resetcolor} | ${redtext}%-${CURRENT_TAB}s${resetcolor}|\n" "export NODE_TRANSITION_DAYS=<interger>" "#Change the value to highlight the conditions[].lastTransitionTime for the Nodes & SCC" "[${DEFAULT_NODE_TRANSITION_DAYS}]" "$(if [[ ! -z ${NODE_TRANSITION_DAYS} ]] && [[ ${NODE_TRANSITION_DAYS} != ${DEFAULT_NODE_TRANSITION_DAYS} ]]; then echo "[${NODE_TRANSITION_DAYS}]"; fi)"
    printf "|${purpletext}%-${EXPORT_TAB}s${resetcolor} | %-${COMMENT_TAB}s | ${greentext}%-${DEFAULT_TAB}s${resetcolor} | ${redtext}%-${CURRENT_TAB}s${resetcolor}|\n" "export OPERATOR_TRANSITION_DAYS=<interger>" "#Change the value to highlight the conditions[].lastTransitionTime for the Cluster Operators" "[${DEFAULT_OPERATOR_TRANSITION_DAYS}]" "$(if [[ ! -z ${OPERATOR_TRANSITION_DAYS} ]] && [[ ${OPERATOR_TRANSITION_DAYS} != ${DEFAULT_OPERATOR_TRANSITION_DAYS} ]]; then echo "[${OPERATOR_TRANSITION_DAYS}]"; fi)"
    printf "|${purpletext}%-${EXPORT_TAB}s${resetcolor} | %-${COMMENT_TAB}s | ${greentext}%-${DEFAULT_TAB}s${resetcolor} | ${redtext}%-${CURRENT_TAB}s${resetcolor}|\n" "export TAIL_LOG=<integer>" "#Change the number of lines displayed from logs ('tail')" "[${DEFAULT_TAIL_LOG}]" "$(if [[ ! -z ${TAIL_LOG} ]] && [[ ${TAIL_LOG} != ${DEFAULT_TAIL_LOG} ]]; then echo "[${TAIL_LOG}]"; fi)"
    printf "|${purpletext}%-${EXPORT_TAB}s${resetcolor} | %-${COMMENT_TAB}s | ${greentext}%-${DEFAULT_TAB}s${resetcolor} | ${redtext}%-${CURRENT_TAB}s${resetcolor}|\n" "export graytext=<color_code>" "#Replace the gray color used in the script" "[${DEFAULT_graytext}]" "$(if [[ ! -z "${graytext}" ]] && [[ "${graytext}" != "${DEFAULT_graytext}" ]]; then echo "[${graytext}]"; fi)"
    printf "|${purpletext}%-${EXPORT_TAB}s${resetcolor} | %-${COMMENT_TAB}s | ${greentext}%-${DEFAULT_TAB}s${resetcolor} | ${redtext}%-${CURRENT_TAB}s${resetcolor}|\n" "export redtext=<color_code>" "#Replace the red color used in the script" "[${DEFAULT_redtext}]" "$(if [[ ! -z "${redtext}" ]] && [[ "${redtext}" != "${DEFAULT_redtext}" ]]; then echo "[${redtext}]"; fi)"
    printf "|${purpletext}%-${EXPORT_TAB}s${resetcolor} | %-${COMMENT_TAB}s | ${greentext}%-${DEFAULT_TAB}s${resetcolor} | ${redtext}%-${CURRENT_TAB}s${resetcolor}|\n" "export greentext=<color_code>" "#Replace the green color used in the script" "[${DEFAULT_greentext}]" "$(if [[ ! -z "${greentext}" ]] && [[ "${greentext}" != "${DEFAULT_greentext}" ]]; then echo "[${greentext}]"; fi)"
    printf "|${purpletext}%-${EXPORT_TAB}s${resetcolor} | %-${COMMENT_TAB}s | ${greentext}%-${DEFAULT_TAB}s${resetcolor} | ${redtext}%-${CURRENT_TAB}s${resetcolor}|\n" "export yellowtext=<color_code>" "#Replace the yellow color used in the script" "[${DEFAULT_yellowtext}]" "$(if [[ ! -z "${yellowtext}" ]] && [[ "${yellowtext}" != "${DEFAULT_yellowtext}" ]]; then echo "[${yellowtext}]"; fi)"
    printf "|${purpletext}%-${EXPORT_TAB}s${resetcolor} | %-${COMMENT_TAB}s | ${greentext}%-${DEFAULT_TAB}s${resetcolor} | ${redtext}%-${CURRENT_TAB}s${resetcolor}|\n" "export bluetext=<color_code>" "#Replace the blue color used in the script" "[${DEFAULT_bluetext}]" "$(if [[ ! -z "${bluetext}" ]] && [[ "${bluetext}" != "${DEFAULT_bluetext}" ]]; then echo "[${bluetext}]"; fi)"
    printf "|${purpletext}%-${EXPORT_TAB}s${resetcolor} | %-${COMMENT_TAB}s | ${greentext}%-${DEFAULT_TAB}s${resetcolor} | ${redtext}%-${CURRENT_TAB}s${resetcolor}|\n" "export purpletext=<color_code>" "#Replace the purple color used in the script" "[${DEFAULT_purpletext}]" "$(if [[ ! -z "${purpletext}" ]] && [[ "${purpletext}" != "${DEFAULT_purpletext}" ]]; then echo "[${purpletext}]"; fi)"
    printf "|${purpletext}%-${EXPORT_TAB}s${resetcolor} | %-${COMMENT_TAB}s | ${greentext}%-${DEFAULT_TAB}s${resetcolor} | ${redtext}%-${CURRENT_TAB}s${resetcolor}|\n" "export cyantext=<color_code>" "#Replace the cyan color used in the script" "[${DEFAULT_cyantext}]" "$(if [[ ! -z "${cyantext}" ]] && [[ "${cyantext}" != "${DEFAULT_cyantext}" ]]; then echo "[${cyantext}]"; fi)"
    printf "|${purpletext}%-${EXPORT_TAB}s${resetcolor} | %-${COMMENT_TAB}s | ${greentext}%-${DEFAULT_TAB}s${resetcolor} | ${redtext}%-${CURRENT_TAB}s${resetcolor}|\n" "export whitetext=<color_code>" "#Replace the white color used in the script" "[${DEFAULT_whitetext}]" "$(if [[ ! -z "${whitetext}" ]] && [[ "${whitetext}" != "${DEFAULT_whitetext}" ]]; then echo "[${whitetext}]"; fi)"
    printf "|${purpletext}%-${EXPORT_TAB}s${resetcolor} | %-${COMMENT_TAB}s | ${greentext}%-${DEFAULT_TAB}s${resetcolor} | ${redtext}%-${CURRENT_TAB}s${resetcolor}|\n" "export resetcolor=<color_code>" "#Replace the color used to rest colors in the script" "[${DEFAULT_resetcolor}]" "$(if [[ ! -z "${resetcolor}" ]] && [[ "${resetcolor}" != "${DEFAULT_resetcolor}" ]]; then echo "[${resetcolor}]"; fi)"
    printf "|%-${EXPORT_TAB}s---%-${COMMENT_TAB}s---%-${DEFAULT_TAB}s---%-${CURRENT_TAB}s|\n" |tr \  '-'
    MAX_RANDOM=1
  else
    echo -e "\nYou can use the '-d' option with the '-h' to display the custommizable variables"
  fi
  fct_version
  exit 0
}

fct_version() {
  Script=$(which $0 2>${STD_ERR})
  if [[ "${Script}" != "bash" ]] && [[ ! -z ${Script} ]]
  then
    VERSION=$(grep "@VERSION" ${Script} 2>${STD_ERR} | grep -Ev "VERSION=" | cut -d'#' -f3)
    VERSION=${VERSION:-" N/A"}
    RANDOM_CHECK=$(awk -v min=1 -v max=${MAX_RANDOM} 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')
    if [[ ${RANDOM_CHECK} == 1 ]]
    then
      My_TTY=$(who am i | awk '{print $2}')
      NEW_VERSION=$(curl -Ns --connect-timeout 2 --max-time 4 "${SOURCE_RAW_URL}" 2>${STD_ERR} | grep "@VERSION" | grep -Ev "VERSION=" | cut -d'#' -f3)
      NEW_VERSION=${NEW_VERSION:-" N/A"}
      if [[ "${VERSION}" != "${NEW_VERSION}" ]] && [[ "${NEW_VERSION}" != " N/A" ]] && [[ "${VERSION}" != " N/A" ]]
      then
        UPDATE_MSG="Current Version:\t${redtext}${VERSION}${resetcolor} | Please considere to update. Thanks\nAvailable Version:\t${NEW_VERSION}\n[Source: ${bluetext}${SOURCE_URL}${resetcolor}]"
      else
        if [[ "${NEW_VERSION}" == " N/A" ]] && [[ "${VERSION}" != " N/A" ]]
        then
          SCRIPT_mtime=$(ls -l ${ls_option} $(which $0) | awk '{print $(NF-1)}' | sed -e "s/+//")
          Time_Gap=$[$Current_time - $SCRIPT_mtime]
          if [[ ${Time_Gap} -gt ${Time_Gap_Alert} ]]
          then
            UPDATE_MSG="Current Version:\t${redtext}${VERSION}${resetcolor} | The script $(basename ${0}) is older (${Time_Gap}) than $[${Time_Gap_Alert} / 86400] days.\nPlease consider to update it if a new version is available. Thanks\n[Source: ${bluetext}${SOURCE_URL}${resetcolor}]"
          fi
        else
          UPDATE_MSG="Current Version:\t${greentext}${VERSION}${resetcolor} | The script is up-to-date. Thanks"
        fi
      fi
      echo -e "\n$UPDATE_MSG"
    fi
  fi
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
  echo -e "\n====== $* ======"
}

fct_title_details() {
  echo -e "\n##### $* #####"
}

fct_unsuccessful_pod_details() {
  ALL_PODS_JSON=${ALL_PODS_JSON:-$(${OC} get pod -A -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")}
  Pending_PODs=$(echo "${ALL_PODS_JSON}" | jq -r --arg trunk ${POD_TRUNK} '.items[] | select((.metadata.deletionTimestamp == null) and (.status.phase == "Pending")) | .metadata.namespace + "/" + .metadata.name + "|" + .metadata.creationTimestamp + "|R-" + .status.phase + "-R|" + (if ((.status.conditions[] | select(.type == "PodScheduled") | .message) != null) then (.status.conditions[] | select(.type == "PodScheduled") | (.message[0:($trunk|tonumber)])) | sub("\n";" ";"g") elif ((.status.conditions[] | select(.type == "ContainersReady") | .message) != null) then (.status.conditions[] | select(.type == "ContainersReady") | (.message[0:($trunk|tonumber)] | sub("\n";" ";"g"))) else "null" end)')
  if [[ ! -z ${Pending_PODs} ]]
  then
    fct_title_details "Unsuccessful PODs - Pending - Details"
    echo -e "NAME|creationTimestamp|STATUS|Message\n${Pending_PODs}" | column -t -s'|' | sed -e "s/R-\([0-9a-zA-Z \.\-]*\)-R/${redtext}\1    ${resetcolor}/"
  fi
  Terminating_PODs=$(echo "${ALL_PODS_JSON}" | jq -r --arg trunk ${POD_TRUNK} '.items[] | select((.metadata.deletionTimestamp != null) and (.status.phase == "Running")) | .metadata.namespace + "/" + .metadata.name + "|" + .metadata.creationTimestamp + "|" + .metadata.deletionTimestamp + "|(" + (.metadata.deletionGracePeriodSeconds|tostring) + ")|Terminating|" + (.status.conditions[] | select((.type == "Ready") and (.status != "True")) | (.message[0:($trunk|tonumber)] | sub("\n";" ";"g")))')
  if [[ ! -z ${Terminating_PODs} ]]
  then
    fct_title_details "Unsuccessful PODs - Terminating - Details"
    echo -e "NAME|creationTimestamp|deletionTimestamp|(GracePeriodSeconds)|STATUS|Message\n${Terminating_PODs}" | column -t -s'|' | sed -e "s/Terminating/${yellowtext}&${resetcolor}/"
  fi
  Failed_PODs=$(echo "${ALL_PODS_JSON}"| jq -r --arg trunk ${POD_TRUNK} '.items[] | select((.metadata.deletionTimestamp == null) and (.status.phase == "Running") and (.status | (.containerStatuses != null) and (.containerStatuses[].ready == false))) | .metadata.namespace + "/" + .metadata.name + "|" + .metadata.creationTimestamp + "|" + (.status.conditions[] | select(.type == "Ready") | .lastTransitionTime) + "|R-" + (.status.containerStatuses[] | select(.state.waiting.reason != null) | .state.waiting.reason) + "-R|" + (.status.conditions[] | select(.type == "Ready") | (.message[0:($trunk|tonumber)] | sub("\n";" ";"g")))')
  if [[ ! -z ${Failed_PODs} ]]
  then
    fct_title_details "Unsuccessful PODs - Failed - Details"
    echo -e "NAME|creationTimestamp|lastTransitionTime|STATUS|Message\n${Failed_PODs}" | column -t -s'|' | sed -e "s/R-\([0-9a-zA-Z \.\-]*\)-R/${redtext}\1    ${resetcolor}/"
  fi
}

fct_unsuccessful_container_details() {
  if [[ -z ${NAMESPACE=} ]]
  then
    ALL_PODS=${ALL_PODS:-$(${OC} get pod -A ${WIDE_OPTION} 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")}
  else
    ALL_PODS=$(${OC} get pods -n ${NAMESPACE} ${WIDE_OPTION} 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")
  fi
  ALL_PODS_JSON=${ALL_PODS_JSON:-$(${OC} get pod -A -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")}
  UNCOMPLETE_POD_JSON=$(echo "${ALL_PODS_JSON}" | jq -r '[.items[] | select((.status.phase != "Succeeded") and ((.status.containerStatuses != null) and (.status.containerStatuses[] | select(.state | to_entries[] | (.key == "terminated") and (.value.reason == "Completed") | not))) and ((.status.containerStatuses == null) or ([(.status.containerStatuses[].state | if(to_entries[]| .key == "running") then 1 else 0 end)] | add) != (.spec.containers | length)))] | unique')
  UNCOMPLETE_POD_LIST=$(echo "${UNCOMPLETE_POD_JSON}" | jq -r '.[].metadata | " \(.namespace)/\(.name)"')
  echo "${ALL_PODS}" | grep -E "^NAME"
  for POD_details in ${UNCOMPLETE_POD_LIST}
  do
    namespace=$(echo ${POD_details} | cut -d'/' -f1)
    pod_name=$(echo ${POD_details} | cut -d'/' -f2)
    if [[ -z ${NAMESPACE} ]]
    then
      echo "${ALL_PODS}" | grep -E "^${namespace} *${pod_name}" | sed -e "s/ [0-9]*\/[0-9]* /${yellowtext}&${resetcolor}/"
    else
      echo "${ALL_PODS}" | grep -E "^${pod_name}" | sed -e "s/ [0-9]*\/[0-9]* /${yellowtext}&${resetcolor}/"
    fi
    CONTAINER_DETAILS=""
    EXTRACT_CONTAINER_DETAILS=$(echo "${UNCOMPLETE_POD_JSON}" | jq -r --arg namespace ${namespace} --arg podname ${pod_name} --arg trunk ${POD_TRUNK} '.[] | select((.metadata.namespace == $namespace) and (.metadata.name == $podname)) | .status | if (.containerStatuses != null) then (.containerStatuses[] | select(.ready != true) | { "name": .name, "state": .state | to_entries[] | .key, "restartCount": .restartCount, "startedAt": (if (.lastState != {}) then (.lastState | to_entries[] | .value.startedAt) else (.state | to_entries[] | .value.startedAt) end), "exitCode": (if (.lastState != {}) then (.lastState | to_entries[] | .value.exitCode) else (.state | to_entries[] | .value.exitCode) end), "reason": (if (.state | to_entries[] | .value.reason == "CrashLoopBackOff" ) then (.state | to_entries[] | .value.reason) elif (.lastState != {}) then (.lastState | to_entries[] | .value.reason) else (.state | to_entries[] | .value.reason) end), "message": .state | to_entries[] | (if .value.message != null  then .value.message[0:($trunk|tonumber)] | sub("\n";" ";"g") else "" end) } ) else "" end')
    if [[ ! -z ${EXTRACT_CONTAINER_DETAILS} ]]
    then
      CONTAINER_DETAILS=$(echo "${EXTRACT_CONTAINER_DETAILS}" | sed -e "s/\\\n/_/g" | jq -r '"\(.name)+\(.state)+\(.restartCount)+\(.startedAt)+\(.exitCode)+\(.reason)+\(.message | sub("\n";" ";"g"))"' | sed -e "s/ /_/g")
    fi
    for line in "Container Name+state+restartCount+startedAt+exitCode+reason+message" "--------------+-----+------------+---------+--------+--------+---------" ${CONTAINER_DETAILS}
    do
      printf "|-> %-32s %-12s %-15s %-22s %-10s %-22s %-10s\n" "$(echo ${line} | cut -d'+' -f1)" "$(echo ${line} | cut -d'+' -f2)" "$(echo ${line} | cut -d'+' -f3)" "$(echo ${line} | cut -d'+' -f4)" "$(echo ${line} | cut -d'+' -f5)" "$(echo ${line} | cut -d'+' -f6)" "$(echo ${line} | cut -d'+' -f7 | sed -e "s/_/ /g")"
    done
    echo
  done
}

fct_restart_container_details() {
  if [[ -z ${NAMESPACE=} ]]
  then
    ALL_PODS=${ALL_PODS:-$(${OC} get pod -A ${WIDE_OPTION} 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")}
  else
    ALL_PODS=$(${OC} get pods -n ${NAMESPACE} ${WIDE_OPTION} 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")
  fi
  ALL_PODS_JSON=${ALL_PODS_JSON:-$(${OC} get pod -A -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")}
  RESTARTED_POD_JSON=$(echo "${ALL_PODS_JSON}" | jq -r --arg min_restart ${MIN_RESTART} '[.items[] | select((.status.containerStatuses != null) and (([.status.containerStatuses[].restartCount | tonumber] | add) > ($min_restart | tonumber))) ] | unique')
  RESTART_POD_LIST=$(echo "${RESTARTED_POD_JSON}" | jq -r '.[].metadata | "\(.namespace)/\(.name)"')
  echo "${ALL_PODS}" | grep -E "^NAME"
  for POD_details in ${RESTART_POD_LIST}
  do
    NAMETAB=32
    namespace=$(echo ${POD_details} | cut -d'/' -f1)
    pod_name=$(echo ${POD_details} | cut -d'/' -f2)
    if [[ -z ${NAMESPACE} ]]
    then
      echo "${ALL_PODS}" | grep -E "^${namespace} *${pod_name}" | sed -e "s/ [0-9]\{1,2\} /${yellowtext}&${resetcolor}/" -e "s/ [0-9]\{3,5\} /${redtext}&${resetcolor}/"
    else
      echo "${ALL_PODS}" | grep -E "^${pod_name}" | sed -e "s/ [0-9]\{1,2\} /${yellowtext}&${resetcolor}/" -e "s/ [0-9]\{3,5\} /${redtext}&${resetcolor}/"
    fi
    ### The POD restartCount is now a Total of all containers restartCount, updating the query to display all containers with "restartCount > 0" sorted by highest numbers
    CONTAINER_DETAILS=$(echo "${RESTARTED_POD_JSON}" | jq -r --arg namespace ${namespace} --arg podname ${pod_name} --arg trunk ${POD_TRUNK} '.[] | select((.metadata.namespace == $namespace) and (.metadata.name == $podname)) | .status.containerStatuses | sort_by(-.restartCount,.name) | .[] | select(.restartCount >  0) | "\(.name)+\(.state | to_entries[] | .key)+\(.restartCount)+\(if (.lastState != {}) then (.lastState | to_entries[] | .value.startedAt) else (.state | to_entries[] | .value.startedAt) end)+\(if (.lastState != {}) then (.lastState | to_entries[] | .value.finishedAt) else null end)+\(if (.lastState != {}) then (.lastState | to_entries[] | .value.exitCode) else (.state | to_entries[] | .value.exitCode) end)+\(if (.state | to_entries[] | .value.reason == "CrashLoopBackOff" ) then (.state | to_entries[] | "\(.value.reason)+\(if (.value.message != null) then .value.message[0:($trunk|tonumber)] | sub("\n";" ";"g") else "<Empty>" end)") elif (.lastState != {}) then (.lastState | to_entries[] | "\(.value.reason)+\(if (.value.message != null) then .value.message[0:($trunk|tonumber)] | sub("\n";" ";"g") else "<Empty>" end)") else (.state | to_entries[] | "\(.value.reason)+\(if (.value.message != null) then .value.message[0:($trunk|tonumber)] | sub("\n";" ";"g") else "<Empty>" end)") end)"' | sed -e "s/ /_/g")
    LONGEST_NAME=$(echo "${CONTAINER_DETAILS}" | awk -F'+' 'BEGIN{longest=0}{if(length($1) > longest){longest=length($1)}}END{print longest}')
    LONGEST_NAME=${LONGEST_NAME:-0}
    if [[ ${LONGEST_NAME} -gt 32 ]]
    then
      NAMETAB=${LONGEST_NAME}
    fi
    for line in "Container Name+state+restartCount+lastStartedAt+lastEndedAt+exitCode+reason+Message" "--------------+-----+------------+-------------+-----------+--------+------+-------" ${CONTAINER_DETAILS}
    do
      printf "|-> %-${NAMETAB}s %-12s %-15s %-22s %-22s %-10s %-20s %-${POD_TRUNK}s\n" "$(echo ${line} | cut -d'+' -f1)" "$(echo ${line} | cut -d'+' -f2)" "$(echo ${line} | cut -d'+' -f3)" "$(echo ${line} | cut -d'+' -f4)" "$(echo ${line} | cut -d'+' -f5)" "$(echo ${line} | cut -d'+' -f6)" "$(echo ${line} | cut -d'+' -f7)" "$(echo ${line} | cut -d'+' -f8 | sed -e "s/_/ /g")" | sed -e "s/|-> \([-a-z ]*\)\([0-9]\{3,10\}\)/|-> \1${redtext}\2${resetcolor}/" -e "s/|-> \([-a-z ]*\)\([0-9]\{1,2\}\)/|-> \1${yellowtext}\2${resetcolor}/"
    done
    echo
  done
}

##### Default/Main Variables
# Default variables
ScriptName="mg_cluster_status.sh"
DEFAULT_OC="omc"
DEFAULT_TRUNK="100"
DEFAULT_WIDE="true"
DEFAULT_CONDITION_TRUNK="220"
DEFAULT_MIN_RESTART="10"
DEFAULT_TAIL_LOG="15"
DEFAULT_NODE_TRANSITION_DAYS=30
DEFAULT_OPERATOR_TRANSITION_DAYS=2
DEFAULT_graytext="\x1B[30m"
DEFAULT_redtext="\x1B[31m"
DEFAULT_greentext="\x1B[32m"
DEFAULT_yellowtext="\x1B[33m"
DEFAULT_bluetext="\x1B[34m"
DEFAULT_purpletext="\x1B[35m"
DEFAULT_cyantext="\x1B[36m"
DEFAULT_whitetext="\x1B[37m"
DEFAULT_resetcolor="\x1B[0m"
# Defining a Variable to exclude all of the undesired messages from omc, oc, ...
MESSAGE_EXCLUSION="^$|^No resources|^resource type|^Error from server (NotFound):"
# Source URLs & version time_gap
SOURCE_RAW_URL="https://raw.githubusercontent.com/vlours/mg_cluster_status/main/mg_cluster_status.sh"
SOURCE_URL="https://github.com/vlours/mg_cluster_status/"
Time_Gap_Alert=${Time_Gap_Alert:-7776000}         # => 90 days gap
# Color list
graytext=${graytext:-${DEFAULT_graytext}}
redtext=${redtext:-${DEFAULT_redtext}}
greentext=${greentext:-${DEFAULT_greentext}}
yellowtext=${yellowtext:-${DEFAULT_yellowtext}}
bluetext=${bluetext:-${DEFAULT_bluetext}}
purpletext=${purpletext:-${DEFAULT_purpletext}}
cyantext=${cyantext:-${DEFAULT_cyantext}}
whitetext=${whitetext:-${DEFAULT_whitetext}}
resetcolor=${resetcolor:-${DEFAULT_resetcolor}}
# Max random number to check for update
MAX_RANDOM=10
# Set a default STD_ERR, which can be replaced for debugging to "/dev/stderr"
STD_ERR="${STD_ERR:-/dev/null}"
# Content variables not allowing exported content
unset NODE_JSON NOT_READY KUBELETCONFIG AVAILABLE_MACHINES CLUSTERAUTOSCALER NODE_JSON MACHINESETS_JSON MACHINES_JSON CLUSTER_VERSION CO_MISS_VERSION_OUTPUT UNHEALTHY_OPERATORS MCP_NODE_DEGRADED PROCESSING_MCP DEGRADED_NODES MCO_PODS ALL_SCC_JSON ALL_PODS ALL_PODS_JSON
# Plateform variables
Current_time=$(date +%s)
case $(uname) in
  "Darwin")
    LAST_28days=$(date -r $[$(date +%s) - 2419200] +%Y-%m)
    THIS_month=$(date -r $(date +%s) +%Y-%m)
    ls_option="-D +%s"
    ;;
  *)
    LAST_28days=$(date -d @$[$(date +%s) - 2419200] +%Y-%m)
    THIS_month=$(date -d @$(date +%s) +%Y-%m)
    ls_option="--time-style=+%s"
    ;;
esac

##### Main
if [[ $# != 0 ]]
then
  if [[ $1 == "-" ]] || [[ $1 =~ ^[a-zA-Z] ]]
  then
    echo -e "Invalid option: ${1}\n"
    fct_help && exit 1
  fi
  while getopts :acevMmN:nopsSdh arg; do
  case $arg in
      a)
        ALERTS=true
        ;;
      c)
        CONTEXT=true
        ;;
      e)
        ETCD=true
        ;;
      v)
        EVENTS=true
        ;;
      M)
        MACHINES=true
        HAS_DETAILS=true
        ;;
      m)
        MCO=true
        HAS_DETAILS=true
        ;;
      N)
        NAMESPACE=$OPTARG
        ;;
      n)
        NODES=true
        HAS_DETAILS=true
        ;;
      o)
        OPERATORS=true
        HAS_DETAILS=true
        ;;
      p)
        PODS=true
        HAS_DETAILS=true
        ;;
      s)
        STATICPOD=true
        HAS_DETAILS=true
        ;;
      S)
        SCC=true
        HAS_DETAILS=true
        ;;
      d)
        DETAILS=true
        ;;
      h)
        HELP=true
        ;;
      ?)
        echo -e "Invalid option: ${1}\n"
        fct_help && exit 1
        ;;
    esac
  done
else
  ALL=true
fi

if [[ -z ${POD_WIDE} ]] || [[ ${POD_WIDE} == ${DEFAULT_WIDE} ]]
then
  WIDE_OPTION="-o wide"
else
  unset WIDE_OPTION
fi

if [[ ! -z ${HELP} ]]
then
  fct_help
fi
if [[ $* == "-d" ]]
then
  echo "The '-d' option should only be use with one or multiple filters"
  fct_help
fi
if [[ -z ${HAS_DETAILS} ]] && [[ ! -z ${DETAILS} ]]
then
  echo -e "${cyantext}[Info] The parameters used has no detailed output. The '-d' option will be ignored${resetcolor}"
fi
##### Main Variables
# OC command to use - Default: omc
OC=${OC:-${DEFAULT_OC}}
# Set the Trunk variables (from default if not already set)
ALERT_TRUNK=${ALERT_TRUNK:-${DEFAULT_TRUNK}}
CONDITION_TRUNK=${CONDITION_TRUNK:-${DEFAULT_CONDITION_TRUNK}}
POD_TRUNK=${POD_TRUNK:-${DEFAULT_TRUNK}}
# Minimal restart count for PODs
MIN_RESTART=${MIN_RESTART:-${DEFAULT_MIN_RESTART}}
TAIL_LOG=${TAIL_LOG:-${DEFAULT_TAIL_LOG}}
# Conditions Transitions limits:
NODE_TRANSITION_DAYS=${NODE_TRANSITION_DAYS:-${DEFAULT_NODE_TRANSITION_DAYS}}
OPERATOR_TRANSITION_DAYS=${OPERATOR_TRANSITION_DAYS:-${DEFAULT_OPERATOR_TRANSITION_DAYS}}

if [[ ! -f $(which ${OC} 2>${STD_ERR}) ]]
then
  echo -e "${OC}: command not found!\nPlease check your PATH, or set the variable OC with the right value"
  exit 2
fi

${OC} project default >${STD_ERR} 2>${STD_ERR}

########### CONTEXT ###########
if [[ ! -z ${CONTEXT} ]] || [[ ! -z ${ALL} ]]
then
  fct_header "CLUSTER CONTEXT"
  fct_title "Clusterversion"
  ${OC} get clusterversion.config.openshift.io 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | awk '{printf "%s|%s|",$1,$2; if($3 == "AVAILABLE"){printf "%s|",$3} else if($3 == "True"){printf "G%s|",$3}else{printf "R%s|",$3}; if($4 == "PROGRESSING"){printf "%s|",$4} else if($4 == "True"){printf "Y%s|",$4}else{printf "G%s|",$4}; printf "%s|%s|\n",$5,substr($0,index($0,$6))}' | column -t -s '|' | sed -e "s/G\([FT][a-z]*\)/${greentext}\1 ${resetcolor}/g" -e "s/Y\([FT][a-z]*\)/${yellowtext}\1 ${resetcolor}/g" -e "s/R\([FT][a-z]*\)/${redtext}\1 ${resetcolor}/g"
  fct_title "Clusterversion detailed"
  ${OC} get clusterversion.config.openshift.io version -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}"| jq -r '. | del(.metadata.managedFields,.status.availableUpdates)' | sed -e "s/overrides/${redtext}overrides${resetcolor}/g"
  fct_title "Type of Installation"
  INSTALLER_INVOKER=$(${OC} get configmaps -n openshift-config openshift-install-manifests -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | jq -r .data.invoker)
  case ${INSTALLER_INVOKER} in
    "hypershift","agent-installer","infrastructure-operator"|"assisted-installer"|"hive")
      INSTALL_TYPE=${INSTALLER_INVOKER}
      ;;
    "null")
      INSTALL_TYPE="unknown"
      ;;
    "openshift-install")
      INSTALL_TYPE="ipi"
      ;;
    *)
      INSTALL_TYPE="upi"
      ;;
  esac
  echo "Install Type: ${INSTALL_TYPE}"
  fct_title "Infrastructure"
  ${OC} get infrastructures.config.openshift.io cluster -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | jq -r .status
  ALL_PODS=${ALL_PODS:-$(${OC} get pod -A ${WIDE_OPTION} 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")}
  NB_KEEPALIVE_PODS=$(echo "${ALL_PODS}" | awk 'BEGIN{count=0};{if(($1 ~ "openshift-[-a-z]*-infra") && ($2 ~ "keepalived")){count++}};END{print count}')
  if [[ ${NB_KEEPALIVE_PODS} -gt 0 ]]
  then
    fct_title "KeepAlive VIP"
    NODE_JSON=${NODE_JSON:-$(${OC} get nodes -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")}
    NB_NODES=$(echo "${NODE_JSON}" | jq -r '.items | length')
    echo -e "${yellowtext}KeepAlive VIPs seems in use in this cluster.${resetcolor}"
    echo -e "NB of KeepAlive PODs:|${yellowtext}${NB_KEEPALIVE_PODS}${resetcolor}\nNB of Nodes:|${yellowtext}${NB_NODES}${resetcolor}" | column -t -s'|'
  fi
  fct_title "Network Config"
  ${OC} get network.config.openshift.io cluster -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | jq -r .spec
  fct_title "Proxy config"
  ${OC} get proxy.config.openshift.io cluster -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | jq -r .spec
fi

########### NODES ###########
if [[ ! -z ${NODES} ]] || [[ ! -z ${ALL} ]]
then
  fct_header "NODE STATUS"
  fct_title "Nodes"
  ${OC} get nodes -o wide 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | sed -e "s/SchedulingDisabled/${yellowtext}&${resetcolor}/" -e "s/NotReady/${redtext}&${resetcolor}/" -e "s/master/${cyantext}&${resetcolor}/g" -e "s/worker/${purpletext}&${resetcolor}/g" -e "s/infra/${yellowtext}&${resetcolor}/g"
  NODE_JSON=${NODE_JSON:-$(${OC} get nodes -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")}
  NOT_READY=${NOT_READY:-$(echo "${NODE_JSON}" | jq -r '.items[] | select(.status.conditions[] | select((.type == "Ready") and (.status != "True"))) | "\(.metadata.name)|NotReady|\(.status.conditions[] | select(.type == "Ready") | .lastTransitionTime)"')}
  if [[ ! -z ${NOT_READY} ]]
  then
    fct_title "NotReady Nodes"
    echo -e "Name |Status|lastTransition\n${NOT_READY}" | column -t -s'|' | sed -e "s/^[-a-z0-9]*/${redtext}&${resetcolor}/" -e "s/[-:0-9A-Z]*$/${yellowtext}&${resetcolor}/"
  fi
  if [[ ! -z ${DETAILS} ]]
  then
    fct_title_details "Node details"
    echo "${NODE_JSON}" | jq -r '" |CPU| |Memory| |ephemeral-storage|\nNodename|Capacity|Allocatable|Capacity|Allocatable|Capacity|Allocatable|pods|hugepages-1Gi|hugepages-2Mi|Taints",(.items | sort_by(.metadata.name)|.[]|"\(.metadata.name)|\(.status.capacity.cpu)|\(.status.allocatable.cpu)|\(.status.capacity.memory)|\(.status.allocatable.memory)|\(.status.capacity."ephemeral-storage")|\((.status.allocatable."ephemeral-storage"|tonumber)/1024|round)Ki|\(.status.capacity.pods)|\(.status.capacity."hugepages-1Gi")|\(.status.capacity."hugepages-2Mi")|\(if(.spec.taints != null) then [.spec.taints[]] else "null" end)")'| column -s'|' -t | sed  -e "s/master/${cyantext}&${resetcolor}/g" -e "s/worker/${purpletext}&${resetcolor}/g" -e "s/infra/${yellowtext}&${resetcolor}/g" -e "s/node.kubernetes.io\/[a-z\-]*/${redtext}&${resetcolor}/g"
    fct_title_details "Node Conditions (yellow = transition within last ${NODE_TRANSITION_DAYS} days)"
    GAWK_PATH=${GAWK_PATH:-$(which gawk 2>${STD_ERR})}
    if [[ -z ${GAWK_PATH} ]]
    then
      echo "WARNING: Unable to display this detailed view as it requires 'gawk' to run. Please consider installing it on this server"
      echo "         Using previous script version displaying transitions between 28-59 days"
      echo "${NODE_JSON}" | jq -r '" |Ready| | |MemoryPressure| | |DiskPressure| | |PIDPressure\nNodename|Status|lastTransitionTime|lastHeartbeatTime|Status|lastTransitionTime|lastHeartbeatTime|Status|lastTransitionTime|lastHeartbeatTime|Status|lastTransitionTime|lastHeartbeatTime|",(.items | sort_by(.metadata.name)|.[]|"\(.metadata.name)|\(.status.conditions[]|select(.type == "Ready")|"\(.status)|\(.lastTransitionTime)|\(.lastHeartbeatTime)")|\(.status.conditions[]|select(.type == "MemoryPressure")|"\(.status)|\(.lastTransitionTime)|\(.lastHeartbeatTime)")|\(.status.conditions[]|select(.type == "DiskPressure")|"\(.status)|\(.lastTransitionTime)|\(.lastHeartbeatTime)")|\(.status.conditions[]|select(.type == "PIDPressure")|"\(.status)|\(.lastTransitionTime)|\(.lastHeartbeatTime)")")' | column -t -s'|' | sed -e "s/\([TFU][a-z]* *\)\(${THIS_month}[-:T0-9]*Z\)/\1${yellowtext}\2${resetcolor}/g" -e "s/\([TFU][a-z]* *\)\(${LAST_28days}[-:T0-9]*Z\)/\1${yellowtext}\2${resetcolor}/g" -e "s/\(^[- .a-zA-Z0-9]* *\)True/\1${greentext}True${resetcolor}/" -e "s/\(^[- .a-zA-Z0-9]* *\)False/\1${redtext}False${resetcolor}/" -e "s/\(^[- .a-zA-Z0-9]* *\)Unknown/\1${redtext}Unknown${resetcolor}/" -e "s/\([-:TZ0-9]*Z *\)True/\1${redtext}True${resetcolor}/g" -e "s/\([-:T0-9]*Z *\)False/\1${greentext}False${resetcolor}/g" -e "s/\([-:T0-9]*Z *\)Unknown/\1${redtext}Unknown${resetcolor}/g"
    else
      TRANSITION_DAYS=$[${Current_time} - (${NODE_TRANSITION_DAYS} * 24 * 3600)]
      echo "${NODE_JSON}" | jq -r '" |Ready| | |MemoryPressure| | |DiskPressure| | |PIDPressure\nNodename|Status|lastTransitionTime|lastHeartbeatTime|Status|lastTransitionTime|lastHeartbeatTime|Status|lastTransitionTime|lastHeartbeatTime|Status|lastTransitionTime|lastHeartbeatTime|",(.items | sort_by(.metadata.name)|.[]|"\(.metadata.name)|\(.status.conditions[]|select(.type == "Ready")|"\(.status)|\(.lastTransitionTime)|\(.lastHeartbeatTime)")|\(.status.conditions[]|select(.type == "MemoryPressure")|"\(.status)|\(.lastTransitionTime)|\(.lastHeartbeatTime)")|\(.status.conditions[]|select(.type == "DiskPressure")|"\(.status)|\(.lastTransitionTime)|\(.lastHeartbeatTime)")|\(.status.conditions[]|select(.type == "PIDPressure")|"\(.status)|\(.lastTransitionTime)|\(.lastHeartbeatTime)")")' 2>${STD_ERR} | ${GAWK_PATH} -F'|' -v daysbefore=${TRANSITION_DAYS} '{printf "%s|%s|",$1,$2; if(($3 == "lastTransitionTime")||($3==" ")){printf "%s|",$3}else{time=gensub(/[-:TZ]/," ","g",$3);epoch_fmt=mktime(time);if(epoch_fmt > daysbefore){printf "Y_%s|",$3}else{printf "%s|",$3}}; printf "%s|%s|",$4,$5; if(($6 == "lastTransitionTime")||($6==" ")){printf "%s|",$6}else{time=gensub(/[-:TZ]/," ","g",$6);epoch_fmt=mktime(time);if(epoch_fmt > daysbefore){printf "Y_%s|",$6}else{printf "%s|",$6}}; printf "%s|%s|",$7,$8;if(($9 == "lastTransitionTime")||($9==" ")){printf "%s|",$9}else{time=gensub(/[-:TZ]/," ","g",$9);epoch_fmt=mktime(time);if(epoch_fmt > daysbefore){printf "Y_%s|",$9}else{printf "%s|",$9}};printf "%s|%s|",$10,$11; if(($12 == "lastTransitionTime")||($12==" ")){printf "%s|",$12}else{time=gensub(/[-:TZ]/," ","g",$12);epoch_fmt=mktime(time);if(epoch_fmt > daysbefore){printf "Y_%s|",$12}else{printf "%s|",$12}};printf "%s\n",$13}' | column -t -s'|' | sed -e "s/\(^[- .a-zA-Z0-9]* *\)True/\1${greentext}True${resetcolor}/" -e "s/\(^[- .a-zA-Z0-9]* *\)False/\1${redtext}False${resetcolor}/" -e "s/\(^[- .a-zA-Z0-9]* *\)Unknown/\1${redtext}Unknown${resetcolor}/" -e "s/\([-:TZ0-9]*Z *\)True/\1${redtext}True${resetcolor}/g" -e "s/\([-:T0-9]*Z *\)False/\1${greentext}False${resetcolor}/g" -e "s/\([-:T0-9]*Z *\)Unknown/\1${redtext}Unknown${resetcolor}/g" -e "s/Y_\([0-9TZ:-]*\)/${yellowtext}\1  ${resetcolor}/g"
    fi
    if [[ "${OC}" != "omg" ]] && [[ "${OC}" != "omc" ]]
    then
      fct_title_details "Node overcommitment"
      ${OC} describe nodes | awk 'BEGIN{ovnsubnet="";printf " |%s| | | | |%s| | | | |%s| |%s\n%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s\n","CPU","MEM","PODs","OVN","NODENAME","Allocatable","Request","(%)","Limit","(%)","Allocatable","Request","(%)","Limit","(%)","Allocatable","Running","Node Subnet"}{if($1 == "Name:"){name=$2};if($1 == "k8s.ovn.org/node-subnets:"){ovnsubnet=$2};if($1 ~ "Allocatable:"){while($1 != "System"){if($1 == "cpu:"){Alloc_cpu=$2};if($1 == "memory:"){Alloc_mem=$2};if($1 == "pods:"){Alloc_pod=$2};getline}};if($1 == "Namespace"){getline;getline;pods_count=0;while($1 != "Allocated"){pods_count++;getline}};if($1 == "Resource"){while($1 != "Events:"){if($1 == "cpu"){req_cpu=$2;preq_cpu=$3;lim_cpu=$4;plim_cpu=$5};if($1 == "memory"){req_mem=$2;preq_mem=$3;lim_mem=$4;plim_mem=$5};getline};printf "%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s\n",name,Alloc_cpu,req_cpu,preq_cpu,lim_cpu,plim_cpu,Alloc_mem,req_mem,preq_mem,lim_mem,plim_mem,Alloc_pod,pods_count,ovnsubnet}}' | sed -e "s/{\"default\":\[\{0,1\}\"\([.\/0-9]*\)\"\]\{0,1\}\]}/\1/" | column -s'|' -t | sed -e "s/([0-9]\{3,4\}%)/${redtext}&${resetcolor}/g" -e "s/(1[0-9]\{2\}%)/${yellowtext}&${resetcolor}/g"
    fi
    KUBELETCONFIG=${KUBELETCONFIG:-$(${OC} get kubeletconfig.machineconfiguration.openshift.io -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | jq -r 'if(.items != null) then . else null end')}
    if [[ "${KUBELETCONFIG}" != "null" ]] && [[ "${KUBELETCONFIG}" != "" ]]
    then
      fct_title_details "System Reserved"
      echo "${KUBELETCONFIG}" | jq -r '"Name|autoSizingReserved|cpu|memory|ephemeral-resource|MCP Label(s)",(if (.items == null) then (.[]|"\(.metadata.name)|\(.spec | if((.autoSizingReserved == null) or (.autoSizingReserved == false)) then false else true end)|\(.spec |if(.kubeletConfig != null and .kubeletConfig.systemReserved != null)then (.kubeletConfig.systemReserved | if(.cpu != null) then .cpu else "-" end) else "-" end)|\(.spec |if(.kubeletConfig != null and .kubeletConfig.systemReserved != null)then (.kubeletConfig.systemReserved | if(.memory != null) then .memory else "-" end) else "-" end)|\(.spec |if(.kubeletConfig != null and .kubeletConfig.systemReserved != null)then (.kubeletConfig.systemReserved | if(."ephemeral-storage" != null) then ."ephemeral-storage" else "-" end) else "-" end)|\(.spec.machineConfigPoolSelector | if (.matchLabels != null) then (.matchLabels | [to_entries[] | (.key | split("/") | if(.[0] == "pools.operator.machineconfiguration.openshift.io") then .[1] else .[0] end) + (if (.value != "") then ": \"\(.value)\"" else "" end) ]) else (.matchExpressions[] | "\(.operator) \(.key)") end)") else (.items[]|"\(.metadata.name)|\(.spec | if((.autoSizingReserved == null) or (.autoSizingReserved == false)) then false else true end)|\(.spec |if(.kubeletConfig != null and .kubeletConfig.systemReserved != null)then (.kubeletConfig.systemReserved | if(.cpu != null) then .cpu else "-" end) else "-" end)|\(.spec |if(.kubeletConfig != null and .kubeletConfig.systemReserved != null)then (.kubeletConfig.systemReserved | if(.memory != null) then .memory else "-" end) else "-" end)|\(.spec |if(.kubeletConfig != null and .kubeletConfig.systemReserved != null)then (.kubeletConfig.systemReserved | if(."ephemeral-storage" != null) then ."ephemeral-storage" else "-" end) else "-" end)|\(.spec.machineConfigPoolSelector | if (.matchLabels != null) then (.matchLabels | [to_entries[] | (.key | split("/") | if(.[0] == "pools.operator.machineconfiguration.openshift.io") then .[1] else .[0] end) + (if (.value != "") then ": \"\(.value)\"" else "" end) ]) else (.matchExpressions[] | "\(.operator) \(.key)") end)") end)' | column -t -s'|'
    fi
  fi
  fct_title "CSRs"
  ${OC} get csr.certificates.k8s.io -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | jq -r '"creationTimestamp|NAME|SIGNERNAME|REQUESTOR|REQUESTEDDURATION|CONDITION",(.items | sort_by(.metadata.creationTimestamp) | .[] | "\(.metadata.creationTimestamp)|\(.metadata.name)|\(.spec.signerName)|\(.spec.username)|<None>|\(if (.status.conditions == null) then "Pending" elif ((.status.certificate != null) and (.status.conditions[].type == "Approved")) then "Approved,Issued" else .status.conditions[0].type end)")' | column -s'|' -t | sed -e "s/Pending/${redtext}&${resetcolor}/" -e "s/Approved.*/${greentext}&${resetcolor}/"
fi

########## Machines ############
if [[ ! -z ${MACHINES} ]] || [[ ! -z ${ALL} ]]
then
  fct_header "MACHINE STATUS"
  AVAILABLE_MACHINES=${AVAILABLE_MACHINES:-$(${OC} get machine.machine.openshift.io -n openshift-machine-api -o wide 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")}
  if [[ ! -z ${AVAILABLE_MACHINES} ]]
  then
    CLUSTERAUTOSCALER=${CLUSTERAUTOSCALER:-$(${OC} get clusterautoscaler.autoscaling.openshift.io default -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | jq -r 'if(.kind != null) then . | del(.metadata.annotations) else null end')}
    if [[ "${CLUSTERAUTOSCALER}" != "null" ]] && [[ "${CLUSTERAUTOSCALER}" != "" ]]
    then
      fct_title "ClusterAutoscaller"
      NODE_JSON=${NODE_JSON:-$(${OC} get nodes -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")}
      currentNodesTotal=$(echo "${NODE_JSON}" | jq -r '.items | length')
      currentCoreTotal=$(echo "${NODE_JSON}" | jq -r '.items[] | .status.capacity.cpu' | awk 'BEFORE{i=0}{i=i+$1}END{print i}')
      currentAmdgpuTotal=$(echo "${NODE_JSON}" | jq -r '.items[] | if .status.capacity."amd.com/gpu" == null then "0" else .status.capacity."amd.com/gpu" end' | awk 'BEFORE{i=0}{i=i+$1}END{print i}')
      currentNvidiagpuTotal=$(echo "${NODE_JSON}" | jq -r '.items[] | if .status.capacity."nvidia.com/gpu" == null then "0" else .status.capacity."amd.com/gpu" end' | awk 'BEFORE{i=0}{i=i+$1}END{print i}')
      currentMemoryTotal=$(echo "${NODE_JSON}" | jq -r '.items[] | .status.capacity.memory' | sed -e "s/Ki//" | awk 'BEFORE{i=0}{i=i+($1 /1024 /1024)}END{printf "%d",i+.5}')
      fct_title_details "maxNodesTotal"
      echo "${CLUSTERAUTOSCALER}" | jq -r '.spec | "maxNodesTotal: \(.resourceLimits.maxNodesTotal)"' | awk -v current=${currentNodesTotal} '{print;maxvalue=$2;if(maxvalue == current){print "currentNodesTotal: R"current}else{print "currentNodesTotal: G"current}}' | column -t | sed -e "s/G\([0-9]\{1,5\}\\)/${greentext}\1 ${resetcolor}/" -e "s/R\([0-9]\{1,5\}\\)/${redtext}\1 ${resetcolor}/"
      fct_title_details "ResourceLimits"
      echo -e "ResourceLimits|MIN|MAX|CURRENT\n$(echo "${CLUSTERAUTOSCALER}" | jq -r --arg currentcore "${currentCoreTotal}" --arg currentmem "${currentMemoryTotal}" --arg currentgpunvidia "${currentNvidiagpuTotal}" --arg currentgpuamd "${currentAmdgpuTotal}" '(.spec | "cores|\(if .resourceLimits.cores != null then ("\(.resourceLimits.cores.min)|\(.resourceLimits.cores.max)|\(if ($currentcore|tonumber) >= .resourceLimits.cores.max then "R" + $currentcore elif ($currentcore|tonumber) <= .resourceLimits.cores.min then "Y" + $currentcore else "G" + $currentcore end)") else "null|null|G" + $currentcore end)\nmemory|\(if .resourceLimits.memory != null then ("\(.resourceLimits.memory.min)|\(.resourceLimits.memory.max)|\(if ($currentmem|tonumber) >= .resourceLimits.memory.max then "R" + $currentmem elif ($currentmem|tonumber) <= .resourceLimits.memory.min then "Y" + $currentmem else "G" + $currentmem end)") else "null|null|G" + $currentmem end)\n\(if .resourceLimits.gpus != null then (.resourceLimits.gpus[] | if .type == "nvidia.com/gpu" then "gpu-\(.type)|\(.min)|\(.max)|\(if ($currentgpunvidia|tonumber) >= .max then "R" + .max elif ($currentgpunvidia|tonumber) <= .min then "Y" + $currentgpunvidia else "G" + $currentgpunvidia end)" elif .type == "amd.com/gpu" then "gpu-\(.type)|\(.min)|\(.max)|\(if ($currentgpuamd|tonumber) >= .max then "R" + $currentgpuamd elif ($currentgpuamd|tonumber) <= .min then "Y" + $currentgpuamd else "G" + $currentgpuamd end)" else "Unknown_gpu|-|-|-|" end) else "gpu-amd|null|null|G" + $currentgpuamd + "\ngpu-nvidia|null|null|G" + $currentgpunvidia end )")' | sort -u)" | column -t -s'|' | sed -e "s/G\([0-9]\{1,5\}\\)/${greentext}\1 ${resetcolor}/" -e "s/R\([0-9]\{1,5\}\\)/${redtext}\1 ${resetcolor}/" -e "s/Y\([0-9]\{1,5\}\\)/${yellowtext}\1 ${resetcolor}/"
      fct_title_details "scaleDown"
      echo "${CLUSTERAUTOSCALER}" | jq -r '.spec.scaleDown | "enabled: \(.enabled)\nutilizationThreshold: \(.utilizationThreshold)\n--------------------\nDELAY|Value\ndelayAfterAdd|\(.delayAfterAdd)\ndelayAfterDelete|\(.delayAfterDelete)\ndelayAfterFailure|\(.delayAfterFailure)\nunneededTime|\(.unneededTime)"' | column -t -s'|'
      fct_title_details "MachineAutoscaler"
      ${OC} get MachineAutoscaler.autoscaling.openshift.io -n openshift-machine-api 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | sed -e "s/No resource[- a-zA-Z0-9]*\./${yellowtext}&${resetcolor}/"
    fi
    fct_title "MachineSets"
    MACHINESETS_JSON=${MACHINESETS_JSON:-$(${OC} get machineset.machine.openshift.io -n openshift-machine-api -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")}
    if [[ -z ${DETAILS} ]]
    then
      echo "${MACHINESETS_JSON}" | jq -r '"NAME|DESIRED|CURRENT|READY|AVAILABLE|creationTimestamp",(.items[] | "\(.metadata.name)|\(.spec.replicas)|\(if .spec.replicas != .status.replicas then "Y\(.status.replicas)" else "G\(.status.replicas)" end)|\(if .status.readyReplicas != null then (if .spec.replicas != .status.readyReplicas then "Y\(.status.readyReplicas)" else "G\(.status.readyReplicas)" end) else (if .spec.replicas == 0 then "0" else "R0" end) end)|\(if .status.availableReplicas != null then (if .spec.replicas != .status.availableReplicas then "Y\(.status.availableReplicas)" else "G\(.status.availableReplicas)" end) else (if .spec.replicas == 0 then "0" else "Y0" end) end)|\(.metadata.creationTimestamp)")' | column -t -s'|' | sed -e "s/G\([0-9]\{1,5\}\\)/${greentext}\1 ${resetcolor}/g" -e "s/R\([0-9]\{1,5\}\\)/${redtext}\1 ${resetcolor}/g" -e "s/Y\([0-9]\{1,5\}\\)/${yellowtext}\1 ${resetcolor}/g" -e "s/^[-a-zAZ0-9]*master[-a-zAZ0-9]*/${cyantext}&${resetcolor}/" -e "s/^[-a-zAZ0-9]*worker[-a-zAZ0-9]*/${purpletext}&${resetcolor}/" -e "s/^[-a-zAZ0-9]*infra[-a-zAZ0-9]*/${yellowtext}&${resetcolor}/"
    else
      echo "${MACHINESETS_JSON}" | jq -r --arg trunk ${CONDITION_TRUNK} '"NAME|DESIRED|CURRENT|READY|AVAILABLE|creationTimestamp|errorReason|errorMessage",(.items[] | "\(.metadata.name)|\(.spec.replicas)|\(if .spec.replicas != .status.replicas then "Y\(.status.replicas)" else "G\(.status.replicas)" end)|\(if .status.readyReplicas != null then (if .spec.replicas != .status.readyReplicas then "Y\(.status.readyReplicas)" else "G\(.status.readyReplicas)" end) else (if .spec.replicas == 0 then "0" else "R0" end) end)|\(if .status.availableReplicas != null then (if .spec.replicas != .status.availableReplicas then "Y\(.status.availableReplicas)" else "G\(.status.availableReplicas)" end) else (if .spec.replicas == 0 then "0" else "Y0" end) end)|\(.metadata.creationTimestamp)|\(if .status.errorReason != null then .status.errorReason[0:($trunk|tonumber)] else "" end)|\(if .status.errorMessage != null then (.status.errorMessage[0:($trunk|tonumber)] | sub("\n";" ";"g")) else "" end)")' | column -t -s'|' | sed -e "s/G\([0-9]\{1,5\}\\)/${greentext}\1 ${resetcolor}/g" -e "s/R\([0-9]\{1,5\}\\)/${redtext}\1 ${resetcolor}/g" -e "s/Y\([0-9]\{1,5\}\\)/${yellowtext}\1 ${resetcolor}/g" -e "s/^[-a-zAZ0-9]*master[-a-zAZ0-9]*/${cyantext}&${resetcolor}/" -e "s/^[-a-zAZ0-9]*worker[-a-zAZ0-9]*/${purpletext}&${resetcolor}/" -e "s/^[-a-zAZ0-9]*infra[-a-zAZ0-9]*/${yellowtext}&${resetcolor}/"
    fi
    fct_title "Machines"
    echo "${AVAILABLE_MACHINES}" | sed -e "s/[Rr]unning/${greentext}&${resetcolor}/g" -e "s/[Dd]eleting/${redtext}&${resetcolor}/g" -e "s/[Ff]ailed/${redtext}&${resetcolor}/g" -e "s/shutting-down/${redtext}&${resetcolor}/g" -e "s/[Pp]ending/${redtext}&${resetcolor}/g" -e "s/[Pp]rovision[a-z]\{1,5\}/${yellowtext}&${resetcolor}/g"  -e "s/^[-a-zAZ0-9]*master[-a-zAZ0-9]*/${cyantext}&${resetcolor}/" -e "s/^[-a-zAZ0-9]*worker[-a-zAZ0-9]*/${purpletext}&${resetcolor}/" -e "s/^[-a-zAZ0-9]*infra[-a-zAZ0-9]*/${yellowtext}&${resetcolor}/"
    if [[ ! -z ${DETAILS} ]]
    then
      MACHINES_JSON=${MACHINES_JSON:-$(${OC} get machine.machine.openshift.io -n openshift-machine-api -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")}
    fi
  else
    echo -e "No resources found in openshift-machine-api namespace."
  fi
fi

########### OPERATORS ###########
if [[ ! -z ${OPERATORS} ]] || [[ ! -z ${ALL} ]]
then
  fct_header "OPERATOR STATUS"
  CO_JSON=$(${OC} get clusteroperator.config.openshift.io -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")
  if [[ ! -z ${DETAILS} ]]
  then
    fct_title "All Cluster Operators + transitions (yellow = transition within last ${OPERATOR_TRANSITION_DAYS} days)"
    GAWK_PATH=${GAWK_PATH:-$(which gawk 2>${STD_ERR})}
    if [[ -z ${GAWK_PATH} ]]
    then
      echo "WARNING: Unable to display this detailed view as it requires 'gawk' to run. Please consider installing it on this server"
    else
      TRANSITION_DAYS=$[${Current_time} - (${OPERATOR_TRANSITION_DAYS} * 24 * 3600)]
      echo ${CO_JSON} | jq -r --arg trunk ${CONDITION_TRUNK} '" | |AVAILABLE| |PROGRESSING| |DEGRADED| | | |\nNAME|VERSION|status|lastTransitionTime|status|lastTransitionTime|status|lastTransitionTime|LASTTRANSTION|MESSAGE|",(.items[] | "\(.metadata.name)|\(if(.status.versions != null) then (.status.versions[] | select(.name == "operator") | .version) else " " end)|\(if(.status.conditions != null) then ("\(.status.conditions[] |select(.type == "Available") | "\(.status)|\(.lastTransitionTime)")|\(.status.conditions[] |select(.type == "Progressing") | "\(.status)|\(.lastTransitionTime)")|\(.status.conditions[] |select(.type == "Degraded") | "\(.status)|\(.lastTransitionTime)")|\(.status.conditions | if(.[]|select(.type == "Degraded") | (.message != null) and (.status == "True")) then .[]|select(.type == "Degraded") | .lastTransitionTime + "|" + (.message[0:($trunk|tonumber)] | sub("\n";" ";"g")) elif (.[]|select(.type == "Progressing") | (.message != null) and (.status == "True")) then .[]|select(.type == "Progressing") | .lastTransitionTime + "|" + (.message[0:($trunk|tonumber)] | sub("\n";" ";"g")) elif (.[]|select(.type == "Available") | (.message != null) and (.status == "True")) then .[]|select(.type == "Available") | .lastTransitionTime + "|" + (.message[0:($trunk|tonumber)] | sub("\n";" ";"g")) else " | " end)") else "Unknown| |Unknown| |Unknown| | " end)|")' 2>${STD_ERR} | ${GAWK_PATH} -F'|' -v daysbefore=${TRANSITION_DAYS} '{printf "%s|%s|",$1,$2; if(($3 == "AVAILABLE")||($3 == "status")){printf "%s|",$3} else if($3 == "True"){printf "G%s|",$3}else{printf "R%s|",$3};if(($4 == "lastTransitionTime")||($4==" ")){printf "%s|",$4}else{time=gensub(/[-:TZ]/," ","g",$4);epoch_fmt=mktime(time);if(epoch_fmt > daysbefore){printf "Y_%s|",$4}else{printf "%s|",$4}}; if(($5 == "PROGRESSING")||($5 == "status")){printf "%s|",$5} else if($5 == "True"){printf "Y%s|",$5}else{printf "G%s|",$5};if(($6 == "lastTransitionTime")||($6==" ")){printf "%s|",$6}else{time=gensub(/[-:TZ]/," ","g",$6);epoch_fmt=mktime(time);if(epoch_fmt > daysbefore){printf "Y_%s|",$6}else{printf "%s|",$6}}; if(($7 == "DEGRADED")||($7 == "status")){printf "%s|",$7} else if($7 == "True"){printf "R%s|",$7}else{printf "G%s|",$7}; if(($8 == "lastTransitionTime")||($8==" ")){printf "%s|",$8}else{time=gensub(/[-:TZ]/," ","g",$8);epoch_fmt=mktime(time);if(epoch_fmt > daysbefore){printf "Y_%s|",$8}else{printf "%s|",$8}};printf "%s|%s\n",$9,$10}' | column -t -s '|' | sed -e "s/G\([FT][a-z]*\)/${greentext}\1 ${resetcolor}/g" -e "s/Y\([FT][a-z]*\)/${yellowtext}\1 ${resetcolor}/g" -e "s/R\([FT][a-z]*\)/${redtext}\1 ${resetcolor}/g" -e "s/Y_\([0-9TZ:-]*\)/${yellowtext}\1  ${resetcolor}/g" -e "s/[RG]\(Unknown\)/${yellowtext}\1 ${resetcolor}/g"
    fi
  else
    fct_title "Unhealthy Cluster Operators"
    echo ${CO_JSON} | jq -r --arg trunk ${CONDITION_TRUNK} '"|NAME|VERSION|AVAILABLE|PROGRESSING|DEGRADED|LASTTRANSTION|MESSAGE",(.items[] | "|\(.metadata.name)|\(if(.status.versions != null) then (.status.versions[] | select(.name == "operator") | .version) else " " end)|\(if(.status.conditions != null) then ("\(.status.conditions[] | select(.type == "Available") | .status)|\(.status.conditions[] | select(.type == "Progressing") | .status)|\(.status.conditions[] | select(.type == "Degraded") | .status)|\(.status.conditions | if(.[]|select(.type == "Degraded") | (.message != null) and (.status == "True")) then .[]|select(.type == "Degraded") | .lastTransitionTime + "|" + (.message[0:($trunk|tonumber)] | sub("\n";" ";"g")) elif (.[]|select(.type == "Progressing") | (.message != null) and (.status == "True")) then .[]|select(.type == "Progressing") | .lastTransitionTime + "|" + (.message[0:($trunk|tonumber)] | sub("\n";" ";"g")) elif (.[]|select(.type == "Available") | (.message != null) and (.status == "True")) then .[]|select(.type == "Available") | .lastTransitionTime + "|" + (.message[0:($trunk|tonumber)] | sub("\n";" ";"g")) else " | " end)") else "Unknown|Unknown|Unknown| " end)|")' 2>${STD_ERR} | grep -v "True|False|False" | awk -F'|' '{printf "%s|%s|",$2,$3; if($4 == "AVAILABLE"){printf "%s|",$4} else if($4 == "True"){printf "G%s|",$4}else{printf "R%s|",$4}; if($5 == "PROGRESSING"){printf "%s|",$5} else if($5 == "True"){printf "Y%s|",$5}else{printf "G%s|",$5}; if($6 == "DEGRADED"){printf "%s|",$6} else if($6 == "True"){printf "R%s|",$6}else{printf "G%s|",$6}; printf "%s|%s\n",$7,$8}' | column -t -s '|' | sed -e "s/G\([FT][a-z]*\)/${greentext}\1 ${resetcolor}/g" -e "s/Y\([FT][a-z]*\)/${yellowtext}\1 ${resetcolor}/g" -e "s/R\([FT][a-z]*\)/${redtext}\1 ${resetcolor}/g" -e "s/[RG]\(Unknown\)/${yellowtext}\1 ${resetcolor}/g"
  fi
  CLUSTER_VERSION=${CLUSTER_VERSION:-$(${OC} get clusterversion.config.openshift.io version -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | jq -r .status.desired.version 2>${STD_ERR})}
  CO_MISS_VERSION_OUTPUT=${CO_MISS_VERSION_OUTPUT:-$(echo ${CO_JSON} | jq -r --arg ClusterVersion "${CLUSTER_VERSION:-"null"}" '.items[] | select((.metadata.ownerReferences != null) and (.metadata.ownerReferences[].kind == "ClusterVersion") and (if (.status.versions != null) then (.status.versions[] | select((.name == "operator") and (.version != $ClusterVersion))) else true end)) | "\(.metadata.name)|\(if(.status.versions != null) then .status.versions[] | select(.name == "operator") | .version else "Unknown" end)"')}
  if [[ ! -z "${CO_MISS_VERSION_OUTPUT}" ]]
  then
    fct_title "Not Updated Cluster Operators"
    echo -e "NAME|VERSION\n${CO_MISS_VERSION_OUTPUT}" | column -t -s'|' | sed -e "s/[0-9].[0-9]\{1,2\}.[0-9]\{1,2\}/${redtext}&${resetcolor}/" -e "s/^[a-z\-]*/${purpletext}&${resetcolor}/" -e "s/\(Unknown\)/${yellowtext}\1${resetcolor}/g"
  fi
  CO_NOT_UPGRADEABLE=$(echo ${CO_JSON} | jq -r --arg trunk ${CONDITION_TRUNK} '.items[] | if (.status.conditions == null) then "\(.metadata.name)|Unknown|||" else (if ((.status.conditions[] | select(.type == "Upgradeable")| .status) != "True") then "\(.metadata.name)|\(.status.conditions[] | select(.type == "Upgradeable")|"\(.status)|\(if (.reason != null) then .reason else "" end)|\(if (.message != null) then .message[0:($trunk|tonumber)] | sub("\n";" ";"g") else "" end)")" else "" end) end' | column -t)
  if [[ ! -z "${CO_NOT_UPGRADEABLE}" ]]
  then
    fct_title "Not Upgradeable Cluster Operators"
    echo -e "NAME|UPGRADEABLE|REASON|MESSAGE\n${CO_NOT_UPGRADEABLE}" | sed -e "s/  */ /g" | column -t -s'|' | sed -e "s/^[a-z\-]*/${purpletext}&${resetcolor}/" -e "s/\(False\)/${yellowtext}\1${resetcolor}/g" -e "s/\(Unknown\)/${yellowtext}\1${resetcolor}/g"
  fi
  UNHEALTHY_OPERATORS=${UNHEALTHY_OPERATORS:-$(echo ${CO_JSON} | jq -r '.items[] | select((.status.conditions == null) or (.status.conditions[] | ((.type == "Available") and (.status == "False")) or ((.type == "Progressing") and (.status == "True")) or ((.type == "Degraded") and (.status == "True")))) | .metadata.name' 2>${STD_ERR} | sort -u)}
  if [[ ! -z ${DETAILS} ]] && [[ ! -z ${UNHEALTHY_OPERATORS} ]]
  then
    fct_title_details "Unhealthy Cluster Operators - Details"
    for OPERATOR in ${UNHEALTHY_OPERATORS}
    do
      echo ${CO_JSON} | jq -r --arg Operator ${OPERATOR} '.items[] | select(.metadata.name == $Operator) | "##### " + .metadata.name + " #####",(if (.status.conditions != null) then {status: {conditions: [(.status.conditions[] | select((.type == "Available") or (.type == "Progressing") or (.type == "Degraded")))]}} else {status: {conditions: null}} end)'
    done
  fi
  fct_title "CSV"
  echo -e "Name | Display Name | Provider | Version | Phase\n$(${OC} get clusterserviceversion.operators.coreos.com -A -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | jq -r '(.items | sort_by(.metadata.name) | .[] | "\(.metadata.name) | \(.spec.displayName) | \(if (.spec.provider.name != null) then .spec.provider.name else "N/A" end) | \(.spec.version) | \(.status.phase)")' 2>${STD_ERR} | sort -u)" | column -t -s"|" | sed -e "s/Succeeded$/${greentext}&${resetcolor}/g" -e "s/Installing$/${yellowtext}&${resetcolor}/g" -e "s/Replacing$/${yellowtext}&${resetcolor}/g" -e "s/Failed$/${redtext}&${resetcolor}/g"
  fct_title "Subscriptions"
  ${OC} get subscription -A -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | jq -r '"NAME|CHANNEL|APPROVAL|SOURCE|SOURCENAMESPACE|STATE",(.items[] | "\(.metadata.name)|\(.spec | "\(.channel)|\(.installPlanApproval)|\(.source)|\(.sourceNamespace)")|\(.status.state)")' | column -ts'|' | sed -e "s/AtLatestKnown$/${greentext}&${resetcolor}/g" -e "s/UpgradePending$/${yellowtext}&${resetcolor}/g" -e "s/Manual/${yellowtext}&${resetcolor}/g"
fi

########### MCO ###########
if [[ ! -z ${MCO} ]] || [[ ! -z ${ALL} ]]
then
  fct_header "MACHINE CONFIG OPERATOR STATUS"
  fct_title "MCP status"
  ${OC} get machineconfigpool.machineconfiguration.openshift.io 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | awk '{printf "%s|%s|",$1,$2; if($3 == "UPDATED"){printf "%s|",$3} else if($3 == "True"){printf "G%s|",$3}else{printf "R%s|",$3}; if($4 == "UPDATING"){printf "%s|",$4} else if($4 == "True"){printf "Y%s|",$4}else{printf "G%s|",$4}; if($5 == "DEGRADED"){printf "%s|",$5} else if($5 == "True"){printf "R%s|",$5}else{printf "G%s|",$5}; printf "%s|",$6; if($7 == "READYMACHINECOUNT"){printf "%s|",$7} else if($7 != $6){printf "R%s|",$7}else{printf "G%s|",$7}; if($8 == "UPDATEDMACHINECOUNT"){printf "%s|",$8} else if($8 != $6){printf "Y%s|",$8}else{printf "G%s|",$8}; if($9 == "DEGRADEDMACHINECOUNT"){printf "%s|",$9} else if($9 != 0){printf "Y%s|",$9}else{printf "G%s|",$9}; printf "%s \n",$10}' | column -t -s '|' | sed -e "s/G\([FT]*[a-z0-9]\{1,5\}\\)/${greentext}\1 ${resetcolor}/g" -e "s/Y\([FT]*[0-9a-z]\{1,5\}\\)/${yellowtext}\1 ${resetcolor}/g" -e "s/R\([FT]*[0-9a-z]\{1,5\}\\)/${redtext}\1 ${resetcolor}/g" -e "s/master/${cyantext}&${resetcolor}/" -e "s/worker/${purpletext}&${resetcolor}/" -e "s/infra/${yellowtext}&${resetcolor}/"
  MCP_NODE_DEGRADED=${MCP_NODE_DEGRADED:-$(${OC} get machineconfigpool.machineconfiguration.openshift.io -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | jq -r --arg trunk ${CONDITION_TRUNK} '.items[] | select(.status.conditions[] | (.type == "NodeDegraded" and .status == "True")) | "\(.metadata.name)|\(.status.conditions[] | select(.type == "NodeDegraded") | .lastTransitionTime)|R-\(.status.conditions[] | select(.type == "NodeDegraded") | .reason)-R|Y-\(.status.conditions[] | select(.type == "NodeDegraded") | .message[0:($trunk|tonumber)] | sub("\n";" ";"g"))-Y"')}
  NODE_JSON=${NODE_JSON:-$(${OC} get nodes -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")}
  MCP_JSON=$(${OC} get machineconfigpool.machineconfiguration.openshift.io -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")
  if [[ ! -z "${MCP_NODE_DEGRADED}" ]] && [[ ! -z ${DETAILS} ]]
  then
    fct_title_details "Degraded nodes per MCP - details"
    echo -e "MCP Name|lastTransitionTime|reason|message\n${MCP_NODE_DEGRADED}" | column -t -s'|' | sed -e "s/R-\([0-9a-z \.\-]*\)-R/${redtext}\1    ${resetcolor}/" -e "s/Y-\(.*\)-Y$/${yellowtext}\1 ${resetcolor}/" -e "s/master/${cyantext}&${resetcolor}/" -e "s/worker/${purpletext}&${resetcolor}/" -e "s/infra/${yellowtext}&${resetcolor}/"
  fi
  NODE_COUNT=$(${OC} get nodes 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}|^NAME" | wc -l | awk '{print $1}')
  NODE_MCP=$(echo ${MCP_JSON} | jq -r '[.items[] | .status.machineCount | tonumber] | add')
  if [[ ! -z ${NODE_MCP} ]] && [[ ${NODE_COUNT} != ${NODE_MCP} ]]
  then
    fct_title_details "Incorrect MCP Nodes count"
    echo -e "Number of Nodes:|${NODE_COUNT}\nNumber of Nodes associate to MCP:|${redtext}${NODE_MCP}${resetcolor}" | column -ts '|'
  fi
  PROCESSING_MCP=${PROCESSING_MCP:-$(echo ${MCP_JSON} | jq -r '.items[] | select(.status.conditions[] | (.type == "Updated" and .status == "False")) | .metadata.name')}
  if [[ ! -z "${PROCESSING_MCP}" ]] && [[ ! -z ${DETAILS} ]]
  then
    fct_title_details "Processing MCP - machine-config-controller log"
    ${OC} logs -n openshift-machine-config-operator $(${OC} get pod -n openshift-machine-config-operator -l k8s-app=machine-config-controller -o name 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}") -c machine-config-controller | grep -Ev "template_controller.go" | tail -${TAIL_LOG} | sed -e "s/master/${cyantext}&${resetcolor}/g" -e "s/worker/${purpletext}&${resetcolor}/g" -e "s/infra/${yellowtext}&${resetcolor}/g"
  fi
  fct_title "Latest MachineConfigs"
  MC_JSON=$(${OC} get machineconfig.machineconfiguration.openshift.io -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")
  echo ${MC_JSON} | jq -r '.items| sort_by(.metadata.creationTimestamp,.metadata.name) | .[] | "\(.metadata.creationTimestamp) - \(.metadata.name)"' | tail -10 | sed -e "s/master/${cyantext}&${resetcolor}/g" -e "s/worker/${purpletext}&${resetcolor}/g" -e "s/infra/${yellowtext}&${resetcolor}/g"
  if [[ ! -z ${DETAILS} ]]
  then
    MC_JSON_conflicts=$(echo ${MC_JSON} | jq -r '.items[] | select((.spec.osImageURL != null) and (.spec.osImageURL != "")) | {name: .metadata.name, osImageURL: .spec.osImageURL}')
    fct_title "osImageURL conflicts"
    for mcp in $(echo ${MCP_JSON} | jq -r '.items[].metadata.name'); do
      printf "Checking MCP ${mcp}:|"
      for mc in $(echo ${MCP_JSON} | jq -r --arg mcp ${mcp} '.items[] | select(.metadata.name == $mcp) | .status.configuration.source[].name'); do
        echo ${MC_JSON_conflicts} | jq -r --arg mc ${mc} 'select(.name == $mc) | {name: .name, osImageURL: .osImageURL} '
      done | jq -rs 'group_by(.osImageURL) | if length > 1 then "conflicts detected", . else "all osImageURLs match|(\(.[0] | .[0].osImageURL))" end' | sed -e "s/.*/${yellowtext}&${resetcolor}/" -e "s/conflicts detected/${redtext}&${resetcolor}/" -e "s/all osImageURLs match/${greentext}&${resetcolor}/"
      echo "-------------------"
    done | column -ts'|'
  fi
  fct_title "MCP state & versions"
  ${OC} get machineconfigpool.machineconfiguration.openshift.io -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | jq -r '"MCP Name | Current Rendered | Desired Rendered | Paused | unavailableMachineCount | maxUnavailable",(.items[] | "\(.metadata.name) | \(if (.spec.configuration.name != .status.configuration.name) then "R_\(.status.configuration.name)" else "G_\(.status.configuration.name)" end) | \(.spec.configuration.name) | \(if (.spec.paused != null) then (if(.spec.paused == true) then "Y_\(.spec.paused)" else "G_\(.spec.paused)" end) else "G_false" end) | \(if (.spec.maxUnavailable != null) then "\(if(.status.unavailableMachineCount >= .spec.maxUnavailable) then "R_\(.status.unavailableMachineCount)" else "G_\(.status.unavailableMachineCount)" end) | \(.spec.maxUnavailable)" else "\(if(.status.unavailableMachineCount >= 1) then "R_\(.status.unavailableMachineCount)" else "G_\(.status.unavailableMachineCount)" end) | 1" end )")' | column -t -s'|' | sed -e "s/ [1-9]\{1,5\}[0-9][%]*$/${yellowtext}&${resetcolor}/" -e "s/ true /${redtext}&${resetcolor}/" -e "s/master/${cyantext}&${resetcolor}/" -e "s/worker/${purpletext}&${resetcolor}/" -e "s/infra/${yellowtext}&${resetcolor}/" -e "s/R_\([0-9a-z\-]*\)/${redtext}\1  ${resetcolor}/g" -e "s/G_\([0-9a-z\-]*\)/${greentext}\1  ${resetcolor}/g" -e "s/Y_\([0-9a-z\-]*\)/${yellowtext}\1  ${resetcolor}/g"
  fct_title "MCO by node"
  echo "${NODE_JSON}" | jq -r '"Node Name | Current MC | Desired MC | MC State",(.items| sort_by(.metadata.name,.metadata.annotations."machineconfiguration.openshift.io/desiredConfig",.metadata.annotations."machineconfiguration.openshift.io/currentConfig") | .[]  | "\(if (.metadata.annotations."machineconfiguration.openshift.io/currentConfig" == .metadata.annotations."machineconfiguration.openshift.io/desiredConfig") then .metadata.name else "RED"+.metadata.name end) | \(if (.metadata.annotations."machineconfiguration.openshift.io/currentConfig" == .metadata.annotations."machineconfiguration.openshift.io/desiredConfig") then "GREEN" + .metadata.annotations."machineconfiguration.openshift.io/currentConfig" else "RED" + .metadata.annotations."machineconfiguration.openshift.io/currentConfig" end) | \(.metadata.annotations."machineconfiguration.openshift.io/desiredConfig") | \(.metadata.annotations."machineconfiguration.openshift.io/state")")' | column -t -s'|' | sed -e "s/ Degraded$/${redtext}&${resetcolor}/" -e "s/ Done$/${greentext}&${resetcolor}/" -e "s/RED\([0-9a-z\.\-]*\)/${redtext}\1   ${resetcolor}/g" -e "s/GREEN\([0-9a-z\.\-]*\)/${greentext}\1     ${resetcolor}/g"
  DEGRADED_NODES=${DEGRADED_NODES:-$(echo "${NODE_JSON}"  | jq -r '.items | sort_by(.metadata.name) | .[] | select((.metadata.annotations."machineconfiguration.openshift.io/state" == "Degraded") or (.metadata.annotations."machineconfiguration.openshift.io/state" == "Working")) | .metadata.name')}
  if [[ ! -z "${DEGRADED_NODES}" ]] && [[ ! -z ${DETAILS} ]]
  then
    fct_title "Degraded nodes - machine-config-daemon log"
    MCO_PODS=${MCO_PODS:-$(${OC} get pod -n openshift-machine-config-operator -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")}
    for DEGRADED_NODE in ${DEGRADED_NODES}
    do
      pod_name=$(echo "${MCO_PODS}" | jq -r --arg degraded_node ${DEGRADED_NODE} '.items[] | select((.spec.nodeName == $degraded_node) and (.metadata.labels."k8s-app" == "machine-config-daemon")) | .metadata.name')
      if [[ ! -z ${pod_name} ]]
      then
        fct_title_details "${DEGRADED_NODE} - ${pod_name} log (last ${TAIL_LOG} lines)"
        ${OC} logs -n openshift-machine-config-operator ${pod_name} -c machine-config-daemon | tail -${TAIL_LOG}
      fi
    done
  fi
fi

########### EVENTS ###########
if [[ ! -z ${EVENTS} ]] || [[ ! -z ${ALL} ]]
then
  fct_header "DEFAULT EVENTS"
  fct_title "Events in default namespace"
  ${OC} get events -n default -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | jq -r '"creationTimestamp | Name | Reason | Host | Component | Message",(.items | sort_by(.metadata.creationTimestamp) | .[] | "\(.metadata.creationTimestamp) | \(.metadata.name) | \(.reason) | \(.source.host) | \(.source.component) | \(.message | sub("\n";" ";"g"))")' | column -t -s'|'
fi
########### SCC ###########
if [[ ! -z ${SCC} ]] || [[ ! -z ${ALL} ]]
then
  fct_header "SCC STATUS"
  ALL_SCC_JSON=${ALL_SCC_JSON:-$(${OC} get securitycontextconstraints.security.openshift.io -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | jq -r '. | del(.items[].metadata.annotations)')}
  GAWK_PATH=${GAWK_PATH:-$(which gawk 2>${STD_ERR})}
  TRANSITION_DAYS=$[${Current_time} - (${NODE_TRANSITION_DAYS} * 24 * 3600)]
  if [[ -z ${DETAILS} ]]
  then
    fct_title "SCC - overview (Array values truncated)"
    if [[ -z ${GAWK_PATH} ]]
    then
        echo "${ALL_SCC_JSON}" | jq -r '" | | |allowPrivilege| |User & Groups| | | |\nPrioriy|Name|creationTimestamp|Escalation|Container|runAsUser|Users|supplementalGroups|Groups",(.items | sort_by(-(if .priority == null then 0 else .priority end),.metadata.name) |.[] | "\(if (.priority == null) then .priority elif (.priority > 10) then "R_\(.priority)" else "Y_\(.priority)" end)|\(if ((.priority != null) and (.metadata.name != "anyuid")) then "Y_\(.metadata.name)" else "G_\(.metadata.name)" end)|\(.metadata.creationTimestamp)|\(.allowPrivilegeEscalation)|\(.allowPrivilegedContainer)|\(.runAsUser.type)|\(.users[0:1])|\(.supplementalGroups.type)|\(.groups[0:1])")' | column -t -s'|' | sed -e "s/R_\([-a-z0-9]*\)/${redtext}\1  ${resetcolor}/g" -e "s/Y_\([-a-z0-9]*\)/${yellowtext}\1  ${resetcolor}/g" -e "s/G_\([-a-z0-9]*\)/${greentext}\1  ${resetcolor}/g" -e "s/\(${THIS_month}[-:T0-9]*Z\)/${yellowtext}\1${resetcolor}/" -e "s/\(${LAST_28days}[-:T0-9]*Z\)/${yellowtext}\1${resetcolor}/"
    else
        echo "${ALL_SCC_JSON}" | jq -r '" | | |allowPrivilege| |User & Groups| | | |\nPrioriy|Name|creationTimestamp|Escalation|Container|runAsUser|Users|supplementalGroups|Groups",(.items | sort_by(-(if .priority == null then 0 else .priority end),.metadata.name) |.[] | "\(if (.priority == null) then .priority elif (.priority > 10) then "R_\(.priority)" else "Y_\(.priority)" end)|\(if ((.priority != null) and (.metadata.name != "anyuid")) then "Y_\(.metadata.name)" else "G_\(.metadata.name)" end)|\(.metadata.creationTimestamp)|\(.allowPrivilegeEscalation)|\(.allowPrivilegedContainer)|\(.runAsUser.type)|\(.users[0:1])|\(.supplementalGroups.type)|\(.groups[0:1])")' | ${GAWK_PATH} -F'|' -v daysbefore=${TRANSITION_DAYS} '{printf "%s|%s|",$1,$2; if($3 != "creationTimestamp"){time=gensub(/[-:TZ]/," ","g",$3);epoch_fmt=mktime(time);if(epoch_fmt > daysbefore){printf "Y_"$3}else{printf "G_"$3}}else{printf $3};printf "|%s|%s|%s|%s|%s|%s\n",$4,$5,$6,$7,$8,$9}' | column -t -s'|' | sed -e "s/R_\([-a-z0-9:A-Z]*\)/${redtext}\1  ${resetcolor}/g" -e "s/Y_\([-a-z0-9:A-Z]*\)/${yellowtext}\1  ${resetcolor}/g" -e "s/G_\([-a-z0-9:A-Z]*\)/${greentext}\1  ${resetcolor}/g"
    fi
  else
    fct_title "SCC - overview (full)"
    if [[ -z ${GAWK_PATH} ]]
    then
      echo "${ALL_SCC_JSON}" | jq -r '" | | |allowPrivilege| |User & Groups| | | |\nPrioriy|Name|creationTimestamp|Escalation|Container|runAsUser|Users|supplementalGroups|Groups",(.items | sort_by(-(if .priority == null then 0 else .priority end),.metadata.name) |.[] | "\(if (.priority == null) then .priority elif (.priority > 10) then "R_\(.priority)" else "Y_\(.priority)" end)|\(if ((.priority != null) and (.metadata.name != "anyuid")) then "Y_\(.metadata.name)" else "G_\(.metadata.name)" end)|\(.metadata.creationTimestamp)|\(.allowPrivilegeEscalation)|\(.allowPrivilegedContainer)|\(.runAsUser.type)|\(.users)|\(.supplementalGroups.type)|\(.groups)")' | column -t -s'|' | sed -e "s/R_\([-a-z0-9]*\)/${redtext}\1  ${resetcolor}/g" -e "s/Y_\([-a-z0-9]*\)/${yellowtext}\1  ${resetcolor}/g" -e "s/G_\([-a-z0-9]*\)/${greentext}\1  ${resetcolor}/g" -e "s/\(${THIS_month}[-:T0-9]*Z\)/${yellowtext}\1${resetcolor}/" -e "s/\(${LAST_28days}[-:T0-9]*Z\)/${yellowtext}\1${resetcolor}/"
    else
      echo "${ALL_SCC_JSON}" | jq -r '" | | |allowPrivilege| |User & Groups| | | |\nPrioriy|Name|creationTimestamp|Escalation|Container|runAsUser|Users|supplementalGroups|Groups",(.items | sort_by(-(if .priority == null then 0 else .priority end),.metadata.name) |.[] | "\(if (.priority == null) then .priority elif (.priority > 10) then "R_\(.priority)" else "Y_\(.priority)" end)|\(if ((.priority != null) and (.metadata.name != "anyuid")) then "Y_\(.metadata.name)" else "G_\(.metadata.name)" end)|\(.metadata.creationTimestamp)|\(.allowPrivilegeEscalation)|\(.allowPrivilegedContainer)|\(.runAsUser.type)|\(.users)|\(.supplementalGroups.type)|\(.groups)")' | ${GAWK_PATH} -F'|' -v daysbefore=${TRANSITION_DAYS} '{printf "%s|%s|",$1,$2; if($3 != "creationTimestamp"){time=gensub(/[-:TZ]/," ","g",$3);epoch_fmt=mktime(time);if(epoch_fmt > daysbefore){printf "Y_"$3}else{printf "G_"$3}}else{printf $3};printf "|%s|%s|%s|%s|%s|%s\n",$4,$5,$6,$7,$8,$9}' | column -t -s'|' | sed -e "s/R_\([-a-z0-9:A-Z]*\)/${redtext}\1  ${resetcolor}/g" -e "s/Y_\([-a-z0-9:A-Z]*\)/${yellowtext}\1  ${resetcolor}/g" -e "s/G_\([-a-z0-9:A-Z]*\)/${greentext}\1  ${resetcolor}/g"
    fi
    fct_title "SCC - additional Details"
    echo "${ALL_SCC_JSON}" | jq -r '" | |AllowHost| | | | |Allow| |Restrictions| |SeLinux & Volumes| | | |\nPrioriy|Name|DirVolumePlugin|IPC|Network|PID|Ports|Capabilities|UnsafeSysctls|readOnlyRootFS|requiredDropCAPS|seLinuxContext|seccompProfiles|fsGroup|volumes",(.items | sort_by(-(if .priority == null then 0 else .priority end),.metadata.name) |.[] | "\(if (.priority == null) then .priority elif (.priority > 10) then "R_\(.priority)" else "Y_\(.priority)" end)|\(if ((.priority != null) and (.metadata.name != "anyuid")) then "Y_\(.metadata.name)" else "G_\(.metadata.name)" end)|\(.allowHostDirVolumePlugin)|\(.allowHostIPC)|\(.allowHostNetwork)|\(.allowHostPID)|\(.allowHostPorts)|\(.allowedCapabilities)|\(.allowedUnsafeSysctls)|\(.readOnlyRootFilesystem)|\(.requiredDropCapabilities)|\(.seLinuxContext.type)|\(.seccompProfiles)|\(.fsGroup.type)|\(.volumes)")' | column -t -s'|' | sed -e "s/R_\([-a-z0-9]*\)/${redtext}\1  ${resetcolor}/g" -e "s/Y_\([-a-z0-9]*\)/${yellowtext}\1  ${resetcolor}/g" -e "s/G_\([-a-z0-9]*\)/${greentext}\1  ${resetcolor}/g"

    if [[ ! -z ${GAWK_PATH} ]]
    then
      HIGH_POLICIES=$(echo "${ALL_SCC_JSON}" | jq -r '.items | sort_by(-(if .priority == null then 0 else .priority end),.metadata.name) |.[] | select((.priority != null) and (.priority != 0) and (.metadata.name != "anyuid")) | .metadata.name')
      NEW_POLICIES=$(echo "${ALL_SCC_JSON}" | jq -r '.items[] | "\(.metadata.name)|\(.metadata.creationTimestamp)"' | ${GAWK_PATH} -F'|' -v daysbefore=${TRANSITION_DAYS} '{time=gensub(/[-:TZ]/," ","g",$2);epoch_fmt=mktime(time);if(epoch_fmt > daysbefore){print $1}}')
      POLICIES=$(echo -e "${HIGH_POLICIES}\n${NEW_POLICIES}" | sort -u)
      if [[ ! -z ${POLICIES} ]]
      then
        fct_title "SCC - PODs running in SCCs newer than ${NODE_TRANSITION_DAYS} days or with high priority (>=10)"
        if [[ -z ${NAMESPACE} ]]
        then
          ALL_PODS_JSON=${ALL_PODS_JSON:-$(${OC} get pod -A -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")}
        else
          ALL_PODS_JSON=$(${OC} get pod -n ${NAMESPACE} -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")
        fi
        for POLICY in ${POLICIES}
        do
          echo "${ALL_PODS_JSON}" | jq -r --arg policy ${POLICY} '.items[] | select((.metadata.annotations."openshift.io/scc" == $policy) and  (.status.phase == "Running")) | .metadata | "\(.namespace)|\(if (.namespace | test("openshift-")) then "R_\(.name)" else .name end)|Y_\(.annotations."openshift.io/scc")|\(.creationTimestamp)"'
        done | ${GAWK_PATH} -F'|' -v daysbefore=${TRANSITION_DAYS} '{printf "%s|%s|%s|",$1,$2,$3; time=gensub(/[-:TZ]/," ","g",$4);epoch_fmt=mktime(time);if(epoch_fmt > daysbefore){print "Y_"$4}else{print "G_"$4}}' | column -t -s'|' | sed -e "s/R_\([-a-z0-9.A-Z:]*\)/${redtext}\1  ${resetcolor}/g" -e "s/Y_\([-a-z0-9.A-Z:]*\)/${yellowtext}\1  ${resetcolor}/g" -e "s/G_\([-a-z0-9.A-Z:]*\)/${greentext}\1  ${resetcolor}/g"
      fi
    fi
    if [[ ! -z ${NAMESPACE} ]]
    then
      fct_title "SCC - ${NAMESPACE} PODs' SCC & Security Context"
      echo "${ALL_PODS_JSON}" | jq -r --arg namespace ${NAMESPACE} '"namespace|name|phase|openshift.io/scc|fsGroup|fsGroupChangePolicy|runAsGroup|runAsNonRoot|runAsUser|seLinuxOptions|seccompProfile|supplementalGroups|sysctls",(.items | sort_by(.metadata.namespace,.metadata.name) | .[] | select(.metadata.namespace == $namespace)| "\(.metadata.namespace)|\(.metadata.name)|\(.status.phase)|\(.metadata.annotations."openshift.io/scc")|\(.spec.securityContext|"\(.fsGroup)|\(.fsGroupChangePolicy)|\(.runAsGroup)|\(.runAsNonRoot)|\(.runAsUser)|\(.seLinuxOptions)|\(.seccompProfile)|\(.supplementalGroups)|\(.sysctls)")")' | column -ts'|'
    fi
  fi
fi
########### PODS ###########
if [[ ! -z ${PODS} ]] || [[ ! -z ${ALL} ]]
then
  if [[ -z ${NAMESPACE} ]]
  then
    fct_header "POD STATUS"
  else
    fct_header "POD STATUS in Namespace ${NAMESPACE}"
  fi
  if [[ -z ${NAMESPACE=} ]]
  then
    ALL_PODS=${ALL_PODS:-$(${OC} get pod -A ${WIDE_OPTION} 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")}
  else
    ALL_PODS=$(${OC} get pods -n ${NAMESPACE} ${WIDE_OPTION} 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")
  fi
  if [[ ! -z ${DETAILS} ]]
  then
    if [[ -z ${NAMESPACE=} ]]
    then
      ALL_PODS_JSON=${ALL_PODS_JSON:-$(${OC} get pod -A -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")}
    else
      ALL_PODS_JSON=$(${OC} get pod -n ${NAMESPACE} -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")
    fi
  fi

  fct_title "PodDisruptionBudget"
  if [[ -z ${NAMESPACE} ]]
  then
    PDB_JSON=$(${OC} get PodDisruptionBudget.policy -A -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")
  else
    PDB_JSON=$(${OC} get PodDisruptionBudget.policy -n ${NAMESPACE} -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")
  fi
  echo ${PDB_JSON} | jq -r '"Namespace|Name|minAvailable|maxUnavailable|expectedPods|desiredHealthy|currentHealthy|disruptionsAllowed|disruptedPods|selector",(.items | sort_by(.metadata.namespace,.metadata.name) | .[] | "\(.metadata | "\(.namespace)|\(.name)")|\(.spec|"\(.minAvailable)|\(.maxUnavailable)")|\(.status|"\(.expectedPods)|\(.desiredHealthy)|\(if (.currentHealthy < .desiredHealthy) then "R_\(.currentHealthy)" elif (.currentHealthy < .expectedPods) then "Y_\(.currentHealthy)" else "G_\(.currentHealthy)" end)|\(if .disruptionsAllowed == 0 then "Y_\(.disruptionsAllowed)" else "G_\(.disruptionsAllowed)" end)|\(if .disruptedPods != null then "R_\(.disruptedPods)" else "G_\(.disruptedPods)" end)")|\(.spec.selector)")' | column -t -s'|' | sed -e "s/R_\([a-z0-9]*\)/${redtext}\1  ${resetcolor}/g" -e "s/Y_\([a-z0-9]*\)/${yellowtext}\1  ${resetcolor}/g" -e "s/G_\([a-z0-9]*\)/${greentext}\1  ${resetcolor}/g"

  fct_title "Unsuccessful PODs"
  echo "${ALL_PODS}" | grep -Ev "Running|Completed|Succeeded" | sed -e "s/Terminating/${yellowtext}&${resetcolor}/" -e "s/Pending/${yellowtext}&${resetcolor}/" -e "s/ContainerCreating/${yellowtext}&${resetcolor}/" -e "s/Init:0\/1/${yellowtext}&${resetcolor}/" -e "s/ImagePullBackOff/${yellowtext}&${resetcolor}/" -e "s/Evicted/${yellowtext}&${resetcolor}/" -e "s/PodInitializing/${yellowtext}&${resetcolor}/" -e "s/ErrImagePull/${yellowtext}&${resetcolor}/" -e "s/ Error/${redtext}&${resetcolor}/" -e "s/CrashLoopBackOff/${redtext}&${resetcolor}/" -e "s/OOMKilled/${redtext}&${resetcolor}/" -e "s/Failed/${redtext}&${resetcolor}/" -e "s/CreateContainerError/${redtext}&${resetcolor}/" -e "s/CreateContainerConfigError/${redtext}&${resetcolor}/" -e "s/RunContainerError/${redtext}&${resetcolor}/" -e "s/ContainerStatusUnknown/${redtext}&${resetcolor}/"
  if [[ ! -z ${DETAILS} ]]
  then
    fct_unsuccessful_pod_details
  fi
  fct_title "Unsuccessful Containers in PODs"
  if [[ ! -z ${DETAILS} ]]
  then
    fct_unsuccessful_container_details
  else
    if [[ -z ${NAMESPACE=} ]]
    then
      echo "${ALL_PODS}" | grep -Ev "Completed|Succeeded" | awk -F '[ /]*' '{if($3 != $4){print}}' | sed -e "s/ [0-9]*\/[0-9]* /${yellowtext}&${resetcolor}/"
    else
      echo "${ALL_PODS}" | grep -Ev "Completed|Succeeded" | awk -F '[ /]*' '{if($2 != $3){print}}' | sed -e "s/ [0-9]*\/[0-9]* /${yellowtext}&${resetcolor}/"
    fi
  fi
  fct_title "High number POD restart (>${MIN_RESTART})"
  if [[ ! -z ${DETAILS} ]]
  then
    fct_restart_container_details
  else
    if [[ -z ${NAMESPACE=} ]]
    then
      echo "${ALL_PODS}" | awk -v min_restart=${MIN_RESTART} '($5 > min_restart)' | sed -e "s/ [0-9]\{1,2\} /${yellowtext}&${resetcolor}/" -e "s/ [0-9]\{3,5\} /${redtext}&${resetcolor}/"
    else
      echo "${ALL_PODS}" | awk -v min_restart=${MIN_RESTART} '($4 > min_restart)' | sed -e "s/ [0-9]\{1,2\} /${yellowtext}&${resetcolor}/" -e "s/ [0-9]\{3,5\} /${redtext}&${resetcolor}/"
    fi
  fi
fi

########### STATICPOD ###########
if [[ ! -z ${STATICPOD} ]] || [[ ! -z ${ALL} ]]
then
  fct_header "STATIC PODs"
  fct_title "Revision Status"
  for static in etcd kubeapiserver kubecontrollermanager kubescheduler
  do
    static_revision=$(${OC} get ${static}.operator.openshift.io cluster -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | jq -r '.status.conditions[] | select(((.type == "NodeInstallerProgressing") or (.type == "APIServerDeploymentProgressing")) and (.message != null)) | ": \(.message | sub("\n";" ";"g"))"' | sed -e "s/[0-9] nodes are at revision [0-9]\{1,3\}/${greentext}&${resetcolor}/" -e "s/; \([0-9] nodes are at revision [0-9]\{1,3\}\)/; ${yellowtext}\1${resetcolor}/" -e "s/; \(0 nodes have achieved new revision [0-9]\{1,3\}\)/; ${redtext}\1${resetcolor}/")
    if [[ ! -z ${static_revision} ]]
    then
      printf "${static}|${static_revision}\n"
    fi
  done | column -t -s'|'
  if [[ ! -z ${DETAILS} ]]
  then
    fct_title "Revision details - ConfigMap & installer"
    for namespace in openshift-etcd openshift-kube-apiserver openshift-kube-controller-manager openshift-kube-scheduler
    do
      fct_title_details "${namespace}"
      echo "--- Config Maps ---"
      ${OC} get configmap -n ${namespace} -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | jq -r '.items | sort_by(.metadata.creationTimestamp) | .[] | select(.metadata.name | test("revision-status")) | "\(.metadata.creationTimestamp) | \(.metadata.name) | \(.data.status) | \(.data.reason)"' | column -s '|' -t | tail -5
      echo "--- Installer Pods (up to 10) ---"
      ALL_PODS_JSON=${ALL_PODS_JSON:-$(${OC} get pod -A -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")}
      INSTALLER_DETAILS=$(echo "${ALL_PODS_JSON}" | jq -r --arg namespace ${namespace} '.items | sort_by(.metadata.creationTimestamp,.metadata.name) | .[] | select((.metadata.namespace == $namespace) and (.metadata.labels.app == "installer")) | "\(.metadata.name)|\(.status.containerStatuses[0]|"\(.name)|\(.restartCount)|\(.state | .[] |  "\(.startedAt)|\(.finishedAt)|\(.reason)")")"'| tail -10)
      if [[ -z ${INSTALLER_DETAILS} ]]
      then
        echo "No resources pods.core found in ${namespace} namespace."
      else
        echo -e "POD Name|Container Name|restartCount|startedAt|finishedAt|reason\n${INSTALLER_DETAILS}" | column -t -s'|' | sed -e "s/Completed$/${greentext}&${resetcolor}/" -e "s/Error$/${redtext}&${resetcolor}/"
      fi
      echo
    done
    ETCD_ENCRYPTION=$(${OC} get apiserver cluster -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}"| jq -r .spec.encryption)
    if [[ ${ETCD_ENCRYPTION} != "null" ]]
    then
      fct_title "ETCD Encryption"
      echo "${ETCD_ENCRYPTION}"
    fi
  fi
fi

########### ETCD ###########
if [[ ! -z ${ETCD} ]] || [[ ! -z ${ALL} ]]
then
  fct_header "ETCD STATUS"
  fct_title "ETCD Health"
  if [[ "${OC}" == "omg" ]] || [[ "${OC}" == "omc" ]]
  then
    ${OC} etcd health 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | sed -e "s/ [2-9][0-9].*ms /${yellowtext}&${resetcolor}/" -e "s/ [1-9][0-9]\{2,9\}.*ms /${redtext}&${resetcolor}/" -e "s/ false /${redtext}&${resetcolor}/" -e "s/ true /${greentext}&${resetcolor}/"
    fct_title "ETCD status (automatic defrag threshold 45%)"
    ${OC} etcd status 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | sed -e "s/ [3-9][0-9]% /${yellowtext}&${resetcolor}/" -e "s/ true /${greentext}&${resetcolor}/"
  else
    # Display ETCD status when running the script against a cluster using 'oc' command
    ${OC} rsh -n openshift-etcd -c etcdctl $(${OC} get pod -n openshift-etcd -l k8s-app=etcd 2>${STD_ERR} | grep "Running" | awk '{print $1}' | head -1) etcdctl endpoint health -w table 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | sed -e "s/ [2-9][0-9].*ms /${yellowtext}&${resetcolor}/" -e "s/ [1-9][0-9]\{2,9\}.*ms /${redtext}&${resetcolor}/" -e "s/ false /${redtext}&${resetcolor}/" -e "s/ true /${greentext}&${resetcolor}/"
    fct_title "ETCD status"
    ${OC} rsh -n openshift-etcd -c etcdctl $(${OC} get pod -n openshift-etcd -l k8s-app=etcd 2>${STD_ERR} | grep "Running" | awk '{print $1}' | head -1) etcdctl endpoint status -w table 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | sed -e "s/ [3-9][0-9]% /${yellowtext}&${resetcolor}/" -e "s/ true /${greentext}&${resetcolor}/"
    fct_title "ETCD member list"
    ${OC} rsh -n openshift-etcd -c etcdctl $(${OC} get pod -n openshift-etcd -l k8s-app=etcd 2>${STD_ERR} | grep "Running" | awk '{print $1}' | head -1) etcdctl member list -w table
  fi
  fct_title "ETCD \"took to long\" & \"server is likely overloaded\" log messages"
  for POD in $(${OC} get pod -n openshift-etcd -l app=etcd -o name 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | cut -d'/' -f2-)
  do
    fct_title_details "${POD}"
    ${OC} logs $POD -c etcd -n openshift-etcd 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | grep -E "took too long|server is likely overloaded" | sed -e "s/\(.*\)\(took too long\)\(.*\)/\2/" -e "s/\(.*\)\(server is likely overloaded\)\(.*\)/\2/" | sort | uniq -c | sed -e "s/^ *[1-9][0-9]\{2\} /${yellowtext}&${resetcolor}/" -e "s/^ *[1-9][0-9]\{3,10\} /${redtext}&${resetcolor}/"
  done
fi

########### ALERTS ###########
if [[ ! -z ${ALERTS} ]] || [[ ! -z ${ALL} ]]
then
  fct_header "ALERTS STATUS"
  if [[ "${OC}" == "omg" ]] || [[ "${OC}" == "omc" ]]
  then
    RULES=$(${OC} prometheus alertrule -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}")
  else
    TOKEN=$(${OC} get secret -n openshift-monitoring -o json 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" | jq -r '.items[] | select((.metadata.name | test("prometheus-k8s-token")) and (.metadata.annotations."kubernetes.io/created-by" != null)) | .data.token' | base64 -d)
    PROMETHEUS_URL=$(${OC} get route.route.openshift.io -n openshift-monitoring prometheus-k8s -o jsonpath="{.status.ingress[0].host}" 2>${STD_ERR} | grep -Ev "${MESSAGE_EXCLUSION}" )
    if [[ ! -z ${TOKEN} ]] && [[ ! -z ${PROMETHEUS_URL} ]]
    then
      RULES=$(curl -sNk -H "Authorization: Bearer $TOKEN" https://$PROMETHEUS_URL/api/v1/rules 2>${STD_ERR} | jq -r --sort-keys '{ "data": [ .data.groups[].rules[] ] }')
    fi
  fi
  if [[ ! -z "${RULES}" ]]
  then
    fct_title "firing Alerts"
    echo ${RULES} | jq -r '"RULE|STATE|AGE|ALERTS|ACTIVE SINCE",(if .data != null then (.data[] | select(.state == "firing") | "\(.name)|\(.state)|N/A|\(.alerts | length)|\("\(.alerts | sort_by(.activeAt) | .[0].activeAt[0:19])Z"|fromdate|strftime("%d %b %y %H:%M UTC"))") else "" end)' | column -s'|' -t | sed -e "s/^Kube[a-zA-Z]* /${purpletext}&${resetcolor}/" -e "s/^Cluster[a-zA-Z]* /${purpletext}&${resetcolor}/" -e "s/^System[a-zA-Z]* /${purpletext}&${resetcolor}/" -e "s/ [5-9]  /${yellowtext}&${resetcolor}/" -e "s/ [0-9]\{2,5\}  /${redtext}&${resetcolor}/"
    fct_title "Firing Alerts rules details"
    echo ${RULES} | jq -r --arg trunk ${ALERT_TRUNK} '"ALERTNAME|LAST ACTIVE|NAMESPACE|OBJECT REFERENCE|SEVERITY|DESCRIPTION|",if .data != null then (.data[] | select(.state == "firing") | .alerts | sort_by(.activeAt) | .[] | "\(.labels.alertname)|\(.activeAt)|\(.labels.namespace)|\(if (.labels.workload != null) then .labels.workload elif (.labels.pod != null) then .labels.pod elif (.labels.endpoint != null) then .labels.endpoint elif (.labels.job != null) then .labels.job elif (.labels.node != null) then .labels.node elif (.labels.name != null) then .labels.name elif (.labels.channel != null) then .labels.channel elif (.labels.poddisruptionbudget != null) then .labels.poddisruptionbudget else .labels.service end)|\(.labels.severity)|\(if (.annotations != null) then (if (.annotations.description != null) then .annotations.description[0:($trunk|tonumber)] | sub("\n";" ";"g") elif (.annotations.message != null) then .annotations.message[0:($trunk|tonumber)] | sub("\n";" ";"g") elif (.annotations.summary != null) then .annotations.summary[0:($trunk|tonumber)] | sub("\n";" ";"g") else "N/A" end) else "N/A" end)") else "" end' | column -t -s'|' | sed -e 's/^"//' -e 's/"$//' -e "s/ [Ww]arning /${yellowtext}&${resetcolor}/" -e "s/ [Ii]nfo /${greentext}&${resetcolor}/" -e "s/ [Cc]ritical /${redtext}&${resetcolor}/" -e "s/ [Mm]ajor /${redtext}&${resetcolor}/" -e "s/^Kube[a-zA-Z]* /${purpletext}&${resetcolor}/" -e "s/^Cluster[a-zA-Z]* /${purpletext}&${resetcolor}/" -e "s/^System[a-zA-Z]* /${purpletext}&${resetcolor}/"
  else
    ERR_MSG="Failed to retrieve and display the Alerts"
    fct_title "firing Alerts"
    echo -e "${purpletext}${ERR_MSG}${resetcolor}"
    fct_title "Firing Alerts rules details"
    echo -e "${purpletext}${ERR_MSG}${resetcolor}"
  fi
fi

fct_version
exit 0
