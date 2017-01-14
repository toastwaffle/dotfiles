#!/usr/bin/env python3
# coding: utf-8
"""Script to show the current GBP/EUR exchange rate."""

import requests

def main():
    """Get and print the rate."""
    r = requests.get('https://api.fixer.io/latest?base=GBP&symbols=EUR')

    print('£1 = €{0:.4f}'.format(r.json()['rates']['EUR']))

if __name__ == '__main__':
    main()
