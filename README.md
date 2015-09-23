#### Installing
Use your preferred plugin/rtp manager
    
Requires +python

#### Using
The plugin adds two new commands: 

    :CPPaste 

to send the (range of the) current buffer to http://codepad.org
and copy the URL of the pasted snippet to the clipboard.


    :CPRun 

to send the (range of the) current buffer to http://codepad.org,
execute it on their server, and open both the pasted source and the
program output in your browser. The URL of the pasted snippets is copied
to the clipboard as well. 


The correct filetype is automatically detected through the 'filetype' option.
