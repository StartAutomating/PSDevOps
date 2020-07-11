@{
    name  = 'Display the path'
    run   = @'
import os
print(os.environ['PATH'])
'@
    shell = 'python'
}