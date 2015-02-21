//
//  MachO.swift
//  Ruptura
//
//  Created by Stevie Hetelekides on 2/16/15.
//  Copyright (c) 2015 Expetelek. All rights reserved.
//

import Foundation

public class MachO
{
    private var file: FileIO
    public private(set) var header: Header64
    public private(set) var loadCommands: [AnyObject]
    
    public init(filePath: String)
    {
        self.file = FileIO(filePath: filePath)
        
        self.header = Header64()
        
        // get/set endian type
        self.header.magic = Magic(rawValue: self.file.readUInt32())
        switch self.header.magic!
        {
        case .cigaM64:
            file.endianType = .LittleEndian
        case .Magic64:
            file.endianType = .BigEndian
        }
        
        // read header
        self.header.cpuType = CPUType(rawValue: self.file.readUInt32())!
        self.header.cpuSubtype = self.file.readUInt32()
        self.header.fileType = FileType(rawValue: self.file.readUInt32())!
        self.header.numberOfCommands = self.file.readUInt32()
        self.header.sizeOfCommands = self.file.readUInt32()
        self.header.flags = self.file.readUInt32()
        self.header.reserved = self.file.readUInt32()
        
        // read load commands
        self.loadCommands = [ ]
        for _ in 0..<self.header.numberOfCommands
        {
            let commandStartPosition = self.file.position
            
            // read type
            let commandTypeRawValue = self.file.readUInt32()
            if let commandType = LoadCommandType(rawValue: commandTypeRawValue)?
            {
                // parse command based on type
                switch (commandType)
                {
                case .Segment64:
                    var segment64 = Segment64Command(io: self.file)
                    self.loadCommands.append(segment64)
                    
                case .LoadDylib:
                    let loadDylib = LoadDylibCommand(io: self.file)
                    self.loadCommands.append(loadDylib)
                    
                case .LoadWeakDylib:
                    let loadWeakDylib = LoadWeakDylibCommand(io: self.file)
                    self.loadCommands.append(loadWeakDylib)
                    
                case .DyldInfoOnly:
                    let dyldInfo = DyldInfo(io: self.file)
                    self.loadCommands.append(dyldInfo)
                    
                case .VersionMinIPhoneOS:
                    let versionMinIPhoneOS = VersionMinIPhoneOSCommand(io: self.file)
                    self.loadCommands.append(versionMinIPhoneOS)
                
                case .VersionMinMacOSX:
                    let versionMinMacOSX = VersionMinMacOSXCommand(io: self.file)
                    self.loadCommands.append(versionMinMacOSX)
                    
                case .SourceVersion:
                    let sourceVersion = SourceVersionCommand(io: self.file)
                    self.loadCommands.append(sourceVersion)
                    
                case .Symtab:
                    let symtab = SymtabCommand(io: self.file)
                    self.loadCommands.append(symtab)
                    
                case .UUID:
                    let uuid = UUIDCommand(io: self.file)
                    self.loadCommands.append(uuid)
                    
                case .Dysymtab:
                    let dysymtab = DysymtabCommand(io: self.file)
                    self.loadCommands.append(dysymtab)
                    
                case .LoadDylinker:
                    let dylinker = LoadDylinkerCommand(io: self.file)
                    self.loadCommands.append(dylinker)
                    
                case .CodeSignature:
                    let codeSignature = CodeSignatureCommand(io: self.file)
                    self.loadCommands.append(codeSignature)
                    
                case .DataInCode:
                    let dataInCode = DataInCodeCommand(io: self.file)
                    self.loadCommands.append(dataInCode)
                    
                case .DylibCodeSignDrs:
                    let dylibCodeSignDrs = DylibCodeSignDrsCommand(io: self.file)
                    self.loadCommands.append(dylibCodeSignDrs)
                    
                case .FunctionStarts:
                    let functionStarts = FunctionStartsCommand(io: self.file)
                    self.loadCommands.append(functionStarts)
                    
                case .Main:
                    let main = MainCommand(io: self.file)
                    self.loadCommands.append(main)
                    
                default:
                    let commandSize = self.file.readUInt32()
                    self.file.position = commandStartPosition + UInt64(commandSize)
                    println("WARNING: Load command type \(commandType) not supported at 0x\(String(commandStartPosition, radix: 16))")
                }
            }
            else
            {
                fatalError("Unknown command type: 0x\(String(commandTypeRawValue, radix: 16)) at 0x\(String(self.file.position, radix: 16))")
            }
        }
    }
}