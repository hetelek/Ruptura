//
//  LoadCommands.swift
//  Ruptura
//
//  Created by Stevie Hetelekides on 2/17/15.
//  Copyright (c) 2015 Expetelek. All rights reserved.
//

import Foundation

public enum LoadCommandType : UInt32, Printable
{
    case Segment = 0x1
    case Symtab = 0x2
    case Thread = 0x4
    case UnixThread = 0x5
    case Dysymtab = 0xB
    case LoadDylib = 0xC
    case LoadDylinker = 0xE
    case IdDylinker = 0xF
    case PreboundDylib = 0x10
    case Routines = 0x11
    case SubFramework = 0x12
    case SubUmbrella = 0x13
    case SubClient = 0x14
    case SubLibrary = 0x15
    case TwoLevelHints = 0x16
    case Segment64 = 0x19
    case Routines64 = 0x1A
    case UUID = 0x1B
    case CodeSignature = 0x1D
    case VersionMinMacOSX = 0x24
    case VersionMinIPhoneOS = 0x25
    case FunctionStarts = 0x26
    case DataInCode = 0x29
    case SourceVersion = 0x2A
    case DylibCodeSignDrs = 0x2B
    case LoadWeakDylib = 0x80000018
    case DyldInfoOnly = 0x80000022
    case Main = 0x80000028
    
    public var description : String
    {
        get
        {
            switch self
            {
            case Segment:
                return "Segment"
            case Symtab:
                return "Symtab"
            case Thread:
                return "Thread"
            case UnixThread:
                return "UnixThread"
            case Dysymtab:
                return "Dysymtab"
            case LoadDylib:
                return "LoadDylib"
            case LoadDylinker:
                return "LoadDylinker"
            case IdDylinker:
                return "IdDylinker"
            case PreboundDylib:
                return "PreboundDylib"
            case Routines:
                return "Routines"
            case SubFramework:
                return "SubFramework"
            case SubUmbrella:
                return "SubUmbrella"
            case SubClient:
                return "SubClient"
            case SubLibrary:
                return "SubLibrary"
            case TwoLevelHints:
                return "TwoLevelHints"
            case Segment64:
                return "Segment64"
            case Routines64:
                return "Routines64"
            case UUID:
                return "UUID"
            case VersionMinMacOSX:
                return "VersionMinMacOSX"
            case VersionMinIPhoneOS:
                return "VersionMinIPhoneOS"
            case FunctionStarts:
                return "FunctionStarts"
            case DataInCode:
                return "DataInCode"
            case SourceVersion:
                return "SourceVersion"
            case DylibCodeSignDrs:
                return "DylibCodeSignDrs"
            case CodeSignature:
                return "CodeSignature"
            case LoadWeakDylib:
                return "LoadWeakDylib"
            case DyldInfoOnly:
                return "DyldInfoOnly"
            case Main:
                return "Main"
            }
        }
    }
}

public class UUIDCommand
{
    public var command: LoadCommandType
    {
        get
        {
            return LoadCommandType.UUID
        }
    }
    public var commandSize: UInt32!
    
    public var uuid: String!
    
    init(io: BaseIO)
    {
        // read uuid
        self.commandSize = io.readUInt32()
        self.uuid = io.readString(16)
    }
}

public class SymtabCommand
{
    public var command: LoadCommandType
    {
        get
        {
            return LoadCommandType.Symtab
        }
    }
    public var commandSize: UInt32
    
    public var symbolTableOffset: UInt32
    public var numberOfEntries: UInt32
    public var stringTableOffset: UInt32
    public var stringTableSize: UInt32
    
    init (io: BaseIO)
    {
        // read symtab
        self.commandSize = io.readUInt32()
        self.symbolTableOffset = io.readUInt32()
        self.numberOfEntries = io.readUInt32()
        self.stringTableOffset = io.readUInt32()
        self.stringTableSize = io.readUInt32()
    }
}

public class Segment64Command
{
    public var command: LoadCommandType
    {
        get
        {
            return LoadCommandType.Segment64
        }
    }
    public var commandSize: UInt32
    
    public var segmentName: String
    public var virtualMemoryStartAddress: UInt64
    public var virtualMemorySize: UInt64
    public var fileOffset: UInt64
    public var fileSize: UInt64
    public var maxProtections: Int32
    public var initialProtections: Int32
    public var numberOfSections: UInt32
    public var flags: UInt32
    
    public var sections: [Section64]
    
    init(io: BaseIO)
    {
        // read segment 64 load command
        self.commandSize = io.readUInt32()
        self.segmentName = io.readString(16)
        self.virtualMemoryStartAddress = io.readUInt64()
        self.virtualMemorySize = io.readUInt64()
        self.fileOffset = io.readUInt64()
        self.fileSize = io.readUInt64()
        self.maxProtections = io.readInt32()
        self.initialProtections = io.readInt32()
        self.numberOfSections = io.readUInt32()
        self.flags = io.readUInt32()
        
        // read all sections in this segment
        var sections: [Section64] = [ ]
        for _ in 0..<self.numberOfSections
        {
            // add to sections array
            var section: Section64 = Section64(io: io)
            sections.append(section)
        }
        
        self.sections = sections
    }
}

public class LoadDylibCommand
{
    public var command: LoadCommandType
    {
        get
        {
            return LoadCommandType.LoadDylib
        }
    }
    public var commandSize: UInt32
    
    public var offset: UInt32
    public var timestamp: UInt32
    public var currentVersion: UInt32
    public var compatibilityVersion: UInt32
    public var name: String
    
    init(io: BaseIO)
    {
        // calculate start position
        let commandStartPosition = io.position - 0x4
        
        // read load dylib command
        self.commandSize = io.readUInt32()
        self.offset = io.readUInt32()
        self.timestamp = io.readUInt32()
        self.currentVersion = io.readUInt32()
        self.compatibilityVersion = io.readUInt32()
        
        // set position of name
        io.position = commandStartPosition + UInt64(self.offset)
        
        // calculate name length, read name
        let nameLength: Int = commandSize - 0x18
        self.name = io.readString(nameLength)
    }
}

public class LoadWeakDylibCommand : LoadDylibCommand
{
    override public var command: LoadCommandType
    {
        get
        {
            return LoadCommandType.LoadWeakDylib
        }
    }
}

public class DysymtabCommand
{
    public var command: LoadCommandType
    {
        get
        {
            return LoadCommandType.Dysymtab
        }
    }
    public var commandSize: UInt32
    
    public var localGroupFirstSymbolIndex: UInt32
    public var localGroupSymbolCount: UInt32
    public var definedExternalGroupFirstSymbolIndex: UInt32
    public var definedExternalGroupSymbolCount: UInt32
    public var undefinedExternalGroupFirstSymbolIndex: UInt32
    public var undefinedExternalGroupSymbolCount: UInt32
    public var tableOfContentsOffset: UInt32
    public var tableOfContentsEntryCount: UInt32
    public var moduleTableDataOffset: UInt32
    public var moduleTableDataEntryCount: UInt32
    public var externalReferenceTableOffset: UInt32
    public var externalReferenceTableEntryCount: UInt32
    public var indirectSymbolTableOffset: UInt32
    public var indirectSymbolTableEntryCount: UInt32
    public var externalRelocationTableOffset: UInt32
    public var externalRelocationTableEntryCount: UInt32
    public var localRelocationTableOffset: UInt32
    public var localRelocationTableEntryCount: UInt32
    
    init(io: BaseIO)
    {
        // read dysymtab
        self.commandSize = io.readUInt32()
        self.localGroupFirstSymbolIndex = io.readUInt32()
        self.localGroupSymbolCount = io.readUInt32()
        self.definedExternalGroupFirstSymbolIndex = io.readUInt32()
        self.definedExternalGroupSymbolCount = io.readUInt32()
        self.undefinedExternalGroupFirstSymbolIndex = io.readUInt32()
        self.undefinedExternalGroupSymbolCount = io.readUInt32()
        self.tableOfContentsOffset = io.readUInt32()
        self.tableOfContentsEntryCount = io.readUInt32()
        self.moduleTableDataOffset = io.readUInt32()
        self.moduleTableDataEntryCount = io.readUInt32()
        self.externalReferenceTableOffset = io.readUInt32()
        self.externalReferenceTableEntryCount = io.readUInt32()
        self.indirectSymbolTableOffset = io.readUInt32()
        self.indirectSymbolTableEntryCount = io.readUInt32()
        self.externalRelocationTableOffset = io.readUInt32()
        self.externalRelocationTableEntryCount = io.readUInt32()
        self.localRelocationTableOffset = io.readUInt32()
        self.localRelocationTableEntryCount = io.readUInt32()
    }
}

public class LoadDylinkerCommand
{
    public var command: LoadCommandType
    {
        get
        {
            return LoadCommandType.LoadDylinker
        }
    }
    public var commandSize: UInt32
    
    public var offset: UInt32
    public var name: String
    
    init(io: BaseIO)
    {
        // calculate start position
        let commandStartPosition = io.position - 0x4
        
        // read load dylib command
        self.commandSize = io.readUInt32()
        self.offset = io.readUInt32()
        
        // set position of name
        io.position = commandStartPosition + UInt64(self.offset)
        
        // calculate name length, read name
        let nameLength: Int = commandSize - 0xC
        self.name = io.readString(nameLength)
    }
}

public class CodeSignatureCommand
{
    public var command: LoadCommandType
    {
        get
        {
            return LoadCommandType.CodeSignature
        }
    }
    public var commandSize: UInt32
    
    var dataOffset: UInt32
    var dataSize: UInt32
    
    init(io: BaseIO)
    {
        // read code signature
        self.commandSize = io.readUInt32()
        self.dataOffset = io.readUInt32()
        self.dataSize = io.readUInt32()
    }
}

public class FunctionStartsCommand
{
    public var command: LoadCommandType
    {
        get
        {
            return LoadCommandType.FunctionStarts
        }
    }
    public var commandSize: UInt32
    
    var dataOffset: UInt32
    var dataSize: UInt32
    
    init(io: BaseIO)
    {
        // read function starts
        self.commandSize = io.readUInt32()
        self.dataOffset = io.readUInt32()
        self.dataSize = io.readUInt32()
    }
}

public class DataInCodeCommand
{
    public var command: LoadCommandType
    {
        get
        {
            return LoadCommandType.DataInCode
        }
    }
    public var commandSize: UInt32
    
    var dataOffset: UInt32
    var dataSize: UInt32
    
    init(io: BaseIO)
    {
        // read code signature
        self.commandSize = io.readUInt32()
        self.dataOffset = io.readUInt32()
        self.dataSize = io.readUInt32()
    }
}

public class DylibCodeSignDrsCommand
{
    public var command: LoadCommandType
    {
        get
        {
            return LoadCommandType.DylibCodeSignDrs
        }
    }
    public var commandSize: UInt32
    
    var dataOffset: UInt32
    var dataSize: UInt32
    
    init(io: BaseIO)
    {
        // read code signature
        self.commandSize = io.readUInt32()
        self.dataOffset = io.readUInt32()
        self.dataSize = io.readUInt32()
    }
}

public class DyldInfo
{
    public var command: LoadCommandType
    {
        get
        {
            return LoadCommandType.DyldInfoOnly
        }
    }
    public var commandSize: UInt32
    
    var rebaseOffset: UInt32
    var rebaseSize: UInt32
    var bindOffset: UInt32
    var bindSize: UInt32
    var weakBindOffset: UInt32
    var weakBindSize: UInt32
    var lazyBindOffset: UInt32
    var lazyBindSize: UInt32
    var exportOffset: UInt32
    var exportSize: UInt32
    
    init(io: BaseIO)
    {
        // read dyld info
        self.commandSize = io.readUInt32()
        self.rebaseOffset = io.readUInt32()
        self.rebaseSize = io.readUInt32()
        self.bindOffset = io.readUInt32()
        self.bindSize = io.readUInt32()
        self.weakBindOffset = io.readUInt32()
        self.weakBindSize = io.readUInt32()
        self.lazyBindOffset = io.readUInt32()
        self.lazyBindSize = io.readUInt32()
        self.exportOffset = io.readUInt32()
        self.exportSize = io.readUInt32()
    }
}

public class VersionMinIPhoneOSCommand
{
    public var command: LoadCommandType
    {
        get
        {
            return LoadCommandType.VersionMinIPhoneOS
        }
    }
    public var commandSize: UInt32
    
    var version: UInt32
    var sdk: UInt32
    
    init(io: BaseIO)
    {
        // read version min command
        self.commandSize = io.readUInt32()
        self.version = io.readUInt32()
        self.sdk = io.readUInt32()
    }
}

public class VersionMinMacOSXCommand : VersionMinIPhoneOSCommand
{
    override public var command: LoadCommandType
    {
        get
        {
            return LoadCommandType.VersionMinMacOSX
        }
    }
}

public class SourceVersionCommand
{
    public var command: LoadCommandType
        {
        get
        {
            return LoadCommandType.SourceVersion
        }
    }
    public var commandSize: UInt32
    
    var version: UInt64
    
    init(io: BaseIO)
    {
        // read source version
        self.commandSize = io.readUInt32()
        self.version = io.readUInt64()
    }
}

public class MainCommand
{
    public var command: LoadCommandType
    {
        get
        {
            return LoadCommandType.Main
        }
    }
    public var commandSize: UInt32
    public var entryOffset: UInt64
    public var stackSize: UInt64
    
    init(io: BaseIO)
    {
        // read main command
        self.commandSize = io.readUInt32()
        self.entryOffset = io.readUInt64()
        self.stackSize = io.readUInt64()
    }
}

public class Section64
{
    public var sectionName: String
    public var segmentName: String
    public var virtualMemoryStartAddress: UInt64
    public var virtualMemorySize: UInt64
    public var fileOffset: UInt32
    public var align: UInt32
    public var relocationFileOffset: UInt32
    public var numberOfRelocations: UInt32
    public var flags: UInt32
    public var reserved1: UInt32
    public var reserved2: UInt32
    public var reserved3: UInt32
    
    init(io: BaseIO)
    {
        // read section
        self.sectionName = io.readString(16)
        self.segmentName = io.readString(16)
        self.virtualMemoryStartAddress = io.readUInt64()
        self.virtualMemorySize = io.readUInt64()
        self.fileOffset = io.readUInt32()
        self.align = io.readUInt32()
        self.relocationFileOffset = io.readUInt32()
        self.numberOfRelocations = io.readUInt32()
        self.flags = io.readUInt32()
        self.reserved1 = io.readUInt32()
        self.reserved2 = io.readUInt32()
        self.reserved3 = io.readUInt32()
    }
}
