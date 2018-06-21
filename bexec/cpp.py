#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os, sys
import subprocess
import argparse

from os.path import getmtime as mtime

# ----------------------------------------------------------
# ----------------------------------------------------------

parser = argparse.ArgumentParser()
parser.add_argument('input',          type=str,
                    help='source file')
parser.add_argument('-o', '--output', type=str, nargs='?',
                    help='output binary file')
parser.add_argument('-m', '--mode',   type=str,
                    help='mode [release/debug]')
parser.add_argument('--timeout',      type=int, default=2000,
                    help='timeout (millisecond)')
parser.add_argument('--args',         type=str,
                    help='args to pass to binary')

args = parser.parse_args()

# ----------------------------------------------------------
# ----------------------------------------------------------

source_file = os.path.abspath(args.input)

if args.output is None:
    args.output = args.input[:-4]

current_dir, binary_file = os.path.split(os.path.abspath(args.output))

mode = args.mode
timeout = args.timeout


flags = {'release': ['-O2'], 'debug': ['-g']}

# ----------------------------------------------------------
# ----------------------------------------------------------

for target in [mode]:
    if not target in flags:
        print ('incorrect mode')
        quit()

    compile_flags = flags[target] + args.args.split()

    binary_path = current_dir + '/.' + target + '/' + binary_file
    file_not_exists = not os.path.exists(binary_path)

    if not os.path.exists(current_dir + '/.' + target):
        os.makedirs(current_dir + '/.' + target)

    try:
        try:
            argsfile = os.environ['TEMPDIR']
        except KeyError:
            SCRIPTPATH = os.path.dirname(__file__)
            argsfile = SCRIPTPATH + '/../tempd'

        argsfile += '/ide-cpp-stdargs'
        creation_time = max(mtime(source_file), mtime(argsfile))

        if file_not_exists or creation_time > mtime(binary_path):
            arglist = ['clang++', '-Wall', '-std=c++1z',
                       '-I/usr/local/include/eigen3',
                       '-Wno-invalid-partial-specialization',
                       '-I' + os.path.expanduser('~/.files/c++/include')]
            arglist = arglist + compile_flags
            arglist = arglist + [source_file, '-o', binary_path]

            clang = subprocess.Popen(arglist, stdin=None,
                                     stderr=subprocess.STDOUT,
                                     stdout=subprocess.PIPE)

            try:
                out = clang.communicate(timeout=timeout)[0].decode("utf-8")
            except TimeoutExpired:
                clang.kill()
                out = clang.communicate(timeout=timeout)[0].decode("utf-8")

            if out:
                print(out)

            if clang.returncode != 0:
                raise OSError

    except OSError:
        print('Compilation error')
        quit()


arguments = []
if args.args:
    arguments = (args.args).split()

executable = subprocess.Popen([current_dir + '/.' + mode + '/' + binary_file]
                              + arguments, stdin=sys.stdin,
                              stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

try:
    out = executable.communicate(timeout=timeout)[0].decode("utf-8")
except TimeoutExpired:
    clang.kill()
    out = executable.communicate(timeout=timeout)[0].decode("utf-8")

if out:
    print (out)
