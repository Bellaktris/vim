# -*- coding: utf-8 -*-
import traceback

import vim

try:
    import jedi
except ImportError:
    jedi = None


def catch_and_print_exceptions(func):
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except (Exception, vim.error):
            print(traceback.format_exc())
            return None
    return wrapper


@catch_and_print_exceptions
def get_script(source=None):
    if jedi is None:
        return None
    if source is None:
        source = '\n'.join(vim.current.buffer)
    buf_path = vim.current.buffer.name
    return jedi.Script(source, path=buf_path)


_float_win_id = None

@catch_and_print_exceptions
def clear_call_signatures():
    global _float_win_id
    if _float_win_id is not None:
        try:
            vim.eval('nvim_win_close(%d, v:true)' % _float_win_id)
        except Exception:
            pass
        _float_win_id = None


@catch_and_print_exceptions
def show_call_signatures(signatures=()):
    global _float_win_id

    if signatures == ():
        script = get_script()
        if script is None:
            return
        row = vim.current.window.cursor[0]
        col = vim.current.window.cursor[1]
        signatures = script.get_signatures(line=row, column=col)

    if _float_win_id is not None:
        try:
            vim.eval('nvim_win_close(%d, v:true)' % _float_win_id)
        except Exception:
            pass
        _float_win_id = None

    if not signatures:
        return

    sig = signatures[0]
    params = [p.description.replace('param ', '').replace('\n', '')
              for p in sig.params]

    text = ', '.join(params)

    buf = int(vim.eval('nvim_create_buf(v:false, v:true)'))
    vim.eval('nvim_buf_set_lines(%d, 0, -1, v:false, ["%s"])'
             % (buf, text.replace('"', '\\"')))

    try:
        idx = sig.index
        if idx is not None and 0 <= idx < len(params):
            vim.eval('nvim_buf_add_highlight(%d, -1, "Comment", 0, 0, -1)'
                     % buf)
            start = sum(len(p) + 2 for p in params[:idx])
            end = start + len(params[idx])
            vim.eval('nvim_buf_add_highlight(%d, -1, "Title", 0, %d, %d)'
                     % (buf, start, end))
    except (IndexError, TypeError):
        pass

    bracket_line, bracket_col = sig.bracket_start
    row_offset = bracket_line - row
    col_offset = bracket_col - col + 1
    opts = ('{' +
            '"relative": "cursor", "anchor": "SW", '
            '"row": %d, "col": %d, ' % (row_offset, col_offset) +
            '"width": %d, "height": 1, ' % (len(text),) +
            '"style": "minimal"' +
            '}')
    _float_win_id = int(vim.eval('nvim_open_win(%d, v:false, %s)' % (buf, opts)))
