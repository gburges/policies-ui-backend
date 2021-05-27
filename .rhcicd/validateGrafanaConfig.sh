#!/bin/bash
echo "...Attempting to validate grafana configuration";

#Check for helpful policies-tools/shared/* contents:
SCRIPT=`basename "$0"`;
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )";
POLICIES_TOOLS_HELPER_CONFIG=`realpath "$SCRIPT_DIR/../../policies-tools"`;
if [[ -d "$POLICIES_TOOLS_HELPER_CONFIG" ]]
then
  SHARED="shared";
  . "$POLICIES_TOOLS_HELPER_CONFIG"/"$SHARED"/DefineConstants.sh --source-only
  . "$POLICIES_TOOLS_HELPER_CONFIG"/"$SHARED"/DebugLog.sh --source-only
    [[ "$DEBUG_ENABLED" == "$YES" ]] && DebugLog "SCRIPT_DIR" "$SCRIPT_DIR" "" "FILE";
    [[ "$DEBUG_ENABLED" == "$YES" ]] && DebugLog "POLICIES_TOOLS_ROOT" "$POLICIES_TOOLS_HELPER_CONFIG" "" "FILE";
    [[ "$DEBUG_ENABLED" == "$YES" ]] && DebugLog "DEFINE_CONSTANTS" "$POLICIES_TOOLS_HELPER_CONFIG/$SHARED/DefineConstants.sh" "" "FILE";
fi

# find yaml file
YAML_FILE=`ls $SCRIPT_DIR | grep -m 1 grafana-dashboard-*.configmap.yaml`;
  [[ "$DEBUG_ENABLED" == "$YES" ]] && DebugLog "YAML_FILE" "$YAML_FILE" "(testing for expected yaml file 1st match only!)" "FILE";
[[ ! -z "$YAML_FILE" ]] && echo "...Validating that [$SCRIPT_DIR/$YAML_FILE] is a valid yaml file.";

# validate yaml
[[ -f "$YAML_FILE" ]] && python -c 'import yaml, sys; yaml.safe_load(sys.stdin)' < "$YAML_FILE" && VALIDATED="true";
  [[ "$DEBUG_ENABLED" == "$YES" ]] && DebugLog "VALIDATED" "$VALIDATED" "(testing for non-empty validation check)" "FOUND";

# if VALIDATED = empty, then valid json contained within
[[ ! -z "$VALIDATED" ]] && echo "[SUCCESS]Configuration file IS valid yaml."
[[ -z "$VALIDATED" ]] && echo "[ERROR]Configuration file is NOT valid yaml. Please use above error message to correct issues before commiting this version." 

# Checking for valid json
[[ ! -z "$VALIDATED" ]] && echo "...Validating that included json is valid";
# find json file
[[ ! -z "$VALIDATED" ]] && JSON_FILE=`ls $SCRIPT_DIR | awk '$1 = "sections.json" { print }' | grep -m 1 "sections.json"`; 
  [[ "$DEBUG_ENABLED" == "$YES" ]] && DebugLog "JSON_FILE" "$JSON_FILE" "(testing for expected json file exists)" "FILE";
[[ ! -z "$JSON_FILE" ]] && echo "...Validating that [$SCRIPT_DIR/$JSON_FILE] is a valid json file.";

# validate json
[[ -f "$JSON_FILE" ]] && python -mjson.tool "$SCRIPT_DIR/$JSON_FILE" > /dev/null && VALID_JSON="true";
[[ ! -z "$VALID_JSON" ]] && echo "[SUCCESS]Configuration file IS valid json."
[[ -z "$VALID_JSON" ]] && echo "[ERROR]Configuration file is NOT valid json. Please use above error message or other tools to correct issues before commiting this version." 
