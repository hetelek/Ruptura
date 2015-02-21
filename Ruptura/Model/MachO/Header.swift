//
//  Header.swift
//  Ruptura
//
//  Created by Stevie Hetelekides on 2/16/15.
//  Copyright (c) 2015 Expetelek. All rights reserved.
//

import Foundation

public enum Magic : UInt32
{
    case Magic64 = 0xFEEDFACF
    case cigaM64 = 0xCFFAEDFE
}

public enum CPUType : UInt32
{
    case x86 = 0x7
    case x86_64 = 0x1000007
    case ARM = 0xC
    case ARM64 = 0x100000C
}

public enum FileType : UInt32
{
    case Object = 0x1
    case Execute = 0x2
    case Core = 0x4
    case Preload = 0x5
    case Dylib = 0x6
    case Dylinker = 0x7
    case Bundle = 0x8
    case dSYM = 0xA
}

public struct Header64
{
    public var magic: Magic!
    public var cpuType: CPUType!
    public var cpuSubtype: UInt32!
    public var fileType: FileType!
    public var numberOfCommands: UInt32!
    public var sizeOfCommands: UInt32!
    public var flags: UInt32!
    public var reserved: UInt32!
    
    init() { }
}
