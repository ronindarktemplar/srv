#!/bin/bash


IP="/usr/sbin/iptables"
$IP -F
$IP -F INPUT
$IP -F FORWARD
$IP -F OUTPUT
$IP -F -t nat
$IP -Z -t nat
$IP -X
$IP -Z
$IP -P INPUT ACCEPT
$IP -P OUTPUT ACCEPT
$IP -P FORWARD ACCEPT
