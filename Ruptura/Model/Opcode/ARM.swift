//
//  ARM.swift
//  Ruptura
//
//  Created by Stevie Hetelekides on 2/20/15.
//  Copyright (c) 2015 Expetelek. All rights reserved.
//

import Foundation

enum Opcode : Byte
{
    case AND = 0, EOR, SUB, RSB, ADD, ADC, SBC, RSC
/*
    #define OPCODE_AND	0
    #define OPCODE_EOR	1
    #define OPCODE_SUB	2
    #define OPCODE_RSB	3
    #define OPCODE_ADD	4
    #define OPCODE_ADC	5
    #define OPCODE_SBC	6
    #define OPCODE_RSC	7
    #define OPCODE_TST	8
    #define OPCODE_TEQ	9
    #define OPCODE_CMP	10
    #define OPCODE_CMN	11
    #define OPCODE_ORR	12
    #define OPCODE_MOV	13
    #define OPCODE_BIC	14
    #define OPCODE_MVN	15
*/
}

enum Operand : UInt8
{
    case r0 = 0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15
    case r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, r30, r31
}


enum Type : Byte
{
    case Arithmetic = 0, LDR_STR, BlockBranch, SWI
/*
    #define TYPE_ARITHMETIC		0
    #define TYPE_LDR_STR		1
    #define TYPE_BLOCK_BRANCH	2
    #define TYPE_SWI		3
*/
}

enum ConditionalCode
{
/*
    #define COND_EQ		0
    #define COND_NE		1
    #define COND_CS		2
    #define COND_CC		3
    #define COND_MI		4
    #define COND_PL		5
    #define COND_VS		6
    #define COND_VC		7
    #define COND_HI		8
    #define COND_LS		9
    #define COND_GE		10
    #define COND_LT		11
    #define COND_GT		12
    #define COND_LE		13
    #define COND_AL		14
    #define COND_NV		15
*/
}

/*
class Arithmetic
{
    var operand2 : UInt16	/* #nn or rn or rn shift #m or rn shift rm */
    var destionation: Operand	/* place where the answer goes */
    var operand1: Operand	/* first operand to instruction */
    var setProcessorFlags: Bool	/* == 1 means set processor flags */
    var opcode: Opcode	/* one of OPCODE_* defined above */
    var immediateValue: Bool	/* operand2 is an immediate value */
    var type: Type	/* == TYPE_ARITHMETIC */
    var cond: ConditionalCode	/* one of COND_* defined above */
    
    init()
    {
    }
}
*/