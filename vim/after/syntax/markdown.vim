syn match CodeNoSpell "{%.*\(%}\_[^%]*{% end.*\)\?%}" contains=@NoSpell  " liquid tags
syn match IALNoSpell "{:.*}" contains=@NoSpell " liquid Block IALs
syn match EmailNoSpell "\<[A-Za-z0-0._%+-]\+@[A-Za-z0-9.-]\+\.[A-Za-z]\{2,\}\>" contains=@NoSpell  " email address
