//
//  Processes.swift
//  SimulatedPageAllocation
//
//  Created by Brandon Baars on 3/28/18.
//  Copyright © 2018 Brandon Baars. All rights reserved.
//

import Foundation

struct Frame {
    
    var frameSize = 512.0
    var isOccupied: Bool
    var index: Int
    var type: Type
    var data: ProcessData?
    
    public mutating func resetFrame(withIndex index: Int) {
        isOccupied = false
        self.index = index
        type = .empty
        data = nil
    }
    
    public mutating func setFrameSize(newSize size: Double) {
        self.frameSize = size
    }
}

class Processes {

    private(set) var textFileData: String?
    private(set) var processes = [ProcessData]()
    private var currentIndex = 0
    public var currentProcess: ProcessData!
    
    init(withFilename file: String) {
        
        if let path = Bundle.main.path(forResource: file, ofType: ".txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let parsedData = data.replacingOccurrences(of: "\r", with: "")
                textFileData = parsedData
                var lines = parsedData.components(separatedBy: CharacterSet(charactersIn: "\n"))
                lines.removeLast()
                parseLines(withFileContents: lines)

            } catch {
                print ("Error has occured")
            }
        }
        
        currentProcess = processes[0]
        currentIndex = 0
    }
    
    private func parseLines(withFileContents contents: [String]) {
        
        for line in contents {
            var page: ProcessData
            var processLine = line.split(separator: Character(" "))
            if processLine.count > 2 {
                page = ProcessData(numOfDataPages: 0, numOfCodePages: 0, codePageTable: [:], dataPageTable: [:], isTerminated: false, processNumber: Int(processLine[0])!, codeLength: Int(processLine[1])!, dataLength: Int(processLine[2])!)
            } else {
                page = ProcessData(numOfDataPages: 0, numOfCodePages: 0, codePageTable: [:], dataPageTable: [:], isTerminated: true, processNumber: Int(processLine[0])!, codeLength: 0, dataLength: 0)
            }
            processes.append(page)
        }
    }
    
    public func getProcessFromProcessNumber(pid: Int) -> ProcessData? {
        return processes.filter({$0.processNumber == pid && !$0.isTerminated}).first
    }
    
    public func toNext() -> Bool {
        currentIndex += 1
        if currentIndex > (processes.count - 1) { return false }
        let pageData = processes[currentIndex]
        currentProcess = pageData
        return true
    }
    
    public func getNext() -> ProcessData? {
        if currentIndex + 1 > (processes.count - 1) { return nil}
        return processes[currentIndex + 1]
    }
}
