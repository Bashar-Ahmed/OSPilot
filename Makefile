CPP_SOURCES = $(wildcard *.cpp)
RUST_SOURCES = $(wildcard *.rs)
HEADERS = $(wildcard *.h)
CPP_OBJ_FILES = ${CPP_SOURCES:.cpp=.o}
RUST_OBJ_FILES = ${RUST_SOURCES:.rs=.o}

all: cpp

cpp-kernel.bin: boot/kernel_entry.o ${CPP_OBJ_FILES}
	x86_64-elf-ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary
cpp-os-image.bin: boot/mbr.bin cpp-kernel.bin
	cat $^ > $@
cpp: clean cpp-os-image.bin
	qemu-system-i386 -fda cpp-os-image.bin
echo-cpp: cpp-os-image.bin
	xxd $<

rust-kernel.bin: boot/kernel_entry.o ${RUST_OBJ_FILES}
	x86_64-elf-ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary
rust-os-image.bin: boot/mbr.bin rust-kernel.bin
	cat $^ > $@
rust: clean rust-os-image.bin
	qemu-system-i386 -fda rust-os-image.bin
echo-rust: rust-os-image.bin
	xxd $<

%.o: %.cpp ${HEADERS}
	x86_64-elf-gcc -m32 -ffreestanding -c $< -o $@ # -g for debugging
%.o: %.rs
	rustc --emit obj $< --target=i686-unknown-linux-gnu --crate-type=lib

%.o: %.asm
	nasm $< -f elf -o $@
%.bin: %.asm
	nasm $< -f bin -o $@
%.dis: %.bin
	ndisasm -b 32 $< > $@

clean:
	$(RM) *.bin *.o *.dis *.elf
	$(RM) boot/*.o boot/*.bin