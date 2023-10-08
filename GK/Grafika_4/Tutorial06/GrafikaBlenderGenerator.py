import bpy
import numpy as np
import os
mesh = bpy.context.selected_objects[0].data

result = "SimpleVertex vertices[] = {\n"

def tuple3ToStr(tup):
    s = "("
    s += str(round(tup[0], 2)) + "f, "
    s += str(round(tup[2], 2)) + "f, "
    s += str(round(tup[1], 2)) + "f)"
    return s

mesh.calc_loop_triangles()
trianglesCounter = 0

for tri in mesh.loop_triangles:
    a = np.array(mesh.vertices[tri.vertices[0]].co)
    b = np.array(mesh.vertices[tri.vertices[1]].co)
    c = np.array(mesh.vertices[tri.vertices[2]].co)
    
    A = np.subtract(a, b)
    B = np.subtract(a, c)
    
    normal = np.cross(A, B)
    normal = normal / np.linalg.norm(normal)
    
    normalStr = tuple3ToStr(normal)
    
    result += "{ XMFLOAT3" + tuple3ToStr(a) + ", " + "XMFLOAT3" + normalStr + " },\n"
    result += "{ XMFLOAT3" + tuple3ToStr(b) + ", " + "XMFLOAT3" + normalStr + " },\n"
    result += "{ XMFLOAT3" + tuple3ToStr(c) + ", " + "XMFLOAT3" + normalStr + " },\n\n"
    trianglesCounter += 1
result += "};\n\n"


result += "WORD indices[] = {\n" 
for i in range(0, trianglesCounter*3):
    result += str(i) + ", "
result += "};\n\n"


result += "g_nTriangles = " + str(trianglesCounter) + ";\n"
result += "g_nVertices = " + str(trianglesCounter*3) + ";\n"


os.system("cls")
print(result, "\n\n\n")