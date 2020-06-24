import numpy as np
import matplotlib.pyplot as plt

def getPoints(endpoints, r1=0.05, convergence_angle=30, r2=0.03,r3=0.025,step=1e-6):

    functions = [
        lambda x: endpoints[0][1], # straight line
        lambda x: np.sqrt(r1**2 - (endpoints[1][1] - x)**2) + endpoints[1][1] - r1, # circle
        lambda x: -np.pi * (convergence_angle / 180) * (x - endpoints[2][0]) + endpoints[2][1], # straight line
        lambda x: -np.sqrt(r2**2 - (endpoints[3][1] - x)**2) + endpoints[3][1] - r2, # circle
        lambda x: -np.sqrt(r3**2 - (endpoints[4][1] - x)**2) + endpoints[4][1] - r3, # circle
        lambda x: ((endpoints[6][1] - endpoints[5][1]) / (endpoints[6][0] - endpoints[5][0])) * (x - endpoints[2][0]) + endpoints[2][1] # straight line

    ]
    num = np.int32(np.rint((endpoints[6][0] - endpoints[0][0]) / step))
    
    x = np.array([])
    y = np.array([])

    for i,fun in enumerate(functions):
        temp_x = np.linspace(endpoints[i][0], endpoints[i+1][0], num)
        f = np.vectorize(fun)
        y = np.append(y, f(temp_x))
        x = np.append(x, temp_x)
    return x, y

                       

x,y = getPoints(np.array(
    [[-0.190432417470023, 0.0400000000000000], 
     [-0.0618912817675829, 0.0400000000000000],
     [-0.0368912817675829, 0.0333012701892219],
     [-0.0150000000000000, 0.0206623327678020],
     [0, 0.0166430948813352],
     [0.00586669938711653, 0.0173412052778248],
     [0.0401400000000000, 0.0256163128987331]]), step=0.1)

plt.plot(x, y)
plt.show()
