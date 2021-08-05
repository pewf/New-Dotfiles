#!/usr/bin/env bash

function run {
	if ! pgrep -f $1 ;
	then
		killall $($@&)
		$@&
	fi
}

# Startup programs

# POLYBAR
killall polybar || true && polybar main

# POLYBAR APPLETS
# killall nm-applet || true && nm-applet

# PICOM
picom
