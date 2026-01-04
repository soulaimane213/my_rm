# my_rm

`my_rm` is a custom implementation of the Linux `rm` command, written from scratch in **C** and **x86_64 Assembly**.

This project is part of my low-level programming and systems programming journey. It focuses on understanding how core Linux utilities work internally by interacting directly with the kernel using system calls.

---

## 👂 Project Structure

```
my_rm/
├── C_version/
│   └── main.c
├── ASM_version/
│   └── main.asm
└── README.md
```

* **C_version/**:
  Implementation of `rm` using the C language and standard Linux system calls.
* **ASM_version/**:
  Low-level implementation using pure x86_64 Assembly to directly invoke Linux syscalls.

---

## ✨ Features

* Remove regular files
* Recursive deletion (`-r`)
* Interactive mode (`-i`)
* Verbose output (`-v`)
* Manual parsing of command-line arguments
* Direct usage of Linux system calls (`unlink`, `lstat`, `open`, `getdents`, etc.)
* Educational focus on how `rm` works internally

---

## 🛠️ Compilation

### C Version

```bash
gcc main.c -o my_rm
```

### Assembly Version

```bash
nasm -f elf64 main.asm -o program.o
ld program.o -o my_rm
```

---

## 🚀 Usage

```bash
./my_rm [options] file1 file2 ...
```

### Options

* `-r` : Recursively delete directories
* `-i` : Ask for confirmation before each deletion
* `-v` : Print details about deleted files

Example:

```bash
./my_rm -i -v -r test_dir
```

---

## 🏏️ Goals of This Project

* Understand Linux filesystem internals
* Practice system programming in C
* Learn direct kernel interaction via Assembly
* Improve debugging skills using `gdb`
* Build real-world low-level projects (coreutils-like tools)

---

## ⚠️ Warning

This project is for **educational purposes only**.
Use carefully — incorrect usage may permanently delete files.

---

## 👨‍💻 Author

**Soulaimane**
Computer Science student
Interested in:

* Low-level programming
* Linux internals
* Reverse engineering
* Cybersecurity

---

## 📜 License

This project is open for learning and experimentation.
