# Pipelined processor
*  A simple 5-stage pipelined processor with Harvard architecture.

## Assembler
* An assembler to convert assembly code for the Instruction Set to its binary representation.

## Instructions details 
![Instruction Image](inst.PNG)

## Opcodes
![opcode Image](op1.PNG)
![opcode Image](op2.PNG)

## Pipelining Hazards
### Structural hazards	
* Writing is done in the first half of the clock and reading is done at the other half
### Data hazards
* Full forwarding
* Stall the pipe in the load-use case

### Control hazards
#### Static Branch Prediction
* Fetch the 2 instructions after the branch instruction. 
* If the branch is taken, flush fetch and decode buffers. 

## Design
![Design Image](design.jpg)

## Contributors
* Dai Alaa
* Dina Alaa
* Kareem Mohamed
* Mohamed Monsef
* Nerdeen Ahmad
