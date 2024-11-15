#!/bin/bash
# -----------------------------------------------------------------------------
# Script Name: hex2asm.sh
# Description: Converts hex files to binary, then disassembles the binaries.
# Author: Your Tim Böttiger
# Created on: 2024-11-15
# License: MIT License
# -----------------------------------------------------------------------------

HEX_CMD="xxd -r -p"
ASM_CMD="dispel -A -o "

HEX_DIR="./hexdumps"
BIN_DIR="./binaries"
ASM_DIR="./assembler/plain"

mkdir -p "$BIN_DIR"
mkdir -p "$ASM_DIR"

for hex_file in "$HEX_DIR"/*.hex; do
  base_name=$(basename "$hex_file" .hex)
  bin_file="$BIN_DIR/$base_name.bin"
  asm_file="$ASM_DIR/$base_name.asm"
  
  $HEX_CMD "$hex_file" > "$bin_file"
  if [[ $? -eq 0 ]]; then
    echo "$hex_file -> $bin_file"
  else
    echo "Error: Failed to convert $hex_file"
    continue
  fi
  
  $ASM_CMD "$asm_file" "$bin_file"
  if [[ $? -eq 0 ]]; then
    echo "$bin_file -> $asm_file"
  else
    echo "Error: Failed to disassemble $bin_file"
  fi
done

echo "Done!"