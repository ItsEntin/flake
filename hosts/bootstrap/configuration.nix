{ config, lib, pkgs, ... }: {

environment.systemPackages = [(
	pkgs.writeShellScriptBin "nixinit" ''
		#!/bin/bash
		exec git clone https://github.com/ItsEntin/flake.git "$HOME/flake"
	''
)];

}
