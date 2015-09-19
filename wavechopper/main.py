#!/usr/bin/python3

import sys

# allow this script to be executed as a child of another script
sys.path.insert(0, '.')

from wavechopper import main

if __name__ == '__main__':
    main()