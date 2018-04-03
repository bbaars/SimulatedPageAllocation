//
//  RAM.swift
//  SimulatedPageAllocation
//
//  Created by Brandon Baars on 4/3/18.
//  Copyright © 2018 Brandon Baars. All rights reserved.
//

import Foundation

class RAM {
    
    public var RAM: [Frame]
    private var RAMSize: Int
    
    init(sizeOfRam size: Int) {
        
        RAM = [Frame]()
        RAMSize = size
        
        for index in 0..<size {
            let newFrame = Frame(frameSize: 512.0, isOccupied: false, index: index, type: .empty, data: nil)
            RAM.append(newFrame)
        }
    }
    
    public func addProcessToRam(withProcess process: ProcessData) {
        
        // check amount of frames needed vs. what's actually free
        let totalFrames = process.numOfDataPages + process.numOfCodePages
        let freeFrames = self.RAM.filter {!$0.isOccupied}
        
        var codeCount = 0
        var dataCount = 0
        
        if freeFrames.count < totalFrames {
            return
        } else {
            for (index, frame) in freeFrames.enumerated() {
                if index >= totalFrames {
                    break
                } else {
                    RAM[frame.index].isOccupied = true
                    RAM[frame.index].data = process
                    
                    if codeCount < process.numOfCodePages {
                        RAM[frame.index].type = .code
                        process.addFrameToPageTable(withFrame: RAM[frame.index])
                        codeCount += 1
                    } else {
                        RAM[frame.index].type = .data
                        process.addFrameToPageTable(withFrame: RAM[frame.index])
                        dataCount += 1
                    }
                }
            }
        }
    }
    
    public func resetRAM() {
        for index in 0..<RAMSize {
            RAM[index].resetFrame(withIndex: index)
        }
    }
}
