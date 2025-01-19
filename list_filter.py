"""
Assignment 1
"""

myList = [1, 1, 1, 5, 6, 'age', 8, 1]
newList = []

def uniqeSet(items):
    for item in items:
        if item not in  newList:
            newList.append(item) 
    return newList


print(uniqeSet(myList))