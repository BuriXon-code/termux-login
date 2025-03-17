#!/data/data/com.termux/files/usr/bin/sh

EXPECTED_SHA="password-sha256"
LOGS_PATH="/data/data/com.termux/files/home/.login_logs/"
INTRUDERS_DIR="intruders"
LOG_FILE="${LOGS_PATH}logs.txt"
TIMESTAMP=$(date +%d-%m-%y--%H:%M:%S)
DAYSTAMP=$(date +%A)
AUTH_SUCCESS=0

mkdir -p ${LOGS_PATH}${INTRUDERS_DIR}
touch $LOG_FILE

log_event() {
	echo "$1" >> "$LOG_FILE"
}

info_text() {
	sleep 0.3
	echo "\n\033[31mIntruder detected..."
}

log_event "\n$DAYSTAMP -- $(date +%d-%m-%y) -- $(date +%H:%M:%S) -- OPENING TERMUX\n"

validate() {
	result=$(termux-fingerprint | grep auth | cut -d '"' -f 4 | cut -d "_" -f 3)
	if [ "$result" = "SUCCESS" ]; then
		log_event "$TIMESTAMP -- TERMUX ($(whoami)) -- LOGIN SUCCESS (FINGERPRINT)"
		echo "\033[32mFingerprint correct.\033[0m"
		AUTH_SUCCESS=1
		return 0
	fi
	return 1
}

a=0
while [ $a -lt 3 ] && [ $AUTH_SUCCESS -eq 0 ]; do
	if validate; then
		break
	fi
	a=$((a + 1))
	log_event "$TIMESTAMP -- TERMUX ($(whoami)) -- LOGIN FAIL $a/3 (FINGERPRINT)"
	echo "\033[31mIncorrect attempt: $a of 3\033[0m"
done

if [ $AUTH_SUCCESS -eq 1 ]; then
	return 0
fi

check_password() {
	echo -n "Enter password: "
	stty -echo
	read password
	stty echo
	echo
	password_sha=$(echo -n "$password" | sha256sum | awk '{print $1}')

	if [ "$password_sha" = "$EXPECTED_SHA" ]; then
		log_event "$TIMESTAMP -- TERMUX ($(whoami)) -- PASSWORD SUCCESS"
		echo "\033[32mPassword correct.\033[0m"
		return 0
	else
		info_text &
		log_event "$TIMESTAMP -- TERMUX ($(whoami)) -- LOGIN FAIL (PASSWORD)"
		termux-volume notification 15
		sleep 1
		filename="intruder-$(date +%d%m%y-%H%M%S)"
		termux-camera-photo -c 1 "${LOGS_PATH}${INTRUDERS_DIR}/$filename-front.jpg"
		log_event "$TIMESTAMP -- TERMUX ($(whoami)) -- LOGIN -- FRONT PHOTO TAKEN"
		termux-camera-photo -c 0 "${LOGS_PATH}${INTRUDERS_DIR}/$filename-back.jpg"
		log_event "$TIMESTAMP -- TERMUX ($(whoami)) -- LOGIN -- BACK PHOTO TAKEN"
		log_event "$TIMESTAMP -- TERMUX ($(whoami)) -- LOGIN -- KILLING TERMUX"
                termux-notification \
                        --title "ALERT" \
                        --content "Unauthorized login attempt" \
                        --priority high \
                        --sound \
                        --vibrate 800,400,800
                log_event "$TIMESTAMP -- TERMUX ($(whoami)) -- LOGIN -- NOTIFICATION SEND"
		sleep 2
		termux-volume notification 0
		sleep 0.2
		kill -9 $PPID
	fi
}

check_password
