//
//  RupturaTests.swift
//  RupturaTests
//
//  Created by Stevie Hetelekides on 2/16/15.
//  Copyright (c) 2015 Expetelek. All rights reserved.
//

import UIKit
import Ruptura
import XCTest

class RupturaTests: XCTestCase
{
    func testLittleEndianRead()
    {
        let path = NSBundle.mainBundle().pathForResource("test", ofType: nil)
        XCTAssertNotNil(path, "Couldn't get path")
        
        let file = FileIO(filePath: path!)
        XCTAssertTrue(file.isOpen, "Couldn't open file")
        
        file.endianType = .LittleEndian
        
        let firstInt = file.readInt32()
        XCTAssertEqual(Int32(0x11223344), firstInt, "first int32 read failed")
        
        let secondInt = file.readInt32()
        XCTAssertEqual(Int32(0x55667788), secondInt, "second int32 read failed")
        
        file.position = 0
        let firstIntAgain = Int(file.readInt32())
        XCTAssertEqual(0x11223344, firstIntAgain, "position set failed")
    
        let firstInt16 = file.readInt16()
        XCTAssertEqual(Int16(0x5566), firstInt16, "first int16 read failed")
        
        let firstInt64 = file.readInt64()
        XCTAssertEqual(Int64(0x778899AABBCCDDEE), firstInt64, "first int64 read failed")
        
        file.position = 0
        let firstUInt = file.readUInt32()
        XCTAssertEqual(UInt32(0x11223344), firstUInt, "first uint32 read failed")
        
        let secondUInt = file.readUInt32()
        XCTAssertEqual(UInt32(0x55667788), secondUInt, "second uint32 read failed")
        
        file.position = 0
        let firstUIntAgain = Int(file.readInt32())
        XCTAssertEqual(0x11223344, firstUIntAgain, "position set failed")
        
        let firstUInt16 = file.readUInt16()
        XCTAssertEqual(UInt16(0x5566), firstUInt16, "first uint16 read failed")
        
        let firstUInt64 = file.readUInt64()
        XCTAssertEqual(UInt64(0x778899AABBCCDDEE), firstUInt64, "first uint64 read failed")
    }
    
    func testMachOHeaderRead()
    {
        let path = NSBundle.mainBundle().pathForResource("SpringBoard", ofType: nil)
        XCTAssertNotNil(path, "Couldn't get path")
        
        let macho = MachO(filePath: path!)
        
        XCTAssertEqual(macho.header.cpuType.rawValue, CPUType.ARM64.rawValue, "Incorrect CPUType")
        XCTAssertEqual(macho.header.cpuSubtype, UInt32(0), "Incorrect CPUSubType")
        XCTAssertEqual(macho.header.fileType.rawValue, FileType.Execute.rawValue, "Incorrect FileType")
        XCTAssertEqual(macho.header.numberOfCommands, UInt32(0x88), "Incorrect number of commands")
        XCTAssertEqual(macho.header.sizeOfCommands, UInt32(0x3690), "Incorrect size of commands")
        XCTAssertEqual(macho.header.flags, UInt32(0x200085), "Incorrect flags value")
        XCTAssertEqual(macho.header.reserved, UInt32(0), "Incorrect reserve value")
    }
    
    func testMachOLoadCommands()
    {
        let path = NSBundle.mainBundle().pathForResource("SpringBoard", ofType: nil)
        XCTAssertNotNil(path, "Couldn't get path")
        
        var mainCommand: Ruptura.MainCommand?
        var textSegmentCommand: Ruptura.Segment64Command?
        
        let macho = MachO(filePath: path!)
        for command in macho.loadCommands
        {
            if let segment = command as? Ruptura.Segment64Command
            {
                if segment.segmentName == "__TEXT"
                {
                    textSegmentCommand = segment
                }
                
                println("\(segment.segmentName) @ 0x\(String(segment.fileOffset, radix: 16))")
                if segment.initialProtections & 1 == 1
                {
                    println("\t* READ")
                }
                if segment.initialProtections & 2 == 2
                {
                    println("\t* WRITE")
                }
                if segment.initialProtections & 4 == 4
                {
                    println("\t* EXECUTE")
                }
                println()
                
                for section in segment.sections
                {
                    println("\t\(section.sectionName) : 0x\(String(section.fileOffset, radix: 16))")
                }
            }
            else if let main = command as? Ruptura.MainCommand
            {
                mainCommand = main
            }
        }
        
        if mainCommand != nil && textSegmentCommand != nil
        {
            let entryPointVM: UInt64 = mainCommand!.entryOffset + textSegmentCommand!.virtualMemoryStartAddress
            let entryPointFile: UInt64 = mainCommand!.entryOffset + textSegmentCommand!.fileOffset
            
            println("stack size = \(mainCommand!.stackSize)")
            println("file entry point = 0x\(String(entryPointFile, radix: 16))")
            println("vm entry point = 0x\(String(entryPointVM, radix: 16))")
        }
    }
}
