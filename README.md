# NASM POS Billing System

This project is a simple Point of Sale billing system developed in NASM x86 assembly language for Linux.

## Features
- Menu-based ordering system
- Quantity input
- Subtotal calculation
- 10% discount for qualifying orders
- 6% tax calculation
- Final bill generation
- Use of arithmetic operations, loops, and jumps

## Technologies Used
- NASM
- x86 Assembly
- Linux / WSL

## How to Run
```bash
nasm -f elf32 pos.asm -o pos.o
ld -m elf_i386 pos.o -o pos
./pos
