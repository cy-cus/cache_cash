#!/bin/bash

# Define colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m" # No Color

# Print colored output
cecho() {
  printf "${!1}${2} ${NC}\n"
}

# Validate domain input
validate_domain() {
  local domain="$1"
  if [[ -z "$domain" ]]; then
    cecho "RED" "Error: No domain provided."
    exit 1
  fi
}

# Log messages
log() {
  local message="$1"
  local log_file="script.log"
  if ! touch "$log_file" 2>/dev/null; then
    cecho "RED" "Error: Could not create log file $log_file."
    exit 1
  fi
  if ! echo "$(date +"%Y-%m-%d %H:%M:%S") - $message" >> "$log_file"; then
    cecho "RED" "Error: Could not write to log file $log_file."
    exit 1
  fi
}


declare domain="$1"
validate_domain "$domain"

# Subdomain enumeration function
subdomains() {
  cecho "YELLOW" "\nSTARTING SUBDOMAIN ENUMERATION\n"
  log "Starting subdomain enumeration"
  mkdir -p subdomains

  while IFS= read -r i; do
    subfinder -d "$i" -all -o "subdomains/$i-subfinder.txt"
    #assetfinder -subs-only "$i" | tee "subdomains/$i-assetfinder.txt"
    #python3 /hacks/Sublist3r/sublist3r.py -d "$i" -o "subdomains/$i-sublister.txt"
    # amass enum -brute -min-for-recursive 2 -d "$i" -o "subdomains/$i-amass.txt"
  done < "$domain"

  cat subdomains/*.txt | tee subdomains.txt | uniq | tee allsubdomains.txt
  rm subdomains.txt

  cecho "YELLOW" "\nSUBDOMAIN ENUMERATION DONE\n"
  log "Subdomain enumeration done"
}

# Visual check function
visual_check() {
  cecho "RED" "\nSTARTING SCREENSHOTS WITH AQUATONE\n"
  log "Starting screenshots with Aquatone"
  mkdir -p visual
  cat allsubdomains.txt | aquatone -scan-timeout 3000 -http-timeout 5000 -screenshot-timeout 60000 -ports medium -out visual/
  cp visual/aquatone_urls.txt .

  cecho "RED" "\nAQUATONE DONE\n"
  log "Aquatone done"
}

# Subdomain takeover check function
#subover() {
  #cecho "YELLOW" "\nSTARTING SUBDOMAIN TAKEOVER CHECK\n"
  #log "Starting subdomain takeover check"
  #subjack -w allsubdomains.txt -t 100 -timeout 30 -c /hacks/hacks/fingerprints.json -o subtakeover.txt -ssl

  #cecho "YELLOW" "\nSUBDOMAIN TAKEOVERS DONE\n"
  #log "Subdomain takeovers done"
#}

# Directory fuzzing function
#directories() {
  #mkdir -p fuzzed_directories
  #cat 403404s.txt | while read -r url; do
    #ffuf -c -u "$url/FUZZ" -w ../fuzzdirectories.txt -mc 200 -v -o "fuzzed_directories/$(echo "$url" | cut -d "/" -f3).json" | notify
  #done
#}

# Request smuggling function
smuggler() {
  cecho "RED" "\nSTARTING REQUEST SMUGGLER\n"
  log "Starting request smuggler"
  python3 /checks/smuggler/smuggler.py < all-livesubdomains.txt | tee postsmuggler.txt &
  python3 /checks/smuggler/smuggler.py -m GET < all-livesubdomains.txt | tee getmuggler.txt

  cecho "RED" "\nSMUGGLER DONE\n"
  log "Smuggler done"
}

# Nuclei function
openports_urls() {
  cecho "RED" "\nSTARTING NUCLEI\n"
  log "Starting Nuclei"
  mkdir -p nuclei
  nuclei -update-templates
  nuclei -l all-livesubdomains.txt -t ~/nuclei-templates -es info -o nuclei/nucleiresultsforsubs.txt &
  nuclei -l all-livesubdomains.txt -t ~/nuclei-templates/cves -es info -o nuclei/cves.txt &
  smuggler

  cecho "RED" "\nNUCLEI DONE\n"
  log "Nuclei done"
}

# Live subdomains function
live_subdomains() {
  cecho "YELLOW" "\nSTARTING LIVE SUBDOMAINS\n"
  log "Starting live subdomains"
  naabu -p 1-65535 -c 1000 -rate 100000 -silent < allsubdomains.txt | httpx -o all-livesubdomains.txt

  cecho "YELLOW" "\nSUBDOMAIN CHECK DONE\n"
  log "Subdomain check done"
}

# Live URLs function
all_urls() {
  cecho "YELLOW" "\nSTARTING LIVE URLS\n"
  log "Starting live URLs"
  waybackurls < allsubdomains.txt | sort -u > allurls.txt

  cecho "YELLOW" "\nLIVE URLS DONE\n"
  log "Live URLs done"
}

# Path extraction function
get_paths() {
  cecho "RED" "\nSTARTING PATHS\n"
  log "Starting paths"
  unfurl -u paths < allurls.txt | sed -r 's#/#\n#g' | grep -Ev 'png|jpg|gif|css' | sort -u > wypaths.txt

  cecho "RED" "\nPATHS DONE\n"
  log "Paths done"
}

# LinkFinder function
linkjsfinder() {
  cecho "YELLOW" "\nSTARTING LINKFINDER\n"
  log "Starting LinkFinder"
  grep "\.js$" allurls.txt | httpx -mc 200 > jsurls.txt

  while IFS= read -r i; do
    python3 /checks/LinkFinder/linkfinder.py --input "$i" -o cli >> jsendpoints.txt
  done < jsurls.txt

  cecho "YELLOW" "\nLINKFINDER DONE\n"
  log "LinkFinder done"
}


check_cors_misconfiguration() {
  local input_file="all-livesubdomains.txt"
  local output_file="cors_results.txt"

  while IFS= read -r target; do
    echo "Checking CORS misconfiguration for: $target"

    # Run CORScanner and capture the output
    result=$(python3 /checks/CORScanner/cors_scan.py -u "$target")

    # Check if CORS misconfiguration is detected
    if [[ $result == *"CORS Vulnerability found!"* ]]; then
      echo "CORS misconfiguration detected for: $target"
      echo "Vulnerability: DETECTED" >> "$output_file"
    else
      echo "No CORS misconfiguration detected for: $target"
      echo "Vulnerability: NOT DETECTED" >> "$output_file"
    fi

    echo "--------------------------"
  done < "$input_file"

  echo "CORS misconfiguration results written to: $output_file"
}



check_zone_transfer() {
  local input_file="allsubdomains.txt"
  local output_file="zone_transfer_results.txt"

  while IFS= read -r target; do
    echo "Checking zone transfer vulnerability for: $target"

    # Perform a DNS zone transfer using dnsrecon
    result=$(dnsrecon -d "$target" -t axfr)

    if [[ $result == *"AXFR"* ]]; then
      echo "Zone transfer is allowed for: $target"
      echo "Vulnerability: POTENTIAL" >> "$output_file"
    else
      echo "Zone transfer is not allowed for: $target"
      echo "Vulnerability: NOT DETECTED" >> "$output_file"
    fi

    echo "--------------------------"
  done < "$input_file"

  echo "Zone transfer results written to: $output_file"
}




# Main function
main() {
  subdomains

  visual_check &
  pid_visual_check=$!
  #subover &
  #pid_subover=$!
  live_subdomains &
  pid_live_subdomains=$!
  all_urls &
  pid_all_urls=$!
  check_zone_transfer &
  pid_check_zone_transfer=$!

  wait $pid_visual_check
  #wait $pid_subover
  wait $pid_live_subdomains
  wait $pid_all_urls
  wait $pid_check_zone_transfer

  smuggler &
  pid_smuggler=$!
  openports_urls &
  pid_openports_urls=$!
  get_paths &
  pid_get_paths=$!
  linkjsfinder &
  pid_linkjsfinder=$!
  check_cors_misconfiguration &
  pid_check_cors_misconfiguration=$!

  wait $pid_smuggler
  wait $pid_openports_urls
  wait $pid_get_paths
  wait $pid_linkjsfinder
  wait $pid_check_cors_misconfiguration
}

main
