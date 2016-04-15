import os
import ycm_core

def follow_paths(flags, working_directory):
    if not working_directory:
        return list(flags)

    new_flags = []
    path_flags = ['-isystem', '-I', '-iquote', '--sysroot=']

    make_next_absolute = False
    for flag in flags:
        new_flag = flag

        if make_next_absolute:
            make_next_absolute = False
            if not flag.startswith('/'):
                new_flag = os.path.join(working_directory, flag)

        for path_flag in path_flags:
            if flag == path_flag:
                make_next_absolute = True
                break

            if flag.startswith(path_flag):
                path = flag[len(path_flag):]
                new_flag = path_flag + os.path.join(working_directory, path)
                break

        if new_flag:
            new_flags.append(new_flag)

    return new_flags


def get_compilation_info_for_file(database, filename):
    if os.path.splitext(filename)[1] in ['.cpp', '.cxx', '.cc', '.c']:
        return database.GetCompilationInfoForFile(filename)

    if os.path.splitext(filename)[1] in ['.hpp', '.hxx', '.hh', '.h']:
        basename = os.path.splitext(filename)[0]

        for extension in ['.cpp', '.cxx', '.cc', '.c']:
            source_file = basename + extension

            if not os.path.exists(source_file):
                continue

            compilation_info = database.GetCompilationInfoForFile(source_file)

            if compilation_info.compiler_flags_:
                return compilation_info

    return None


def FlagsForFile(filename, **kwargs):
    current_dir = os.getcwd()
    flags = ['-Wall', '-fexceptions', '-std=c++1z',
             '-I/usr/local/include/eigen3',
             '-I' + os.path.expanduser('~/.files/c++/include')]

    if not os.path.exists(current_dir + '/compile_commands.json'):
        database = None
    else:
        database = ycm_core.CompilationDatabase(current_dir)

    if database is not None:
        info = get_compilation_info_for_file(database, filename)

        if not info:
            return None

        flags = follow_paths(info.compiler_flags_, info.compiler_working_dir_)

        return {'flags': flags, 'do_cache': True}

    else:
        flags = follow_paths(flags, current_dir)
        return {'flags': flags, 'do_cache': True}
