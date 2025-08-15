#!/bin/bash
set -e

echo "Configuring Postfix for SES relay in predeploy hook..."

echo "Installing Postfix and Cyrus SASL..."
dnf install -y postfix cyrus-sasl-plain

# Path to the SASL password file
SASL_PASSWD_FILE="/etc/postfix/sasl_passwd"

if [ -z "$SES_SMTP_USERNAME" ] || [ -z "$SES_SMTP_PASSWORD" ]; then
  echo "Error: SES_SMTP_USERNAME and SES_SMTP_PASSWORD environment variables are not set."
  exit 1
fi

echo "[$SES_ENDPOINT]:587 $SES_SMTP_USERNAME:$SES_SMTP_PASSWORD" > $SASL_PASSWD_FILE

chmod 600 $SASL_PASSWD_FILE
postmap hash:$SASL_PASSWD_FILE

postconf -e "relayhost = [$SES_ENDPOINT]:587"
postconf -e "smtp_sasl_auth_enable = yes"
postconf -e "smtp_sasl_password_maps = hash:$SASL_PASSWD_FILE"
postconf -e "smtp_sasl_security_options = noanonymous"
postconf -e "smtp_use_tls = yes"
postconf -e "smtp_tls_security_level = encrypt"
postconf -e "smtp_tls_note_starttls_offer = yes"
postconf -e "smtp_tls_CAfile = /etc/pki/tls/certs/ca-bundle.crt"

echo "Starting and enabling Postfix service..."
systemctl start postfix
systemctl enable postfix

echo "Postfix configuration for SES complete."
