GPIOE_CRH 		EQU 	0x40011804
RCC_APB2ENR 	EQU 	0x40021018
GPIOE_ODR 		EQU 	0x4001180c
DELAY			EQU		0xF4240
GPIOB_IDR		EQU		0x40010c08
GPIOB_CRL		EQU		0x40010c00
	AREA RESET, DATA, READONLY
	EXPORT __Vectors
__Vectors
				DCD 0x20000200
				DCD Reset_Handler

	AREA |.text|, CODE, READONLY
	EXPORT Reset_Handler
;
Reset_Handler PROC
	mov r6,#0x48		;enable clock to port E and B
	ldr r7,=RCC_APB2ENR
	str r6,[r7]
	mov r6,#0x33333333 	;configure port E - o/p to LEDs
	ldr r7,=GPIOE_CRH
	str r6,[r7]
	mov r6,#0x40000000      ;configure port B - input user switch
	ldr r7,=GPIOB_CRL	
	str r6,[r7]

CLoop
	ldr r6,=GPIOB_IDR
	mov r5,#0x0000F710
	ldr r7,[r6]		;reading switch press
	cmp r5,r7		;when button is pressed, GPIOB_IDR will be 0x80
	beq flashFour
return
	mov r6,#0xf000		; turn upper 4 LEDs on
	ldr r7,=GPIOE_ODR
	str r6,[r7]
	bl delay 
	mov r6,#0x0000		; turn upper 4 LEDs off
	ldr r7,=GPIOE_ODR
	str r6,[r7]
	bl delay
	b CLoop
flashFour
	mov r6,#0x0f00		; turn upper 4 LEDs on
	ldr r7,=GPIOE_ODR
	str r6,[r7]
	bl delay
	mov r6,#0x0000		; turn upper 4 LEDs off
	ldr r7,=GPIOE_ODR
	str r6,[r7]
	bl delay
	ldr r6,=GPIOB_IDR
	mov r5,#0x80
	ldr r7,[r6]		;reading switch press
	tst r5,r7		;when button is pressed, GPIOB_IDR will be 0x80
	beq flashFour
	b return
delay
	ldr r0,=DELAY
delayLoop
	adds r0,#-1
	bne delayLoop
	bx lr

ENDP
END