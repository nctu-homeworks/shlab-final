/* ///////////////////////////////////////////////////////////////////// */
/*  File   : findface_rtos.c                                             */
/*  Author : Chun-Jen Tsai                                               */
/*  Date   : 02/09/2013, 3/26/2015                                       */
/* --------------------------------------------------------------------- */
/*  This program will locate the position of a 32x32 face template       */
/*  in a group photo.                                                    */
/*                                                                       */
/*  This program is designed for the undergraduate course "Introduction  */
/*  to HW-SW Codesign and Implementation" at the department of Computer  */
/*  Science, National Chiao Tung University.                             */
/*  Hsinchu, 30010, Taiwan.                                              */
/* ///////////////////////////////////////////////////////////////////// */
/* Standard include files */
#include <limits.h>

/* FreeRTOS include files */
#include "FreeRTOS.h"
#include "task.h"
#include "semphr.h"

/* Xilinx include files */
#include "xparameters.h"
#include "xil_cache.h"
#include "xscutimer.h"
#include "xscuwdt.h"
#include "xscugic.h"
#include "xgpiops.h"

/* LED control declarations */
void vSetLED(BaseType_t xValue);
void vToggleLED(void);

#define partstDIRECTION_OUTPUT	( 1 )
#define partstOUTPUT_ENABLED	( 1 )
#define partstLED_OUTPUT		( 7 )  /* 7 for ZedBoard, 10 for ZC702 */
static XGpioPs xGpio;

/* user include files */
#include "image.h"

#define MSEC_PER_TICK (1000/configTICK_RATE_HZ)

/* Prototypes for the FreeRTOS call-back functions defined in user files. */
void vApplicationMallocFailedHook(void);
void vApplicationIdleHook(void);
void vApplicationStackOverflowHook(TaskHandle_t pxTask, char *pcTaskName);
void vApplicationTickHook(void);

/* This function initializes the Zynq hardware. */
static void prvSetupHardware(void);

/* The private watchdog is used as the timer that generates run time stats.
   This frequency means it will overflow quite quickly. */
void vTaskGetRunTimeStats( char *pcWriteBuffer );
XScuWdt xWatchDogInstance;
char pcWriteBuffer[1024];

/* The interrupt controller is initialized in this file. */
XScuGic xInterruptController;

/* User function prototypes. */
void  led_ctrl(void *pvParameters);
void  findface(void *pvParameters);
void  median3x3(uint8 *image, int width, int height);

volatile uint32 *hw_trig = (uint32 *) (XPAR_FINDFACE_0_BASEADDR);
volatile uint32 *hw_face1_addr = (uint32 *) (XPAR_FINDFACE_0_BASEADDR + 4);
volatile uint32 *hw_face2_addr = (uint32 *) (XPAR_FINDFACE_0_BASEADDR + 8);
volatile uint32 *hw_face3_addr = (uint32 *) (XPAR_FINDFACE_0_BASEADDR + 12);
volatile uint32 *hw_face4_addr = (uint32 *) (XPAR_FINDFACE_0_BASEADDR + 16);
volatile uint32 *hw_group_addr = (uint32 *) (XPAR_FINDFACE_0_BASEADDR + 20);
volatile uint32 *hw_min_sad1 = (uint32 *) (XPAR_FINDFACE_0_BASEADDR + 24);
volatile uint32 *hw_min_x1 = (uint32 *) (XPAR_FINDFACE_0_BASEADDR + 28);
volatile uint32 *hw_min_y1 = (uint32 *) (XPAR_FINDFACE_0_BASEADDR + 32);
volatile uint32 *hw_min_sad2 = (uint32 *) (XPAR_FINDFACE_0_BASEADDR + 36);
volatile uint32 *hw_min_x2 = (uint32 *) (XPAR_FINDFACE_0_BASEADDR + 40);
volatile uint32 *hw_min_y2 = (uint32 *) (XPAR_FINDFACE_0_BASEADDR + 44);
volatile uint32 *hw_min_sad3 = (uint32 *) (XPAR_FINDFACE_0_BASEADDR + 48);
volatile uint32 *hw_min_x3 = (uint32 *) (XPAR_FINDFACE_0_BASEADDR + 52);
volatile uint32 *hw_min_y3 = (uint32 *) (XPAR_FINDFACE_0_BASEADDR + 56);
volatile uint32 *hw_min_sad4 = (uint32 *) (XPAR_FINDFACE_0_BASEADDR + 60);
volatile uint32 *hw_min_x4 = (uint32 *) (XPAR_FINDFACE_0_BASEADDR + 64);
volatile uint32 *hw_min_y4 = (uint32 *) (XPAR_FINDFACE_0_BASEADDR + 68);

int main(void)
{
	int app_done = 0;

    /* Configure the hardware ready to run findface. */
    prvSetupHardware();

    /* Put the findface task in the taks queue. */
    xTaskCreate(findface,                /* pointer to the task function    */
    		(char *) "findface",         /* textural name of the task       */
    		configMINIMAL_STACK_SIZE,    /* stack size of the task in bytes */
    		(void *) &app_done,          /* pointer to the task parameter   */
    		tskIDLE_PRIORITY + 1,        /* priority of the task            */
    		NULL);                       /* pointer for returned task ID    */

    /* Put the LED control task in the task queue. */
    xTaskCreate(led_ctrl, (char *) "led_ctrl",
    		configMINIMAL_STACK_SIZE, (void *) &app_done, tskIDLE_PRIORITY + 1, NULL);

    /* Start running the tasks. If all is well, the scheduler will run     */
    /* forever and the function vTaskStartScheduler() will never return.   */
    vTaskStartScheduler();

    /* If the program reaches here, then there was probably insufficient   */
    /* FreeRTOS heap memory for the idle and/or timer tasks to be created. */
    return -1;  /* Return an error code to nobody! */
}

/* ----------------------------------------------------------------- */
/*  The following functions are for the face-matching algorithms.    */
/* ----------------------------------------------------------------- */
void findface(void *pvParameters)
{
    TickType_t counter;
    CImage group, face1, face2, face3, face4;
    int  width, height;
    int  posx = 0, posy = 0;
    int32 cost;
    int *pDone = (int *) pvParameters;

    /* read the group picture */
    xil_printf("1. Reading images, ");
    counter = xTaskGetTickCount();
    read_pnm_image("group.pgm", &group);
    width = group.width, height = group.height;

    /* read the 32x32 target face image */
    read_pnm_image("face1.pgm", &face1);
    read_pnm_image("face2.pgm", &face2);
    read_pnm_image("face3.pgm", &face3);
    read_pnm_image("face4.pgm", &face4);
    xil_printf("done in %ld msec.\n\r", (xTaskGetTickCount() - counter)*MSEC_PER_TICK);

    /* perform median filter for noise removal */
    xil_printf("2. Median filtering, ");
    counter = xTaskGetTickCount();
    median3x3(group.pix, width, height);
    xil_printf("done in %ld msec.\n\r", (xTaskGetTickCount() - counter)*MSEC_PER_TICK);

    /* perform face-matching */
    Xil_DCacheDisable();
    xil_printf("3. Face-matching, ");

    counter = xTaskGetTickCount();
    *hw_face1_addr = (uint32) face1.pix;
    *hw_face2_addr = (uint32) face2.pix;
    *hw_face3_addr = (uint32) face3.pix;
    *hw_face4_addr = (uint32) face4.pix;
    *hw_group_addr = (uint32) group.pix;
    *hw_trig = 1;
    while (*hw_trig);

    xil_printf("\e[33;45mdone in \e[1m%ld\e[0m\e[33;45m msec.\e[m\n\r\n\r", (xTaskGetTickCount() - counter)*MSEC_PER_TICK);
    xil_printf("\e[32m** Found the face1 at (%d, %d) with cost %ld\e[0m\n\r", *hw_min_x1, *hw_min_y1, *hw_min_sad1);
    xil_printf("\e[32m** Found the face2 at (%d, %d) with cost %ld\e[0m\n\r", *hw_min_x2, *hw_min_y2, *hw_min_sad2);
    xil_printf("\e[32m** Found the face3 at (%d, %d) with cost %ld\e[0m\n\r", *hw_min_x3, *hw_min_y3, *hw_min_sad3);
    xil_printf("\e[32m** Found the face4 at (%d, %d) with cost %ld\e[0m\n\r\n\r", *hw_min_x4, *hw_min_y4, *hw_min_sad4);

    /* set app_done flag */
    *pDone = 1;

    /* free allocated memory */
    vPortFree(face1.pix);
    vPortFree(face2.pix);
    vPortFree(face3.pix);
    vPortFree(face4.pix);
    vPortFree(group.pix);

    vTaskGetRunTimeStats(pcWriteBuffer);
    xil_printf("%s\n\r\n\r", pcWriteBuffer);

    /* The thread has ended, we must delete this task from the task queue. */
    vTaskDelete(NULL);
}

void matrix_to_array(uint8 *pix_array, uint8 *ptr, int width)
{
    int  idx, x, y;

    idx = 0;
    for (y = -1; y <= 1; y++)
    {
        for (x = -1; x <= 1; x++)
        {
            pix_array[idx++] = *(ptr+x+width*y);
        }
    }
}

void insertion_sort(uint8 *pix_array, int size)
{
    int idx, jdy;
    uint8 temp;

    for (idx = 1; idx < size; idx++)
    {
        for (jdy = idx; jdy > 0; jdy--)
        {
            if (pix_array[jdy] < pix_array[jdy-1])
            {
                /* swap */
                temp = pix_array[jdy];
                pix_array[jdy] = pix_array[jdy-1];
                pix_array[jdy-1] = temp;
            }
        }
    }
}

void median3x3(uint8 *image, int width, int height)
{
    int   row, col;
    uint8 pix_array[9], *ptr;

    for (row = 1; row < height-1; row++)
    {
        for (col = 1; col < width-1; col++)
        {
            ptr = image + row*width + col;
            matrix_to_array(pix_array, ptr, width);
            insertion_sort(pix_array, 9);
            *ptr = pix_array[4];
        }
    }
}

/* ----------------------------------------------------------------- */
/*  The following function initializes the ZedBoard and installs     */
/*  the interrupt table and ISR for the FreeRTOS OS kernel.          */
/* ----------------------------------------------------------------- */
static void prvSetupHardware(void)
{
    BaseType_t xStatus;
    XScuGic_Config *pxGICConfig;
    XGpioPs_Config *pxConfigPtr;

    /* Ensure no interrupts execute while the scheduler is in an inconsistent
       state.  Interrupts are enabled when the scheduler is started. */
    portDISABLE_INTERRUPTS();

    /* Obtain the configuration of the GIC. */
    pxGICConfig = XScuGic_LookupConfig(XPAR_SCUGIC_SINGLE_DEVICE_ID);

    /* Sanity check the FreeRTOSConfig.h settings matches the hardware. */
    configASSERT(pxGICConfig);
    configASSERT(pxGICConfig->CpuBaseAddress ==
        (configINTERRUPT_CONTROLLER_BASE_ADDRESS +
            configINTERRUPT_CONTROLLER_CPU_INTERFACE_OFFSET));
    configASSERT(pxGICConfig->DistBaseAddress ==
        configINTERRUPT_CONTROLLER_BASE_ADDRESS);

    /* Install a default handler for each GIC interrupt. */
    xStatus =
        XScuGic_CfgInitialize(&xInterruptController, pxGICConfig,
        pxGICConfig->CpuBaseAddress);
    configASSERT(xStatus == XST_SUCCESS);
    (void) xStatus; /* Stop compiler warning if configASSERT() is undefined. */

    /* Initialise the LED port through GPIO driver. */
    pxConfigPtr = XGpioPs_LookupConfig(XPAR_XGPIOPS_0_DEVICE_ID);
    xStatus = XGpioPs_CfgInitialize(&xGpio, pxConfigPtr, pxConfigPtr->BaseAddr);
    configASSERT(xStatus == XST_SUCCESS);
    (void) xStatus; /* Stop compiler warning if configASSERT() is undefined. */

    /* Enable outputs and set low (initially turn-off the LED). */
    XGpioPs_SetDirectionPin(&xGpio, partstLED_OUTPUT, partstDIRECTION_OUTPUT);
    XGpioPs_SetOutputEnablePin(&xGpio, partstLED_OUTPUT, partstOUTPUT_ENABLED);
    XGpioPs_WritePin(&xGpio, partstLED_OUTPUT, 0x0);

    /* The Xilinx projects use a BSP that do not allow the start up code
       to be altered easily.  Therefore the vector table used by FreeRTOS
       is defined in FreeRTOS_asm_vectors.S, which is part of this project.
       Switch to use the FreeRTOS vector table. */
    vPortInstallFreeRTOSVectorTable();
}

/* ---------------------------------------------------------------------- */
/*  The following function is a thread that toggles LED on the ZedBoard.  */
/* --------------=------------------------------------------------------- */
void led_ctrl(void *pvParameters)
{
    TickType_t xNextWakeTime;
    int *pDone = (int *) pvParameters;

    xNextWakeTime = xTaskGetTickCount();

    while (! *pDone) /* app_done is false */
    {
        /* Wake up this task every second. */
        vTaskDelayUntil( &xNextWakeTime, configTICK_RATE_HZ);

        /*  Toggle the LED. */
        vToggleLED();
    }

    /* The thread has ended, we must delete this task from the task queue. */
    vTaskDelete(NULL);
}

/* ----------------------------------------------------------------- */
/*  The following functions are user-defined call-back routines      */
/*  for FreeRTOS. These functions are invoked by the FreeRTOS kernel */
/*  when things goes wrong.                                          */
/*                                                                   */
/*  Here, we only provide empty templates for these call-back funcs. */
/* ----------------------------------------------------------------- */

/* ----------------------------------------------------------------- */
void vApplicationMallocFailedHook(void)
{
    /*
       Called if a call to pvPortMalloc() fails because there is
       insufficient free memory available in the FreeRTOS heap.
       The size of the FreeRTOS heap is set by the configTOTAL_HEAP_SIZE
       configuration constant in FreeRTOSConfig.h.
     */
	xil_printf("STACK OVERFLOW!\n");
    taskDISABLE_INTERRUPTS();
    for (;;);
}

/* ----------------------------------------------------------------- */
void vApplicationStackOverflowHook(TaskHandle_t pxTask, char *pcTaskName)
{
    (void) pcTaskName;
    (void) pxTask;

    /* Run time stack overflow checking is performed if
       configCHECK_FOR_STACK_OVERFLOW is defined to 1 or 2.
       This hook function is called if a stack overflow is detected.
     */
    taskDISABLE_INTERRUPTS();
    for (;;);
}

/* ----------------------------------------------------------------- */
void vApplicationIdleHook(void)
{
    /* This is just a trivial example of an idle hook.
       It is called on each cycle of the idle task.  It must
       *NOT* block the processor.
     */
}

/* ----------------------------------------------------------------- */
void vApplicationTickHook(void)
{
	/* This function is called from the timer ISR. You can put
	   periodic maintenance operations here. However, the function
	   must be very short, not use much stack, and not call any
	   kernel API functions that don't end in "FromISR" or "FROM_ISR"
	 */
}

/* ----------------------------------------------------------------- */
void vAssertCalled(const char *pcFile, unsigned long ulLine)
{
    volatile unsigned long ul = 0;

    (void) pcFile;
    (void) ulLine;

    taskENTER_CRITICAL();
    {
        /* Set ul to a non-zero value using the debugger to step
           out of this function.
         */
        while (ul == 0)
        {
            portNOP();
        }
    }
    taskEXIT_CRITICAL();
}

/* ----------------------------------------------------------------- */
void vInitialiseTimerForRunTimeStats( void )
{
    XScuWdt_Config *pxWatchDogInstance;
    uint32_t ulValue;
    const uint32_t ulMaxDivisor = 0xff, ulDivisorShift = 0x08;

    pxWatchDogInstance = XScuWdt_LookupConfig( XPAR_SCUWDT_0_DEVICE_ID );
    XScuWdt_CfgInitialize( &xWatchDogInstance, pxWatchDogInstance, pxWatchDogInstance->BaseAddr );

    ulValue = XScuWdt_GetControlReg( &xWatchDogInstance );
    ulValue |= ulMaxDivisor << ulDivisorShift;
    XScuWdt_SetControlReg( &xWatchDogInstance, ulValue );

    XScuWdt_LoadWdt( &xWatchDogInstance, UINT_MAX );
    XScuWdt_SetTimerMode( &xWatchDogInstance );
    XScuWdt_Start( &xWatchDogInstance );
}

/* ----------------------------------------------------------------- */
/*  LED light control functions.                                     */
/* ----------------------------------------------------------------- */
void vSetLED(BaseType_t xValue)
{
    XGpioPs_WritePin(&xGpio, partstLED_OUTPUT, xValue);
}

void vToggleLED()
{
    BaseType_t xLEDState;

    xLEDState = XGpioPs_ReadPin(&xGpio, partstLED_OUTPUT);
    XGpioPs_WritePin(&xGpio, partstLED_OUTPUT, !xLEDState);
}
