" Vim global plugin that provides access to the codepad.org pastebin.
" Requires +python support.
"
" Add this to your ~/.vim/plugin/ directory. Then you can use
"
" :CPPaste
"     to send the current buffer to codepad.org and open your pasted code
"     in your webbrowser.
"
" :CPRun
"     to send the current buffer to codepad.org, execute it on their server,
"     and open both the pasted source and the program output in your browser.
"
" The correct filetype is automatically detected from the 'filetype' variable.
"
" Version:      1.4
" Last Change:  30 jul 2010
" Maintainer:   Nicolas Weber <nicolasweber at gmx.de>


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
