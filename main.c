#include <stdint.h>
#include <nrf_gpio.h>
#include <nrfx_uarte.h>
#include <nrfx_saadc.h>


#define BLUE_LED    NRF_GPIO_PIN_MAP(1, 10)
#define RED_LED     NRF_GPIO_PIN_MAP(1, 15)
#define D5          NRF_GPIO_PIN_MAP(1, 8)
#define D6          NRF_GPIO_PIN_MAP(0, 7)
#define A0          NRF_GPIO_PIN_MAP(1, 12)

uint8_t stringToSend = 48;
int stsLen = 1;

uint8_t rxBuffer[5];
uint8_t size = 4;

volatile int txFlag = 0;
volatile int voltFlag = 0;

nrfx_uarte_t uarte_instance = NRFX_UARTE_INSTANCE(0);
nrfx_uarte_config_t uarte_config = NRFX_UARTE_DEFAULT_CONFIG;
nrfx_saadc_config_t saadc_config = NRFX_SAADC_DEFAULT_CONFIG;
nrf_saadc_channel_config_t saadc_channel_config = NRFX_SAADC_DEFAULT_CHANNEL_CONFIG_SE(A0);


void nrfx_uarte_event_handler(nrfx_uarte_event_t const* p_event, void* p_context){
    txFlag = 1;
}

void nrfx_saadc_event_handler(nrfx_saadc_evt_t const* p_event){

    //nrfx_saadc_sample_convert(0, p_event->done.)
    voltFlag = 1;
}

int counter = 0;

int main(void){

    nrf_gpio_cfg_output(RED_LED);
    nrf_gpio_cfg_output(BLUE_LED);
    nrfx_err_t err = 0;

    uarte_config.pseltxd = D5;
    uarte_config.pselrxd = D6;
    err = nrfx_uarte_init(&uarte_instance, &uarte_config, nrfx_uarte_event_handler);

    err = nrfx_saadc_init(&saadc_config, nrfx_saadc_event_handler);
    err = nrfx_saadc_channel_init(0, &saadc_channel_config);

    while(1){
        
        //err = nrfx_uarte_tx(&uarte_instance, stringToSend, stsLen);
        err = nrfx_uarte_tx(&uarte_instance, &stringToSend, stsLen);
       
         
        uint8_t configRegVal = uarte_instance.p_reg->CONFIG;
        if((configRegVal & 0x0001) == 0){
            nrf_gpio_pin_toggle(BLUE_LED);
        }

        while(txFlag == 0){
            err++;
            err %= 19;
        }

        counter = (counter + 1)%1000;
        if(counter == 0){
            nrf_gpio_pin_toggle(RED_LED);
        }
        txFlag = 0;
    }
    return 0;
}
