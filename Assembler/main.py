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

NoOperand={
#One Operand
"NOP": "000000", 
"SETC": "000001", 
"CLRC": "000010",
#Branch

"RET": "110101", 
"RTI": "100110",

}
OneOperand={
#One Operand
"CLR": "000011",
"NOT": "000100",
"INC":"000101",
"DEC":"000110",
"NEG":"000111",
"OUT": "001000",
"IN" : "001001",

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

def HandleComments(txt):
    Lines = txt.splitlines() 
    LinesNoComments = []
    for line in Lines:
        x=line.find('#')
        if(x!=-1):
            line=line[:x]
            line=line.strip()
        if(line!=''):    
            LinesNoComments.append(line)
    print(LinesNoComments)
    return LinesNoComments
file = open("output.mem", "w")
file.write(("// memory data file (do not edit the following line - required for mem load use)\n"
            "// instance=/ram/ram\n"
            "// format=mti addressradix=h dataradix=b version=1.0 wordsperline=1 noaddress\n")) 
instructions=[]

def Main(Lines):   
    Lines=HandleComments(Lines)
    for i in range(len(Lines)):
        Lines[i]=Lines[i].replace(',',' ')
        Lines[i]=Lines[i].replace('(',' ')
        Lines[i]=Lines[i].replace(')',' ')
        combine_whitespave = re.compile(r"\s+")
        my_str = combine_whitespave.sub(" ", Lines[i]).strip()
        instructions.append(my_str.split(' '))
    address=0;
    instr = ["0000000000000000\n"] * 28
    for i in instructions:
        if i[0]=='.ORG':
            address = int(i[1])
            address -= 1
        elif i[0] in NoOperand:
            instr[address] = NoOperand[i[0]]+"1111111100"+'\n'
        elif i[0] in OneOperand:
            instr[address] = OneOperand[i[0]]+Registers[i[1]]+"111100"+'\n'
        elif i[0] in TwoOperands:
            instr[address] = TwoOperands[i[0]]+Registers[i[1]]+Registers[i[2]]+"00"+'\n'
        elif i[0] in Offset:
            instr[address] = Offset[i[0]]+Registers[i[1]]+Registers[i[3]]+"00"+'\n'
            address = address+1
            instr[address] = bin(int(i[2],16))[2:].zfill(16)+'\n'
        elif i[0] in Immediate:
            instr[address] = Immediate[i[0]]+Registers[i[1]]+"111100"+'\n'
            address=address+1
            instr[address] = bin(int(i[2],16))[2:].zfill(16)+'\n'
        elif re.match('^[-+]?[0-9]+$', i[0]):
            instr[address] = bin(int(i[0]))[2:].zfill(16)+'\n'
        address += 1
    for _, line in enumerate(instr):
        file.write(str(line)) 
        

          



txt=ReadFile('input.txt')
Main(txt)
