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
file = open("output.txt", "w")
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
    for i in instructions:
        if i[0] in NoOperand:
            file.write(NoOperand[i[0]]+"1111111100"+'\n')
        elif i[0] in OneOperand:
            file.write(OneOperand[i[0]]+Registers[i[1]]+"111100"+'\n')
        elif i[0] in TwoOperands:
            file.write(TwoOperands[i[0]]+Registers[i[1]]+Registers[i[2]]+"00"+'\n')
        elif i[0] in Offset:
            file.write(Offset[i[0]]+Registers[i[1]]+Registers[i[3]]+"00"+'\n')
            file.write(bin(int(i[2],16))[2:].zfill(16)+'\n')
        elif i[0] in Immediate:
            file.write(Immediate[i[0]]+Registers[i[1]]+"111100"+'\n')
            file.write(bin(int(i[2],16))[2:].zfill(16)+'\n')
        else :
            print(i[0])
      

          



txt=ReadFile('input.txt')
Main(txt)
