## Simple tool to quickly run Karax applications. Generates the HTML
## required to run a Karax app and opens it in a browser.

import os, strutils, parseopt, browsers

const
  html = """
<!DOCTYPE html>
<html>
<head><title>$1</title></head>
<body id="body">
<div id="ROOT" />
<script type="text/javascript" src="$1.js"></script>
</body>
</html>
"""

proc exec(cmd: string) =
  if os.execShellCmd(cmd) != 0:
    quit "External command failed: " & cmd

proc main =
  var op = initOptParser()
  let rest = op.cmdLineRest
  var file = ""
  while true:
    op.next()
    case op.kind
    of cmdLongOption, cmdShortOption: discard
    of cmdArgument: file = op.key
    of cmdEnd: break

  if file.len == 0: quit "filename expected"
  let name = file.splitFile.name
  createDir("nimcache")
  exec("nim js --out:nimcache/" & name & ".js " & rest)
  let dest = "nimcache" / name & ".html"
  writeFile(dest, html % name)
  openDefaultBrowser(dest)

main()
