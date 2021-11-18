#!/usr/bin/expect -f

set username [lindex $argv 0];
set password [lindex $argv 1];
set hostnode [lindex $argv 2];

if {$username eq ""} {set user ansible}
if {$password eq ""} {set pass ansible}
if {$hostnode eq ""} {set host localhost}

spawn ssh-copy-id -f "$username@$hostnode"
expect {
    "fingerprint" {send "yes\n"}
    "password:" {send "$password\n"}
    eof
}
expect {
    "password:" {send "$password\n"}
    eof
}
expect eof
