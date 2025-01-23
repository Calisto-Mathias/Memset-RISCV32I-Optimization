# Compiler and linker settings
AS = riscv64-linux-gnu-as
LD = riscv64-linux-gnu-ld
CFLAGS = -march=rv32i -mabi=ilp32
LDFLAGS = -melf32lriscv

# Directories
SRC_DIR = src
GENERATED_DIR = $(SRC_DIR)/generated_cases
BUILD_DIR = build
GEN_BUILD_DIR = $(BUILD_DIR)/generated_cases

# Find all .s files in respective directories
SRC_ASM = $(wildcard $(SRC_DIR)/*.s)
GEN_ASM = $(wildcard $(GENERATED_DIR)/*.s)

# Generate the corresponding object file paths in the build directory
SRC_OBJS = $(patsubst $(SRC_DIR)/%.s, $(BUILD_DIR)/%.o, $(SRC_ASM))
GEN_OBJS = $(patsubst $(GENERATED_DIR)/%.s, $(GEN_BUILD_DIR)/%.o, $(GEN_ASM))
ELF_FILES = $(patsubst $(GEN_BUILD_DIR)/%.o, $(GEN_BUILD_DIR)/%.elf, $(GEN_OBJS))

# Default target
all: $(SRC_OBJS) $(GEN_OBJS) $(ELF_FILES)

# Rule to assemble .s files in src to build
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.s
	@mkdir -p $(BUILD_DIR)
	$(AS) $(CFLAGS) -o $@ $<

# Rule to assemble .s files in src/generated_cases to build/generated_cases
$(GEN_BUILD_DIR)/%.o: $(GENERATED_DIR)/%.s
	@mkdir -p $(GEN_BUILD_DIR)
	$(AS) $(CFLAGS) -o $@ $<

# Rule to link each generated_cases object file with all src object files
$(GEN_BUILD_DIR)/%.elf: $(GEN_BUILD_DIR)/%.o $(SRC_OBJS)
	$(LD) $(LDFLAGS) -o $@ $^
	@echo "Generated ELF: $@"

# Clean up all compiled object files and executables
clean:
	rm -rf $(BUILD_DIR)

# Display helpful information
help:
	@echo "Makefile targets:"
	@echo "  all                   - Compile and link all .s files, generating separate ELF files for generated cases"
	@echo "  clean                 - Remove all compiled object files and executables"
	@echo "  help                  - Display this help message"
