" Vim global plugin that provides access to the codepad.org pastebin.
" Requires +python support.
"
" :CPPaste
"     to send the current buffer to codepad.org and copy the url to the
"     clipboard.
"
" :CPRun
"     to send the current buffer to codepad.org, execute it on their server,
"     and open both the pasted source and the program output in your browser.
"     Also copies the url to the clipboard.
"
" The correct filetype is automatically detected from the 'filetype' variable.
"
" Version:      1.5
" Last Change:  23 sep 2015
" Maintainer:   ARM9 <https://github.com/ARM9>


if has('python')
  command! -nargs=? -range=% CPPaste python codepadPaste(False, <line1>, <line2>)
  command! -nargs=? -range=% CPRun python codepadPaste(True, <line1>, <line2>)
else
  command! CPPaste echo 'Only avaliable with +python support.'
  command! CPRun echo 'Only avaliable with +python support.'
endif

if has('python')
python << EOF
def codepadLang(vimLang):
  filetypeMap = {
    'c':'C',
    'cpp':'C++',
    'd':'D',
    'haskell':'Haskell',
    'lua':'Lua',
    'ocaml':'OCaml',
    'php':'PHP',
    'perl':'Perl',
    'python':'Python',
    'ruby':'Ruby',
    'scheme':'Scheme',
    'tcl':'Tcl'
  }
  return filetypeMap.get(vimLang, 'Plain Text')

def codepadPaste(run, l1, l2):
  import urllib
  import vim

  url = 'http://codepad.org'
  code = vim.current.buffer[l1-1:l2]

  data = {
    'code':'\n'.join(code),
    'lang':codepadLang(vim.eval('&filetype')),
    'submit':'Submit'
  }
  if run:
    data['run'] = True

  response = urllib.urlopen(url, urllib.urlencode(data))
  url = response.geturl()
  vim.command("call setreg('+', '%s')" % url)
  vim.command("call setreg('*', '%s')" % url)
  if run:
    import webbrowser
    webbrowser.open(url)

EOF
endif
