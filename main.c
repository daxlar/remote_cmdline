#include <nrf_gpio.h>

#define BLUE_LED NRF_GPIO_PIN_MAP(1, 10)
#define RED_LED NRF_GPIO_PIN_MAP(1, 15)

int main(void){
    /*
    nrfx_gpiote_out_config_t p_config = {
        .action = 0,
        .init_state = 0,
        .task_pin = 0,
    };

    int err_code = 0;

    err_code = nrfx_gpiote_init();
    err_code = nrfx_gpiote_out_init(NRF_GPIO_PIN_MAP(1,15), &p_config);
    
    while(!err_code){
        nrfx_gpiote_out_toggle(NRF_GPIO_PIN_MAP(1,15));
        for(int i = 0; i < 100000; i++){

        }
    }
    */

   nrf_gpio_cfg_output(RED_LED);
   nrf_gpio_cfg_output(BLUE_LED);
   int j = 0;
    while(1){
        nrf_gpio_pin_toggle(RED_LED);
        nrf_gpio_pin_toggle(BLUE_LED);
        for(int i = 0; i < 1000000; i++){
            j++;
        }
        j = 0;
    }
    return 0;
}