def FIFO(size, pages):
    memory = []
    faults = 0
    for page in pages:
        if memory.count(page) == 0 and len(memory) < size:
            memory.append(page)
            faults += 1
            print(memory)
        elif memory.count(page) == 0 and len(memory) == size:
            memory.pop(0)
            memory.append(page)
            faults += 1
            print(memory)
    return faults

def LRU(size, pages):
    memory = []
    faults = 0
    for page in pages:
        if memory.count(page) == 0 and len(memory) < size:
            memory.append(page)
            faults += 1
            print(memory)
        elif memory.count(page) == 0 and len(memory) == size:
            memory.pop(0)
            memory.append(page)
            faults += 1
            print(memory)
        elif memory.count(page) > 0:
            memory.remove(page)
            memory.append(page)
    return faults

def predict(index, memory, pages):
    farthest = 0
    toPop = 0
    for i in range(len(memory)):
        j = 0
        for j in range(index + 1, len(pages)):
            if memory[i] == pages[j]:
                if farthest < j:
                    farthest = j
                    toPop = i
                break
        if pages[j] != memory[i] and j == len(pages)-1:
            return i
    return toPop

def OPTIMAL(size, pages):
    memory = []
    faults = 0
    for i in range(len(pages)):
        if memory.count(pages[i]) == 0 and len(memory) < size:
            memory.append(pages[i])
            faults += 1
            print(memory)
        elif memory.count(pages[i]) == 0 and len(memory) == size:
            memory[predict(i, memory, pages)] = pages[i]
            faults += 1
            print(memory)
    return faults
            
    

pages = [7,0,1,2,0,3,0,4,2,3,0,3,2,1,2,0,1,7,0,1]

print(FIFO(3, pages))
print("-----------")
print(LRU(3, pages))
print("-----------")
print(pages)
print(OPTIMAL(3, pages))
