//
//  FileIO.swift
//  Ruptura
//
//  Created by Stevie Hetelekides on 2/16/15.
//  Copyright (c) 2015 Expetelek. All rights reserved.
//

import Foundation

public class FileIO : BaseIO
{
    public private(set) var filePath: String
    private var file: NSFileHandle?
    public var isOpen : Bool
    {
        get
        {
            return self.file != nil
        }
    }
    
    override public var position: UInt64
    {
        get
        {
            if let file = self.file
            {
                return file.offsetInFile
            }
            
            return UInt64.max
        }
        set
        {
            if let file = self.file
            {
                file.seekToFileOffset(newValue)
            }
        }
    }
    
    public init(filePath: String)
    {
        self.filePath = filePath
        self.file = NSFileHandle(forReadingAtPath: self.filePath)
    }
    
    override public func readBytes(count: Int) -> [Byte]
    {
        if let data = file?.readDataOfLength(count)
        {
            let count = data.length / sizeof(Byte)
            var array = [Byte](count: count, repeatedValue: 0)
            data.getBytes(&array, length: count * sizeof(Byte))
            
            if self.endianType == .LittleEndian
            {
                array = reverse(array)
            }
            
            return array
        }
        
        return [ ]
    }
    
    override public func close()
    {
        self.file?.closeFile()
        self.file = nil
    }
}
