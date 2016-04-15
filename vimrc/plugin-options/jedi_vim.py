# -*- coding: utf-8 -*-
import re
import traceback

import vim
import jedi


class PythonToVimStr(str):
    """ Vim has a different string implementation of single quotes """
    __slots__ = []

    def __new__(cls, obj, encoding='UTF-8'):
        return str.__new__(cls, obj)

    def __repr__(self):
        s = self
        return '"%s"' % s.replace('\\', '\\\\').replace('"', r'\"')


class VimError(Exception):
    def __init__(self, message, throwpoint, executing):
        super(type(self), self).__init__(message)
        self.message = message
        self.throwpoint = throwpoint
        self.executing = executing

    def __str__(self):
        return self.message + '; created by: ' + repr(self.executing)


def _catch_exception(string, is_eval):
    """
    Interface between vim and python calls back to it.
    Necessary, because the exact error message is not given by `vim.error`.
    """
    e = 'jedi#_vim_exceptions(%s, %s)'
    result = vim.eval(e % (repr(PythonToVimStr(string, 'UTF-8')), is_eval))
    if 'exception' in result:
        raise VimError(result['exception'], result['throwpoint'], string)
    return result['result']


def vim_command(string):
    _catch_exception(string, 0)


def vim_eval(string):
    return _catch_exception(string, 1)


def no_jedi_warning(error=None):
    msg = "Please install Jedi if you want to use jedi-vim."
    if error:
        msg = '{0} The error was: {1}'.format(msg, error)
    vim.command('echohl WarningMsg'
                '| echom "Please install Jedi if you want to use jedi-vim."'
                '| echohl None')


def echo_highlight(msg):
    vim_command('echohl WarningMsg | echom "{0}" | echohl None'.format(
        msg.replace('"', '\\"')))


def catch_and_print_exceptions(func):
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except (Exception, vim.error):
            print(traceback.format_exc())
            return None
    return wrapper


@catch_and_print_exceptions
def get_script(source=None, column=None):
    jedi.settings.additional_dynamic_modules = \
        [b.name for b in vim.buffers if b.name is not None and b.name.endswith('.py')]
    if source is None:
        source = '\n'.join(vim.current.buffer)
    row = vim.current.window.cursor[0]
    if column is None:
        column = vim.current.window.cursor[1]
    buf_path = vim.current.buffer.name
    encoding = vim_eval('&encoding') or 'latin1'
    return jedi.Script(source, row, column, buf_path, encoding)


@catch_and_print_exceptions
def clear_call_signatures():
    cursor = vim.current.window.cursor
    e = vim_eval('g:jedi#call_signature_escape')
    # We need two turns here to search and replace certain lines:
    # 1. Search for a line with a call signature and save the appended
    #    characters
    # 2. Actually replace the line and redo the status quo.
    py_regex = r'%sjedi=([0-9]+), (.*?)%s.*?%sjedi%s'.replace('%s', re.escape(e))
    for i, line in enumerate(vim.current.buffer):
        match = re.search(py_regex, line)
        if match is not None:
            # Some signs were added to minimize syntax changes due to call
            # signatures. We have to remove them again. The number of them is
            # specified in `match.group(1)`.
            after = line[match.end() + int(match.group(1)):]
            line = line[:match.start()] + match.group(2) + after
            vim.current.buffer[i] = line
    vim.current.window.cursor = cursor


@catch_and_print_exceptions
def show_call_signatures(signatures=()):
    if signatures == ():
        signatures = get_script().call_signatures()
    clear_call_signatures()

    if not signatures:
        return

    for i, signature in enumerate(signatures):
        line, column = signature.bracket_start
        # signatures are listed above each other
        line_to_replace = line - i - 1
        # because there's a space before the bracket
        insert_column = column - 1
        if insert_column < 0 or line_to_replace <= 0:
            # Edge cases, when the call signature has no space on the screen.
            break

        # TODO check if completion menu is above or below
        line = vim_eval("getline(%s)" % line_to_replace)

        params = [p.description.replace('\n', '') for p in signature.params]
        try:
            # *_*PLACEHOLDER*_* makes something fat. See after/syntax file.
            params[signature.index] = '*_*%s*_*' % params[signature.index]
        except (IndexError, TypeError):
            pass

        # This stuff is reaaaaally a hack! I cannot stress enough, that
        # this is a stupid solution. But there is really no other yet.
        # There is no possibility in VIM to draw on the screen, but there
        # will be one (see :help todo Patch to access screen under Python.
        # (Marko Mahni, 2010 Jul 18))
        text = " (%s) " % ', '.join(params)
        text = ' ' * (insert_column - len(line)) + text
        end_column = insert_column + len(text) - 2  # -2 due to bold symbols

        # Need to decode it with utf8, because vim returns always a python 2
        # string even if it is unicode.
        e = vim_eval('g:jedi#call_signature_escape')
        if hasattr(e, 'decode'):
            e = e.decode('UTF-8')
        # replace line before with cursor
        regex = "xjedi=%sx%sxjedix".replace('x', e)

        prefix, replace = line[:insert_column], line[insert_column:end_column]

        # Check the replace stuff for strings, to append them
        # (don't want to break the syntax)
        regex_quotes = r'''\\*["']+'''
        # `add` are all the quotation marks.
        # join them with a space to avoid producing '''
        add = ' '.join(re.findall(regex_quotes, replace))
        # search backwards
        if add and replace[0] in ['"', "'"]:
            a = re.search(regex_quotes + '$', prefix)
            add = ('' if a is None else a.group(0)) + add

        tup = '%s, %s' % (len(add), replace)
        repl = prefix + (regex % (tup, text)) + add + line[end_column:]

        vim_eval('setline(%s, %s)' % (line_to_replace, repr(PythonToVimStr(repl))))
