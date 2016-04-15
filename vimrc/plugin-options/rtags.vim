let g:rtagsUseDefaultMappings = 0
let g:rtagsUseLocationList = 0

function! RTagsJumpTo(...)
    let args = {}
    if a:0 > 0
        let args = a:1
    endif

    call extend(args, { '-f' : rtags#getCurrentLocation() })
    let results = rtags#ExecuteRC(args)

    if len(results) > 1
        call rtags#DisplayResults(results)
    elseif len(results) == 1
        let [location; symbol_detail] = split(results[0], '\s\+')
        let [jump_file, lnum, col; rest] = split(location, ':')

        if jump_file != expand('%:p')
            call rtags#cloneCurrentBuffer(g:NEW_TAB)
        endif

        " Add location to the jumplist
        normal m'
        if rtags#jumpToLocation(jump_file, lnum, col)
            normal zz
        endif
    endif

    return len(results)
endfunction
