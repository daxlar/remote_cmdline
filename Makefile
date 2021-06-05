PROJECT := remote

MDK_PATH := $(HOME)/Documents/nRF_MDK_8_38_0_GCC_NordicLicense
SDK_PATH := $(HOME)/Documents/DeviceDownload/nRF5_SDK_17.0.2_d674dde
#Softdevice path
SDV_PATH := $(HOME)/Documents/DeviceDownload/s140nrf52720


ASMS += \
		$(MDK_PATH)/gcc_startup_nrf52840.S 

SRCS += \
		$(MDK_PATH)/system_nrf52840.c \
		$(SDK_PATH)/modules/nrfx/drivers/src/nrfx_gpiote.c \
		main.c 

INCS += \
		$(MDK_PATH) \
		$(SDK_PATH)/components/toolchain/cmsis/include \
		$(SDK_PATH)/modules/nrfx/ \
		$(SDK_PATH)/modules/nrfx/templates \
		$(SDK_PATH)/modules/nrfx/templates/nrf52840 \
		$(SDK_PATH)/modules/nrfx/hal \
		$(SDK_PATH)/modules/nrfx/drivers/include




CFLAGS += -DNRF52840_XXAA \
		  -mcpu=cortex-m4 \
		  -mthumb \
		  -mabi=aapcs \
	      -Wall \
		  -Werror \
		  -O0 \
		  -g \
	      -mfloat-abi=hard \
		  -mfpu=fpv4-sp-d16 \
		  -ffunction-sections \
		  -fdata-sections \
		  -fno-strict-aliasing \
	      -fno-builtin \
		  -fshort-enums 

LDFLAGS += -Wl,--gc-sections \
		   --specs=nano.specs \
		   -T nrf52840_xxaa.ld

CFLAGS += $(foreach i,$(INCS),-I$(i))

CC=arm-none-eabi-gcc
OCPY=arm-none-eabi-objcopy
MKDIR=mkdir
BUILD_DIR := $(CURDIR)/build
OBJ_DIR = $(BUILD_DIR)/
no_echo := @


#OBJS := $(patsubst %.c,$(OBJ_DIR)/%.o,$(SRCS))
#OBJS += $(patsubst %.S,$(OBJ_DIR)/%.o,$(SRCS))

OBJS = $(filter $(OBJ_DIR)/%.o,$(patsubst %.S,$(OBJ_DIR)/%.o,$(ASMS)) \
       $(patsubst %.c,$(OBJ_DIR)/%.o,$(SRCS)))
 
       


#hello:
#	echo "hello world"


#test.elf: main.c
#	$(no_echo)arm-none-eabi-gcc main.c 
.PHONY: all clean 
all: flash

$(BUILD_DIR):
	$(MKDIR) -p $(BUILD_DIR)

$(OBJ_DIR):
	$(MKDIR) -p $(OBJ_DIR)

$(OBJ_DIR)/%.o: %.c $(OBJ_DIR)
	@echo "Compiling $<"
	$(NO_ECHO)$(MKDIR) -p $(dir $@)
	$(NO_ECHO)$(CC) -c -o $@ $< $(CFLAGS)

$(OBJ_DIR)/%.o: %.S $(OBJ_DIR)
	@echo "Compiling $<"
	$(NO_ECHO)$(MKDIR) -p $(dir $@)
	$(NO_ECHO)$(CC) -c -o $@ $< $(CFLAGS)

$(BUILD_DIR)/$(PROJECT).elf: $(OBJS)
	$(CC) $(CFLAGS) $^ $(LDFLAGS) -o $@

$(BUILD_DIR)/$(PROJECT).bin: $(BUILD_DIR)/$(PROJECT).elf
	$(OCPY) $< $@ -O binary

flash: $(BUILD_DIR)/$(PROJECT).bin
	nrfjprog -f NRF52 --eraseall
	nrfjprog -f NRF52 --program $< --chiperase
	nrfjprog -f nrf52 --reset

clean:
	rm -rf $(BUILD_DIR)