//
//  ViewController.swift
//  SimulatedPageAllocation
//
//  Created by Brandon Baars on 3/27/18.
//  Copyright © 2018 Brandon Baars. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var processTextView: UITextView!
    @IBOutlet weak var processDataTextView: UITextView!
    @IBOutlet var frameLabels: [UILabel]!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var ramStackView: UIStackView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var textPickerView: UIPickerView!
    @IBOutlet weak var frameSizeTextField: UITextField!
    // MARK: - Variables
    var pages: Processes!
    var ram: RAM!
    
    private var testFiles: [String] = ["test1", "test2", "test3", "test4", "test5"]
    private var currentFile: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentFile = testFiles[0]
    
        // Init our 'processes' with the associated file
        pages = Processes(withFilename: currentFile)
        
        // create our RAM
        ram = RAM(sizeOfRam: frameLabels.count)
        
        resetRamLabels()
        nextButton.layer.cornerRadius = 5.0
        resetButton.layer.cornerRadius = 5.0
        
        processTextView.text = pages.textFileData
        processDataTextView.text = ""
        
        textPickerView.delegate = self
        textPickerView.dataSource = self
        
        frameSizeTextField.delegate = self
    }
    
    // MARK: - IBActions
    @IBAction func resetButtonPressed(_ sender: Any) {
        reset()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if !pages.currentProcess.isTerminated {
            pages.currentProcess.queueProcessForRAM(withFrameSize: Int(ram.RAM[0].frameSize))
            
            processDataTextView.text! += pages.currentProcess.toString() + "\n"
            findAvailableRAMFrames(forProcess: pages.currentProcess)
            
            if !pages.toNext() {
               processDataTextView.text! += "End of Program 0\n"
            }
        } else {
            print(pages.currentProcess.toString())
            print("Attempting to remove process: ", pages.currentProcess.processNumber)
            removeProcessFromRAM(process: pages.currentProcess)
            
            if !pages.toNext() {
                processDataTextView.text! += "End of Program 0\n"
            }                
        }
    }
    
    private func reset() {
    
        ram.resetRAM()
        pages.resetProcesses()
        
        processDataTextView.text = ""
        resetRamLabels()
    }
    
    private func removeProcessFromRAM(process: ProcessData) {
        
        if let processToBeRemoved = pages.getProcessFromProcessNumber(pid: process.processNumber) {
            
            let frameCodeIndices = Array(processToBeRemoved.codePageTable.keys)
            let framePageIndices = Array(processToBeRemoved.dataPageTable.keys)
            
            print(processToBeRemoved.toString())
            
            for index in frameCodeIndices {
                print("Removing Index from Code frame: ", index)
                ram.RAM[index].isOccupied = false
                ram.RAM[index].data = nil
                frameLabels[index].text = "Free"
            }
            
            for index in framePageIndices {
                print("Removing Index from Page frame: ", index)
                ram.RAM[index].isOccupied = false
                ram.RAM[index].data = nil
                frameLabels[index].text = "Free"
            }
            
            process.removeFromRAM()
            
            processDataTextView.text! += "Removed Process: \(process.processNumber)\n"
            
        } else {
             print("Could not remove process")
        }
    }
    
    func findAvailableRAMFrames(forProcess process: ProcessData) {
        
        ram.addProcessToRam(withProcess: process)
        
        let frameCodeIndices = Array(process.codePageTable.keys)
        let framePageIndices = Array(process.dataPageTable.keys)
        
        for index in frameCodeIndices {
            processDataTextView.text! += "Loaded Code of process \(process.processNumber) to frame \(index)\n"
            updateRamView(withIndex: index, withString: "Code - \(index) of P\(process.processNumber)")
        }
        
        for index in framePageIndices {
            processDataTextView.text! += "Loaded Data of process \(process.processNumber) to frame \(index)\n"
            updateRamView(withIndex: index, withString: "Data - \(index) of P\(process.processNumber)")
        }
    }
    
    private func updateRamView(withIndex index: Int, withString processString: String) {
        frameLabels[index].text = processString
    }
    
    
    private func resetRamLabels() {
        for label in frameLabels {
            label.text = "Free"
        }
    }
}

extension ViewController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let size = textField.text, let sizeDouble = Double(size) {
            reset()
            pages = nil
            pages = Processes(withFilename: currentFile)
            ram.changeFrameSize(withSize: sizeDouble)
        }
       
        textField.resignFirstResponder()
        return false
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if testFiles[row] == currentFile { return }
        
        currentFile = testFiles[row]
        reset()
        pages = nil
        pages = Processes(withFilename: currentFile)
        processTextView.text = pages.textFileData
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return testFiles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return testFiles.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
}

