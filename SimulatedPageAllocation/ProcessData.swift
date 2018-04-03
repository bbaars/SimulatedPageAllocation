//
//  ProcessData.swift
//  SimulatedPageAllocation
//
//  Created by Brandon Baars on 4/3/18.
//  Copyright © 2018 Brandon Baars. All rights reserved.
//

import Foundation

enum Type {
    case data
    case code
    case empty
}

class ProcessData {
    
    var numOfDataPages: Int
    var numOfCodePages: Int
    
    var codePageTable = [Int:Frame]()
    var dataPageTable = [Int:Frame]()
    
    var isTerminated: Bool
    var processNumber: Int
    
    var codeLength: Int
    var dataLength: Int
    
    public func toString() -> String {
        return "Loading \(processNumber) into RAM: code=\(codeLength) (\(numOfCodePages) pages) data=\(dataLength) (\(numOfDataPages) pages)"
    }
    
    public func addFrameToPageTable(withFrame frame: Frame) {
        if frame.type == .code {
            codePageTable[frame.index] = frame
            print("Loading Code frame from index: ", frame.index)
        } else {
            dataPageTable[frame.index] = frame
             print("Loading Data frame from index: ", frame.index)
        }
    }
    
    public func removeFromRAM() {
        self.codePageTable.removeAll()
        self.dataPageTable.removeAll()
    }
    
    public func queueProcessForRAM(withFrameSize size: Int) {
        
        let codePages = Int(ceil(Double(self.codeLength)/Double(size)))
        let dataPages = Int(ceil(Double(self.dataLength)/Double(size)))
        
        self.numOfCodePages = codePages
        self.numOfDataPages = dataPages
    }
    
    init(numOfDataPages: Int, numOfCodePages: Int, codePageTable: [Int:Frame], dataPageTable: [Int:Frame], isTerminated: Bool, processNumber: Int, codeLength: Int, dataLength: Int) {
        
        self.numOfDataPages = numOfDataPages
        self.numOfCodePages = numOfCodePages
        self.codePageTable = codePageTable
        self.dataPageTable = dataPageTable
        self.isTerminated = isTerminated
        self.processNumber = processNumber
        self.codeLength = codeLength
        self.dataLength = dataLength
    }
}
