# -*- coding: utf-8 -*-
import os
import sys
import traceback

import vim


def _vendored_jedi_paths():
    """YCM vendors jedi and parso; reuse them instead of a separate install."""
    plug_dir = vim.eval('get(g:, "vim_plug_dir", "")')
    if not plug_dir:
        return []
    deps = os.path.join(plug_dir, 'YouCompleteMe', 'third_party', 'ycmd',
                        'third_party', 'jedi_deps')
    return [os.path.join(deps, name) for name in ('jedi', 'parso')]


try:
    import jedi
except ImportError:
    for _path in _vendored_jedi_paths():
        if os.path.isdir(_path) and _path not in sys.path:
            sys.path.append(_path)
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


_missing_jedi_reported = False


@catch_and_print_exceptions
def get_script(source=None):
    global _missing_jedi_reported
    if jedi is None:
        if not _missing_jedi_reported:
            _missing_jedi_reported = True
            vim.command('echohl WarningMsg'
                        '| echom "jedi not importable: call signatures off"'
                        '| echohl None')
        return None
    if source is None:
        source = '\n'.join(vim.current.buffer)
    buf_path = vim.current.buffer.name
    return jedi.Script(source, path=buf_path or None)


def _pick_signature(signatures):
    """Pick the overload whose parameters can hold the active index.

    Overloaded callables (dict.get, os.path.join, most of typeshed) yield one
    signature per overload, and signatures[0] is often the shortest one, whose
    index goes None from the second argument on. Preferring a signature that
    can actually hold the active parameter keeps the highlight moving.
    """
    for sig in signatures:
        if sig.index is not None and 0 <= sig.index < len(sig.params):
            return sig
    return signatures[0]


def _active_index(sig):
    idx = sig.index
    if idx is None or not sig.params:
        return None
    # *args/**kwargs absorb every later argument, so jedi keeps reporting the
    # variadic parameter; clamp instead of dropping the highlight entirely.
    return min(idx, len(sig.params) - 1)


def _fit_to_width(text, start, end, width):
    """Scroll a long signature so the active parameter stays on screen.

    Typeshed signatures routinely overflow the screen (open() renders 193
    characters), and a float wider than the screen is clamped by nvim, so
    every parameter past the visible edge used to highlight off-screen and
    the float looked frozen. Returns the windowed text with its highlight
    range translated into it; '<' and '>' mark text scrolled out of view.
    """
    if width <= 0 or len(text) <= width:
        return text, start, end
    if start is None:
        return text[:width - 1] + '>', None, None
    if end <= width:
        offset = 0
    else:
        # keep a little context before the active parameter where possible
        offset = min(max(0, start - 8), len(text) - width)

    window = text[offset:offset + width]
    start, end = start - offset, end - offset

    if offset > 0:
        window = '<' + window[1:]
        start, end = max(1, start), max(1, end)
    if offset + width < len(text):
        window = window[:-1] + '>'
        start, end = min(start, width - 1), min(end, width - 1)

    return window, start, end


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

    # needed for the float's anchor below, not just for the lookup, so read it
    # outside the branch -- callers may pass signatures in themselves.
    row, col = vim.current.window.cursor

    if signatures == ():
        script = get_script()
        if script is None:
            return
        signatures = script.get_signatures(line=row, column=col)

    if _float_win_id is not None:
        try:
            vim.eval('nvim_win_close(%d, v:true)' % _float_win_id)
        except Exception:
            pass
        _float_win_id = None

    if not signatures:
        return

    sig = _pick_signature(signatures)
    params = [p.description.replace('param ', '').replace('\n', '')
              for p in sig.params]

    text = ', '.join(params)

    idx = _active_index(sig)
    if idx is None:
        hl_start = hl_end = None
    else:
        hl_start = sum(len(p) + 2 for p in params[:idx])
        hl_end = hl_start + len(params[idx])

    bracket_line, bracket_col = sig.bracket_start
    row_offset = bracket_line - row
    col_offset = bracket_col - col + 1

    columns = int(vim.eval('&columns'))
    screen_col = int(vim.eval('screencol()'))
    left = max(0, screen_col - 1 + col_offset)

    width = min(len(text), columns)
    if left + width > columns:
        left = max(0, columns - width)
        col_offset = left - (screen_col - 1)

    text, hl_start, hl_end = _fit_to_width(text, hl_start, hl_end, width)

    buf = int(vim.eval('nvim_create_buf(v:false, v:true)'))
    vim.eval('nvim_buf_set_lines(%d, 0, -1, v:false, ["%s"])'
             % (buf, text.replace('"', '\\"')))

    try:
        vim.eval('nvim_buf_add_highlight(%d, -1, "Comment", 0, 0, -1)' % buf)
        if hl_start is not None and hl_end > hl_start:
            # add_highlight takes byte columns, not character counts
            start = len(text[:hl_start].encode('utf-8'))
            end = len(text[:hl_end].encode('utf-8'))
            vim.eval('nvim_buf_add_highlight(%d, -1, "Title", 0, %d, %d)'
                     % (buf, start, end))
    except (IndexError, TypeError):
        pass

    opts = ('{' +
            '"relative": "cursor", "anchor": "SW", '
            '"row": %d, "col": %d, ' % (row_offset, col_offset) +
            '"width": %d, "height": 1, ' % (width,) +
            '"style": "minimal"' +
            '}')
    _float_win_id = int(vim.eval('nvim_open_win(%d, v:false, %s)' % (buf, opts)))
