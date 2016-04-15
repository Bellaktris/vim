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


flags = {'release': ['-O'], 'debug': ['-g']}

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
            argsfile = os.path.basename(__file__) + '../tempd'

        argsfile += '/ide-cpp-stdargs'
        creation_time = max(mtime(source_file), mtime(argsfile))

        if file_not_exists or creation_time > mtime(binary_path):
            arglist = ['rustc'] + compile_flags
            arglist = arglist + [source_file, '-o', binary_path]

            rustc = subprocess.Popen(arglist, stdin=None,
                                     stderr=subprocess.STDOUT,
                                     stdout=subprocess.PIPE)

            try:
                out = rustc.communicate(timeout=timeout)[0].decode("utf-8")
            except TimeoutExpired:
                rustc.kill()
                out = rustc.communicate(timeout=timeout)[0].decode("utf-8")

            if out:
                print(out)

            if rustc.returncode != 0:
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
    rustc.kill()
    out = executable.communicate(timeout=timeout)[0].decode("utf-8")

if out:
    print(out)
