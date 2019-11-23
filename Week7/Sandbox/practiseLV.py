import sys

def fun(x, y, z):
    total = x + y + z
    return total

def main(args):
    fun(args[1], args[2], args[3])

if __name__ == '__main__':
    main(sys.argv)



