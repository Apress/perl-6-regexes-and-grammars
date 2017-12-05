say "<a> b <c>" ~~ /"<" .+ ">"/;    # Output: ⌜<a> b <c>⌟

say "<a> b <c>" ~~ /"<" .+? ">"/;    # Output: ⌜<a>⌟
