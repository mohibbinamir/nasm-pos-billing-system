# NASM POS Billing System

This project is a menu-driven Point of Sale (POS) billing system developed in **NASM x86 assembly language** for Linux. It was created as an academic assignment for **Computer System Low-Level Techniques (CT073-3-2-CSLLT)**.

The system simulates a simple fast-food billing environment where users can select menu items, enter quantities, calculate the subtotal, apply discount rules, calculate tax, and display the final bill.

## Project Overview

The implemented prototype is a **Burger King POS Billing System** built using low-level programming concepts. It demonstrates how assembly language can be used to create a functional business-style application while applying core assembly constructs such as arithmetic operations, loops, and jumps.

## Features

- Menu-based ordering system
- Quantity input for selected items
- Item total and subtotal calculation
- 10% discount for subtotal of RM50.00 or above
- 6% tax calculation
- Final bill generation
- Invalid input handling
- Exit option

## Concepts Demonstrated

This project was designed to satisfy the core assignment requirements by using:

- **Arithmetic operations** for price, subtotal, discount, tax, and final total calculation
- **Loops** for repeated menu display and input processing
- **Conditional and unconditional jumps** for branching and control flow
- **Linux system calls** for keyboard input and screen output

## Technologies Used

- NASM
- x86 Assembly Language
- Linux / WSL
- ld linker

## How to Assemble and Run

Use the following commands in Linux or WSL:

```bash
nasm -f elf32 pos.asm -o pos.o
ld -m elf_i386 pos.o -o pos
./pos
