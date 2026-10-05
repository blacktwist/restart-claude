# Records assets/demo.gif with VHS (https://github.com/charmbracelet/vhs).
# Run from the repo root inside a normal terminal (not inside Claude Code): vhs assets/demo.tape
# It drives a real claude session, so you need to be logged in.

Output "assets/demo.gif"
Set Shell zsh
Set FontSize 16
Set Width 1100
Set Height 650
Set Padding 20
Set Theme "Catppuccin Mocha"
Set TypingSpeed 60ms

Hide
Type "source restart/scripts/restart-wrapper.sh && clear"
Enter
Sleep 500ms
Show

Type "claude"
Enter
Sleep 6s
Type "Reply with just: hello from before the restart"
Enter
Sleep 10s
Type "/restart"
Sleep 1s
Enter
Sleep 18s
Type "What did you say before the restart?"
Enter
Sleep 10s
