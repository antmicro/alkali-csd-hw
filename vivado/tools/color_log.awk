BEGIN {
    RESET="\033[0m";
    RED="\033[0;31m";
    GREEN="\033[0;32m";
    YELLOW="\033[0;33m";
    BPURPLE="\033[1;35m"
}
/ERROR:/ {print RED $0 RESET; next}
/CRITICAL WARNING:/ {print BPURPLE $0 RESET; next}
/WARNING:/ {print YELLOW $0 RESET; next}
/INFO:/ {print GREEN $0 RESET; next}
// {print $0}
