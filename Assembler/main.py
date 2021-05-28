import re
Registers={
    "R0":"0000",
    "R1":"0001",
    "R2":"0010",
    "R3":"0011",
    "R4":"0100",
    "R5":"0101",
    "R6":"0110",
    "R7":"0111",
}

OneOperand={
#One Operand
"NOP": "000000", 
"SETC": "000001", 
"CLRC": "000010",
"CLR": "000011",
"NOT": "000100",
"INC":"000101",
"DEC":"000110",
"NEG":"000111",
"Out": "001000",
"In" : "001001",

#Two Operands
"RLC": "011000",
"RRC": "011001",

#Memory
"PUSH": "100000", 
"POP": "100001",

#Branch
"JZ": "110000", 
"JN": "110001", 
"JC": "110010",
"JMP": "110011",
"CALL": "110100",
"RET": "110101", 
"RTI": "100110",
}


 
TwoOperands={
"MOV": "010000", 
"ADD": "010001", 
"SUB": "010010",
"AND": "010011",
"OR": "010100",

}
Immediate={
"IADD": "010101",
"SHL": "010110",
"SHR": "010111",
"LDM": "100010",
}
Offset={
"LDD": "100011",
"STD": "100100",
}
def ReadFile(path):

    f = open(path, "r")
    txt=f.read()
    txt=txt.upper()
    return txt

file = open("output.txt", "w")
instructions=[]
def Main(Lines):   
    Lines=Lines.split('\n')
    for i in range(len(Lines)):
        Lines[i]=Lines[i].replace(',',' ')
        Lines[i]=Lines[i].replace('(',' ')
        Lines[i]=Lines[i].replace(')',' ')
        combine_whitespave = re.compile(r"\s+")
        my_str = combine_whitespave.sub(" ", Lines[i]).strip()
        instructions.append(my_str.split(' '))
    for i in instructions:
        if i[0] in OneOperand:
            file.write(OneOperand[i[0]]+Registers[i[1]]+"000000"+'\n')
        if i[0] in TwoOperands:
            file.write(TwoOperands[i[0]]+Registers[i[1]]+Registers[i[2]]+"00"+'\n')
        if i[0] in Offset:
            file.write(Offset[i[0]]+Registers[i[1]]+Registers[i[3]]+"00"+'\n')
            file.write(bin(int(i[2]))[2:].zfill(16)+'\n')
        if i[0] in Immediate:
            file.write(Immediate[i[0]]+Registers[i[1]]+"000000"+'\n')
            file.write(bin(int(i[2]))[2:].zfill(16)+'\n')

      

          



txt=ReadFile('input.txt')
Main(txt)
