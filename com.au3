#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; *** Start added by AutoIt3Wrapper ***
#include <StringConstants.au3>
; *** End added by AutoIt3Wrapper ***
; *** Start added by AutoIt3Wrapper ***
#include <Zip.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <Constants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
; *** End added by AutoIt3Wrapper ***
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.13.19 (Beta)
	Author:         myName

	Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include <File.au3>
#include <Constants.au3>
; Script Start - Add your code below here
OnAutoItExitRegister ( "killkill" )
Global Const $filepath = FileSelectFolder ( "select folder containing install files", "" )
Const $previous = @AppDataDir & "\installerprog"

Local $file = ""
Local $cont = ""
Opt("MouseCoordMode", 0)
$run = ""
Global $bob = ""
Global $cont = True
$hold = 0
$tttt = 1
FileInstall ( "C:\Users\whiggs\OneDrive\always script\kill.exe", @TempDir & "\kill.exe" )
Run ( @ComSpec & " /c kill.exe", @TempDir, @SW_HIDE )
Do
	Local $fileList = _FileListToArray($filepath, "*", $FLTA_FILES)
	For $i = 1 To $fileList[0] Step 1
		Select
			Case StringRight($fileList[$i], 3) == "msi"
				RunWait(@ComSpec & " /c " & 'msiexec.exe /i ' & '"' & $fileList[$i] & '"' & ' /qb', $filepath, @SW_HIDE)

			Case StringRight($fileList[$i], 3) == "zip"
				Global $stringSPL = StringSplit($fileList[$i], ".", $STR_NOCOUNT)
				_Zip_UnzipAll($filepath & "\" & $fileList[$i], @DesktopDir & "\short\" & $stringSPL[0], 532)
			Case StringRight($fileList[$i], 3) == "rar"
				Local $rarsplit = StringSplit($fileList[$i], ".", $STR_NOCOUNT)
				RunWait(@ComSpec & " /c " & 'unrar e "' & $filepath & '\' & $fileList[$i] & '" "' & @DesktopDir & '\short\' & $rarsplit[0] & '\"', "C:\Program Files\WinRAR")
			Case StringRight($fileList[$i], 2) == "7z"
				Local $7split = StringSplit($fileList[$i], ".", $STR_NOCOUNT)
				RunWait(@ComSpec & " /c " & '7z x "' & $filepath & '\' & $fileList[$i] & '" -o"' & @DesktopDir & '\short\' & $7split[0] & '\"', "C:\Program Files\7-Zip")
			Case StringRight($fileList[$i], 11) == "application"
				ShellExecuteWait($fileList[$i], "", $filepath)
			Case StringRight($fileList[$i], 3) == "msu"
				RunWait(@ComSpec & " /c " & 'wusa.exe ' & $fileList[$i] & ' /quiet /norestart', $filepath)
			Case StringRight ( $fileList[$i], 4 ) == "vsix"
				RunWait ( @ComSpec & " /c " & $fileList[$i] & " /q", $filepath )
			Case StringRight($fileList[$i], 3) == "exe"
						If Not FileExists (@ScriptDir & "\peid.exe") Then
							FileInstall("C:\Users\whiggs\OneDrive\always script\mdt\PEiD.exe", @ScriptDir & "\peid.exe")
						EndIf
						Run ("peid.exe -hard " & '"' & $filepath & "\" & $fileList[$i] & '"', @ScriptDir, @SW_HIDE )
						WinWait ( "PEiD v0.95" )
						$IDString= ControlGetText("PEiD v0.95", "", "[CLASS:Edit; INSTANCE:2]")
						Do
							Sleep (100)
							$IDString= ControlGetText("PEiD v0.95", "", "Edit2")
						Until ($IDString <>"Scanning...") And ($IDString <> "" )
						WinClose ("PEiD v0.95")
						$foundsomething = "n"
						If StringInStr ($IDString, "Inno Setup") Then
							RunWait ( @ComSpec & " /c " & '"' & $fileList[$i] & '"' & " /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-", $filepath, @SW_HIDE )
							$foundsomething = "y"
						ElseIf StringInStr ( $IDString, "Delphi" ) Then
							RunWait ( @ComSpec & " /c " & '"' & $fileList[$i] & '"' & " /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-", $filepath, @SW_HIDE )
							$foundsomething = "y"
						ElseIf StringInStr ($IDString, "Wise") Then
							RunWait ( @ComSpec & " /c " & '"' & $fileList[$i] & '"' & " /s", $filepath, @SW_HIDE )
						ElseIf StringInStr ($IDString, "Nullsoft") Then
							RunWait ( @ComSpec & " /c " & '"' & $fileList[$i] & '"' & " /S", $filepath, @SW_HIDE )
						ElseIf StringInStr ($IDString, "Installshield 2003") Then
							;ShellExecuteWait ( $fileList[$i], "/s /v /qb", $filepath )
							RunWait ( @ComSpec & ' /c "' & $fileList[$i] & ' /s /v"/qb"', $filepath, @SW_HIDE )
						Else
							RunWait ( @ComSpec & " /c " & '"' & $fileList[$i] & '"', $filepath, @SW_HIDE )
						EndIf



			Case Else
				ContinueLoop
		EndSelect
		Sleep(500)
		If $fileList[$i] == "AtomSetup.exe" Then
			$Atom = WinWaitActive("Welcome Guide - Atom")
			Sleep(3000)
			WinKill($Atom)
		ElseIf $fileList[$i] == "GitHubSetup.exe" Then
			$Git = WinWaitActive("[TITLE:GitHub; HANDLE:0x00000000001F0DF2]")
			Sleep(4000)
			WinKill($Git)
		ElseIf $fileList[$i] == "MemClean.exe" Then
			$Mem = WinWaitActive("Memory Cleaner", "Trim Processes' Working Set")
			Sleep(1000)
			Send("{RIGHT}", 0)
			$Mem2 = WinWaitActive("Memory Cleaner", "Trim processes' working set when usage exceeds 80%")
			Sleep(600)
			ControlClick($Mem2, "", "[CLASS:Button; INSTANCE:7]")
			Sleep(400)
			ControlClick($Mem2, "", "[CLASS:Button; INSTANCE:8]")
			Sleep(400)
			ControlClick($Mem2, "", "[CLASS:Button; INSTANCE:9]")
			WinClose($Mem2)
		Else
			Sleep(100)
		EndIf
		#Region --- CodeWizard generated code Start ---
		Do
			FileMove ( $filepath & "\" & $fileList[$i], @UserProfileDir & "\Downloads\" & $fileList[$i], 9 )
		Until FileExists ( @UserProfileDir & "\Downloads\" & $fileList[$i] ) And Not FileExists ( $filepath & "\" & $fileList[$i] )
		If Mod($i, 4) = 0 Then
			#Region --- CodeWizard generated code Start ---

;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Default Button=Second, Icon=None, Timeout=5 ss
If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_DEFBUTTON2,"Shutdown?","Restart computer?",5)
Select
	Case $iMsgBoxAnswer = $IDYES
		Shutdown(6)

	Case $iMsgBoxAnswer = $IDNO
		ContinueLoop

	Case $iMsgBoxAnswer = -1 ;Timeout
		ContinueLoop

EndSelect
#EndRegion --- CodeWizard generated code End ---

EndIf
	Next
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox($MB_YESNO, "Continue?", "The source folder is out of executables.  Do you wish to continue installation?  If so, move more executables into source directory, then click YES.  If not, click NO to restart.")
	Select
		Case $iMsgBoxAnswer = $IDYES
			$cont = True
		Case $iMsgBoxAnswer = $IDNO
			$cont = False
	EndSelect

Until $cont = False

Func killkill()
	ProcessClose ( "kill.exe" )
EndFunc

