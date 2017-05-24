#!/usr/bin/python


def myLength(L):
    c = 0
    for i in L:
        c += 1
    return c


def myMaximum(L):
    maxi = L[0]
    for i in L:
        if i > maxi:
            maxi = i
    return maxi


def average(L=[1]):
    return sum(L) / myLength(L)


def buildPalindrome(L):
    result = []
    for i in L:
        result = [i] + result
    return result + L


def remove(L1, L2):
    result = []
    for i in L1:
        if i not in L2:
            result += [i]
    return result


def flatten(L):
    result = []
    for x in L:
        if isinstance(x, list):
            result += flatten(x)
        else:
            result += [x]
    return result


def oddsNevens(L):
    odds = []
    evens = []
    for i in L:
        if i % 2 == 0:
            evens += [i]
        else:
            odds += [i]
    return (odds, evens)


def primeDivisors(n):
    result = []
    for i in range(2, n):
        if not n % i and isPrime(i):
            result += [i]
    return result


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
