exit=False
T = 0

while exit==False:
    T = T+1
    v = [int(x) for x in input().split()]
    
    if v[0] == v[1] == v[2] == v[3] == 0:
        exit = True
    else:
        print("Teste %d"%T)
        n = int(input())
        c=0
        for i in range(n):
            m = [int(x) for x in input().split()]
            if m[0] <= v[2] and m[0] >= v[0] and v[1] >= m[1] and m[1] >= v[3]:
                c+=1
        print(c)