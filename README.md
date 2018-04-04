# Simulated Page Allocation Manager (SPAM)


Write a program that simulates the operation of a binary executable loader on a system that uses paging mechanism to manage its memory. The simulated hardware has the following characteristics:
* 4K bytes of physical RAM
* page/frame size of 512 bytes
* Process logical address space is partitioned similar to that described in Lab 9. Howe er, this project only considers the text/code and data segments.
* The logical address space of the simulated processes is partitioned. However, this project only considers the text/code and data segements (stack and heap are ignored)

The memory manager simulation will proceed approximately as described below:
* Your program (simulating the OS loader) is presented with the size of code and data segments of an executable to be loaded to memory
* Given the page size of 512 bytes, the loader determines the number of pages for code and data segments. Note: they are mapped separately, i.e. your simulation program shall use two page tables per process: one for mapping pages of the text/code segment, and another one for data segment
* Like an OS, your simulation program creates these page table structures for each process required to map logical page numbers to physical frame numbers.
* It then inspects the list of free frames and allocate the number of required frames in the simulated RAM, claim these frames on behalf of the process.
* It then updates the page table and list of free frames accordingly.

* Your simulation program shall then display the process page tables showing the mapping of pages to frames for that process.
* Your simulation program must also display the page frame table (showing the memory map of physical memory and its contents)
* When a program terminates, all physical frames allocated to the process are reclaimed by the (simulated) OS, its page table is disposed and other relevant data structures are updated
* Your memory manager shall be able to simulate a multiprogramming system, where several processes can be resident in the simulated physical memory. The "execution sequence" of these simulated processed will be provided from an trace tape input file. Each line in the trace tape specifies either arrival or termination of a process.
* Process arrival is encoded as three integers separated by a space:
`pid codesize datasize`
where sizes are in given bytes.
Process termination is encoded as two integers (not three) separated by a space with the second number being -1
`pid -1`
On each program arrival and termination, your simulation program shall update the memory layout of the simulated RAM.
