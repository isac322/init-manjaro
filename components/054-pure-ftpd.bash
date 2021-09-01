#!/usr/bin/env bash

set -ex

yay -S pure-ftpd --noconfirm --removemake --needed

cat <<EOF | sudo tee /etc/pure-ftpd/pure-ftpd.conf > /dev/null
# Restrict users to their home directory
ChrootEveryone               yes

# Turn on compatibility hacks for broken clients
BrokenClientsCompatibility   no

# Maximum number of simultaneous users
MaxClientsNumber             100

# Run as a background process
Daemonize                    yes

# Maximum number of simultaneous clients with the same IP address
MaxClientsPerIP              20

# If you want to log all client commands, set this to "yes".
# This directive can be specified twice to also log server responses.
VerboseLog                   yes

# List dot-files even when the client doesn't send "-a".
DisplayDotFiles              yes

# Disallow authenticated users - Act only as a public FTP server.
AnonymousOnly                no

# Disallow anonymous connections. Only accept authenticated users.
NoAnonymous yes

# Syslog facility (auth, authpriv, daemon, ftp, security, user, local*)
# The default facility is "ftp". "none" disables logging.
SyslogFacility               auth

# Don't resolve host names in log files. Recommended unless you trust
# reverse host names, and don't care about DNS resolution being possibly slow.
DontResolve                  yes

# Maximum idle time in minutes (default = 15 minutes)
MaxIdleTime                  60

# If you want to enable PAM authentication, uncomment the following line
PAMAuthentication            yes

# If you want simple Unix (/etc/passwd) authentication, uncomment this
UnixAuthentication           yes

# 'ls' recursion limits. The first argument is the maximum number of
# files to be displayed. The second one is the max subdirectories depth.
LimitRecursion               10000 8

# Are anonymous users allowed to create new directories?
AnonymousCanCreateDirs       no

# If the system load is greater than the given value, anonymous users
# aren't allowed to download.
MaxLoad                      4

# Port range for passive connections - keep it as broad as possible.
PassivePortRange             50000 51000

# Disallow downloads of files owned by the "ftp" system user;
# files that were uploaded but not validated by a local admin.
AntiWarez                    no

# File creation mask. <umask for files>:<umask for dirs> .
# 177:077 if you feel paranoid.
Umask                        117:007

# Minimum UID for an authenticated user to log in.
# For example, a value of 100 prevents all users whose user id is below
# 100 from logging in. If you want "root" to be able to log in, use 0.
MinUID                       1000

# Allow FXP transfers for authenticated users.
AllowUserFXP                 no

# Allow anonymous FXP for anonymous and non-anonymous users.
AllowAnonymousFXP            no

# Users can't delete/write files starting with a dot ('.')
# even if they own them. But if TrustedGID is enabled, that group
# will exceptionally have access to dot-files.
ProhibitDotFilesWrite        no

# Prohibit *reading* of files starting with a dot (.history, .ssh...)
ProhibitDotFilesRead         no

# Don't overwrite files. When a file whose name already exist is uploaded,
# it gets automatically renamed to file.1, file.2, file.3, ...
AutoRename                   no

# Prevent anonymous users from uploading new files (no = upload is allowed)
AnonymousCantUpload          yes

# Allow users to resume/upload files, but *NOT* to delete them.
KeepAllFiles                 yes

# This option is useful on servers where anonymous upload is
# allowed. When the partition is more that percententage full,
# new uploads are disallowed.
MaxDiskUsage                   99

# Be 'customer proof': forbids common customer mistakes such as
# 'chmod 0 public_html', that are valid, but can cause customers to
# unintentionally shoot themselves in the foot.
CustomerProof                yes

# When a file is uploaded and there was already a previous version of the file
# with the same name, the old file will neither get removed nor truncated.
# The file will be stored under a temporary name and once the upload is
# complete, it will be atomically renamed. For example, when a large PHP
# script is being uploaded, the web server will keep serving the old version and
# later switch to the new one as soon as the full file will have been
# transferred. This option is incompatible with virtual quotas.
NoTruncate                   yes


# This option accepts three values:
# 0: disable SSL/TLS encryption layer (default).
# 1: accept both cleartext and encrypted sessions.
# 2: refuse connections that don't use the TLS security mechanism,
#    including anonymous sessions.
# Do _not_ uncomment this blindly. Double check that:
# 1) The server has been compiled with TLS support (--with-tls),
# 2) A valid certificate is in place,
# 3) Only compatible clients will log in.
TLS 2

# Cipher suite for TLS sessions.
# The default suite is secure and setting this property is usually
# only required to *lower* the security to cope with legacy clients.
# Prefix with -C: in order to require valid client certificates.
# If -C: is used, make sure that clients' public keys are present on
# the server.
TLSCipherSuite -S:HIGH:MEDIUM:+TLSv1

# Certificate file, for TLS
# The certificate itself and the keys can be bundled into the same
# file or split into two files.
# CertFile is for a cert+key bundle, CertFileAndKey for separate files.
# Use only one of these.
CertFile                     /etc/ssl/private/pure-ftpd.pem
# CertFileAndKey               /etc/pure-ftpd.pem /etc/pure-ftpd.key


# Listen only to IPv4 addresses in standalone mode (ie. disable IPv6)
# By default, both IPv4 and IPv6 are enabled.
IPV4Only                     yes
EOF

sudo systemctl enable --now pure-ftpd
