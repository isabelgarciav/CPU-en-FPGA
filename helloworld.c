/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */
#include <stdio.h>
#include <stdint.h>
#include "platform.h"
#include "xil_printf.h"
#include "xaxidma.h"
#include "tinycpu.h"

#define MEM_BASE_ADDR 0x01000000
#define TX_BUFFER_BASE (MEM_BASE_ADDR + 0x00100000)
#define BASEADDR_P XPAR_TINYCPU_0_S_AXI_RF_BASEADDR
#define NUM_REG 16

XAxiDma axiDMA;
XAxiDma_Config *axiDMA_cfg;

uint32_t *regaddr_p = (uint32_t *)BASEADDR_P;


// Función para imprimir números en binario
void binaryPrint(int num_dec) {
   for (int i = 15; i >= 0; --i) {
       printf("%d", (num_dec >> i) & 1);
   }
}

int main() {
   int operation, operand1, operand2;
   int *m_dma_buffer_TX = (int*) TX_BUFFER_BASE;

   xil_printf("TinyCPU Calculator\r\n");

   // Inicializar DMA
   printf("Initializing AxiDMA\r\n");
   axiDMA_cfg = XAxiDma_LookupConfig(XPAR_AXIDMA_0_DEVICE_ID);
   if (axiDMA_cfg) {
       int status = XAxiDma_CfgInitialize(&axiDMA, axiDMA_cfg);
       if (status != XST_SUCCESS) {
           printf("Error initializing AxiDMA core\r\n");
           return -1;
       }
   }

   XAxiDma_IntrDisable(&axiDMA, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
   XAxiDma_IntrDisable(&axiDMA, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DMA_TO_DEVICE);

   while (1) {
       printf("\nSeleccione la operación:\n");
       printf("1. Suma\n2. Resta\n3. AND\n4. OR\n5. Salir\n");
       scanf("%d", &operation);

       if (operation == 5) {
           printf("Saliendo de la calculadora.\n");
           break;
       }

       printf("Ingrese el primer operando (entero): ");
       scanf("%d", &operand1);
       printf("Ingrese el segundo operando (entero): ");
       scanf("%d", &operand2);

       // Generar instrucciones para la TinyCPU
       m_dma_buffer_TX[0] = (0b0100000000000000 | (operand1 & 0xFF)); // LD reg0, operand1
       m_dma_buffer_TX[1] = (0b0100000100000000 | (operand2 & 0xFF)); // LD reg1, operand2

       switch (operation) {
           case 1: // Suma
               m_dma_buffer_TX[2] = 0b1111001000000001; // ADD reg2, reg0, reg1
               break;
           case 2: // Resta
               m_dma_buffer_TX[2] = 0b1101001100000001; // SUB reg3, reg0, reg1
               break;
           case 3: // AND
               m_dma_buffer_TX[2] = 0b1011010000000001; // AND reg4, reg0, reg1
               break;
           case 4: // OR
               m_dma_buffer_TX[2] = 0b1001010100000001; // OR reg5, reg0, reg1
               break;
           default:
               printf("Operación no válida.\n");
               continue;
       }

       // Transferir instrucciones a la TinyCPU
       Xil_DCacheFlushRange((u32)m_dma_buffer_TX, 3 * sizeof(int));
       printf("Enviando instrucciones a la TinyCPU...\n");
       XAxiDma_SimpleTransfer(&axiDMA, (u32)m_dma_buffer_TX, 3 * sizeof(int), XAXIDMA_DMA_TO_DEVICE);
       while (XAxiDma_Busy(&axiDMA, XAXIDMA_DMA_TO_DEVICE));

       // Leer el resultado
       printf("Resultado:\n");
       switch (operation) {
           case 1:
               printf("Suma: ");
               binaryPrint(regaddr_p[2]); // reg2 contiene el resultado de la suma
               printf(" (%d)\n", regaddr_p[2]);
               break;
           case 2:
               printf("Resta: ");
               binaryPrint(regaddr_p[3]); // reg3 contiene el resultado de la resta
               printf(" (%d)\n", regaddr_p[3]);
               break;
           case 3:
               printf("AND: ");
               binaryPrint(regaddr_p[4]); // reg4 contiene el resultado del AND
               printf(" (%d)\n", regaddr_p[4]);
               break;
           case 4:
               printf("OR: ");
               binaryPrint(regaddr_p[5]); // reg5 contiene el resultado del OR
               printf(" (%d)\n", regaddr_p[5]);
               break;
       }
   }

   xil_printf("End of program\r\n");
   return 0;
}

