//
//  BaseIO.swift
//  Ruptura
//
//  Created by Stevie Hetelekides on 2/16/15.
//  Copyright (c) 2015 Expetelek. All rights reserved.
//

import Foundation

public enum EndianType
{
    case BigEndian, LittleEndian
}

public class BaseIO
{
    public var endianType: EndianType = .BigEndian
    public var position: UInt64
        {
        get
        {
            fatalError("Must implement position get property from BaseIO subclass")
        }
        set
        {
            fatalError("Must implement position set property from BaseIO subclass")
        }
    }
    
    public func readBytes(count: Int) -> [Byte]
    {
        fatalError("Must implement readBytes from BaseIO subclass")
    }
    
    public func writeBytes(data: [Byte]) -> Int
    {
        fatalError("Must implement writeBytes from BaseIO subclass")
    }
    
    public func close()
    {
        fatalError("Must implement close from BaseIO subclass")
    }
    
    public func readByte() -> Byte
    {
        return readBytes(1)[0]
    }
    
    public func readInt16() -> Int16
    {
        return UnsafePointer<Int16>(readBytes(2)).memory
    }
    
    public func readUInt16() -> UInt16
    {
        return UnsafePointer<UInt16>(readBytes(2)).memory
    }
    
    public func readInt32() -> Int32
    {
        return UnsafePointer<Int32>(readBytes(4)).memory
    }
    
    public func readUInt32() -> UInt32
    {
        return UnsafePointer<UInt32>(readBytes(4)).memory
    }
    
    public func readInt64() -> Int64
    {
        return UnsafePointer<Int64>(readBytes(8)).memory
    }
    
    public func readUInt64() -> UInt64
    {
        return UnsafePointer<UInt64>(readBytes(8)).memory
    }
    
    public func readString(encoding: NSStringEncoding = NSASCIIStringEncoding) -> String
    {
        var bytes = [Byte]()
        while true
        {
            let byte = self.readByte()
            
            // check if byte is null
            if byte == 0x00
            {
                return String(bytes: bytes, encoding: encoding)!
            }
            
            bytes.append(byte)
        }
    }
    
    public func readString(length: Int, encoding: NSStringEncoding = NSASCIIStringEncoding) -> String
    {
        var bytes = [Byte]()
        for i in 1...length
        {
            let byte = self.readByte()
            
            // check if byte is null
            if byte == 0x00
            {
                self.position += length - i
                break
            }
            
            bytes.append(byte)
        }
        
        return String(bytes: bytes, encoding: encoding)!
    }
    
    deinit
    {
        self.close()
    }
}
