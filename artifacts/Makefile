PROJECT := remote

PRJ_PATH := $(HOME)/projects/remote
SDK_PATH := $(HOME)/Documents/DeviceDownload/nRF5_SDK_17.0.2_d674dde
#Softdevice path
SDV_PATH := $(HOME)/Documents/DeviceDownload/s140nrf52720


ASMS += \
		$(SDK_PATH)/modules/nrfx/mdk/gcc_startup_nrf52840.S 

SRCS += \
		$(SDK_PATH)/components/libraries/util/app_util_platform.c \
		$(SDK_PATH)/modules/nrfx/drivers/src/prs/nrfx_prs.c \
		$(SDK_PATH)/modules/nrfx/drivers/src/nrfx_uarte.c \
		$(PRJ_PATH)/main.c \
		$(MDK_PATH)/system_nrf52840.c \

INCS += \
		$(SDK_PATH)/components \
		$(SDK_ROOT)/modules/nrfx/mdk \
		$(PRJ_PATH) \
		$(SDK_PATH)/components/toolchain/cmsis/include \
		$(SDK_PATH)/components/libraries/util \
  		../config \
		$(SDK_PATH)/modules/nrfx/hal \
		$(SDK_PATH)/components/libraries/log \
		$(SDK_PATH)/modules/nrfx/ \
		$(SDK_ROOT)/components/libraries/experimental_section_vars \
		$(SDK_ROOT)/integration/nrfx \
		$(SDK_ROOT)/components/drivers_nrf/nrf_soc_nosd \
		$(SDK_PATH)/modules/nrfx/drivers/include \
		$(SDK_ROOT)/components/libraries/log/src \
		#$(SDK_PATH)/modules/nrfx/templates \
		$(SDK_PATH)/modules/nrfx/templates/nrf52840 \
		$(SDK_PATH)/modules/nrfx/drivers/src/prs \
		$(SDK_PATH)/modules/nrfx/soc \




CFLAGS += -DNRF52840_XXAA \
		  -DCONFIG_GPIO_AS_PINRESET \
		  -DFLOAT_ABI_HARD \
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
 
.PHONY: all flash clean 

clean:
	rm -rf $(BUILD_DIR)

flash: $(BUILD_DIR)/$(PROJECT).bin
	nrfjprog -f NRF52 --eraseall
	nrfjprog -f NRF52 --program $< --chiperase
	nrfjprog -f nrf52 --reset

all: $(BUILD_DIR)/$(PROJECT).bin

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