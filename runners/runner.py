#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os, sys, shutil, subprocess, argparse
from functools import lru_cache
from subprocess import TimeoutExpired
from os.path import getmtime as mtime


def run_ok(cmd):
    try:
        return subprocess.run(cmd, stdin=subprocess.DEVNULL,
                              stdout=subprocess.DEVNULL,
                              stderr=subprocess.DEVNULL).returncode == 0
    except OSError:
        return False


@lru_cache(maxsize=None)
def cpp_compiler():
    return 'clang++' if shutil.which('clang++') else 'c++'


@lru_cache(maxsize=None)
def compiler_accepts(*flags):
    return run_ok([cpp_compiler(), *flags, '-x', 'c++', '-fsyntax-only', '-'])


@lru_cache(maxsize=None)
def pkg_config(*args):
    try:
        return subprocess.run(['pkg-config', *args], stdin=subprocess.DEVNULL,
                              capture_output=True, text=True)
    except OSError:
        return None


def eigen_flags():
    proc = pkg_config('--cflags', 'eigen3')
    if proc is not None and proc.returncode == 0 and proc.stdout.strip():
        return proc.stdout.split()
    for path in ('/opt/homebrew/include/eigen3', '/usr/local/include/eigen3',
                 '/usr/include/eigen3'):
        if os.path.isdir(path):
            return ['-I' + path]
    return []


def cpp_flags():
    std = next((s for s in ('c++2c', 'c++23', 'c++20')
                if compiler_accepts('-std=' + s)), None)
    flags = ['-Wall'] + (['-std=' + std] if std else [])
    if compiler_accepts('-march=native'):
        flags.append('-march=native')
    flags += ['-I' + os.path.expanduser('~/.files/c++/.local/include')]
    flags += eigen_flags()
    proc = pkg_config('--exists', 'libfolly')
    if proc is not None and proc.returncode == 0:
        flags.append('-lfolly')
    return flags


LANGUAGES = {
    'cpp': {
        'compiler': cpp_compiler,
        'flags': cpp_flags,
        'release': ['-O3'],
        'debug': ['-g'],
    },
    'rust': {
        'compiler': 'rustc',
        'flags': [],
        'release': ['-O'],
        'debug': ['-g'],
    },
}

parser = argparse.ArgumentParser()
parser.add_argument('input',            type=str, help='source file')
parser.add_argument('-o', '--output',   type=str, nargs='?', help='output binary')
parser.add_argument('-m', '--mode',     type=str, required=True, help='release or debug')
parser.add_argument('--timeout',        type=int, default=2000, help='timeout in ms')
parser.add_argument('--args',           type=str, default='', help='extra compiler/runtime flags')
parser.add_argument('--lang',           type=str, required=True, choices=LANGUAGES.keys())
args = parser.parse_args()

lang = LANGUAGES[args.lang]
source_file = os.path.abspath(args.input)

if args.output is None:
    args.output = os.path.splitext(args.input)[0]

current_dir, binary_file = os.path.split(os.path.abspath(args.output))

if args.mode not in ('release', 'debug'):
    print('incorrect mode')
    sys.exit(1)

mode_flags = lang[args.mode]
compile_flags = mode_flags + args.args.split()
binary_path = os.path.join(current_dir, '.' + args.mode, binary_file)
os.makedirs(os.path.dirname(binary_path), exist_ok=True)

try:
    if not os.path.exists(binary_path) or mtime(source_file) > mtime(binary_path):
        compiler, flags = lang['compiler'], lang['flags']
        cmd = [compiler() if callable(compiler) else compiler]
        cmd += (flags() if callable(flags) else flags) + compile_flags
        cmd += [source_file, '-o', binary_path]

        proc = subprocess.Popen(cmd, stdin=None,
                                stderr=subprocess.STDOUT,
                                stdout=subprocess.PIPE)
        try:
            out = proc.communicate(timeout=args.timeout)[0].decode('utf-8')
        except TimeoutExpired:
            proc.kill()
            out = proc.communicate()[0].decode('utf-8')

        if out:
            print(out)
        if proc.returncode != 0:
            sys.exit(1)
except OSError:
    print('Compilation error')
    sys.exit(1)

proc = subprocess.Popen(
    [binary_path] + args.args.split(),
    stdin=sys.stdin,
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT)
try:
    out = proc.communicate(timeout=args.timeout)[0].decode('utf-8')
except TimeoutExpired:
    proc.kill()
    out = proc.communicate()[0].decode('utf-8')

if out:
    print(out)
