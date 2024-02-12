Set-PSReadLineOption -EditMode Emacs
Set-PSReadlineOption -BellStyle None
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -Colors @{ InlinePrediction = "$([char]0x1b)[38;5;238m" }

Set-Alias vi nvim
Set-Alias ls lsd
function ll($name) { lsd -Alh $name}
function la($name) { lsd -AF $name}
function l($name) { lsd -lF $name}
function pkill($name) { get-process $name -ErrorAction SilentlyContinue | stop-process }
function reboot {
	shutdown /r /t 0
}

function dev($name) {
    $curDir = Get-Location;
    C:\'Program Files\Microsoft Visual Studio'\2022\Community\Common7\Tools\Launch-VsDevShell.ps1 -Arch $name;
    cd $curDir
}
oh-my-posh init pwsh --config 'C:/Users/User/AppData/Local/Programs/oh-my-posh/themes/robbyrussell.omp.json' | Invoke-Expression
