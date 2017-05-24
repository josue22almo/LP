#!/usr/bin/python


def absValue(x):
    if x < 0:
        x *= -1
    return x


def power(x, y):
    if y == 0:
        return 1
    else:
        return x * power(x, y-1)


def isPrime(x):
    if x == 0:
        return False
    elif x == 1:
        return False
    elif x == 2:
        return True
    else:
        return auxiliar(x, 2)


def auxiliar(x, i):
    if x % i == 0:
        return False
    elif x < (i*i):
        return True
    else:
        return auxiliar(x, i+1)


def slowFib(n):
    if n == 0:
        return n
    elif n == 1:
        return n
    return slowFib(n-1) + slowFib(n-2)


def quickFib(n):
    a, b = 0, 1
    for _ in range(n):
        a, b = b, a+b
    return a
