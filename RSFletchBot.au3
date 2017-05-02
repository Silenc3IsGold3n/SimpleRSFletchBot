;be gentle with me :3

#include <FileConstants.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include<Date.au3>

HotKeySet("z","quit")
HotKeySet("x","pause")
$Paused = False
$i = 0
$firstx = 0
$firsty = 0
$secondx = 0
$secondy = 0
$clicked = false
$pressedSpace = false
$i_reduced = false
$arrows_fletched = 0
$extra = False
$firstRun = True

Global $settingCoords = False
Global $CoordNum = 0;
Global $Coord1x = 0;
Global $Coord1y = 0;
Global $Coord2x = 0;
Global $Coord2y = 0;


While True
	Fletch()
WEnd

Func pause()
	$Paused = Not $Paused
	MsgBox($MB_SYSTEMMODAL,"","Paused: " & $Paused)
EndFunc

Func quit()
    $t = MsgBox (4, "Quit?" ,"Are you sure you want to quit?")
   If $t = 6 Then
    MsgBox($MB_SYSTEMMODAL,"","You have quit!")
	writetofile()
   Exit
   EndIf
EndFunc

Func writetofile()
	; Create a constant variable in Local scope of the filepath that will be read/written to.
    Local Const $sFilePath = "log.txt"

	Local $hFileOpen = FileOpen($sFilePath, $FO_READ)
    If $hFileOpen = -1 Then
        MsgBox($MB_SYSTEMMODAL, "", "An error occurred when reading the file.")
        Return False
    EndIf
	Local $TotalFletched = FileRead($hFileOpen)
	FileClose($hFileOpen)

    ; Create a temporary file to write data to (Total Fletched).
    If Not _FileWriteToLine($sFilePath,1, $TotalFletched + $arrows_fletched,1) Then
        MsgBox($MB_SYSTEMMODAL, "", "An error occurred whilst writing the temporary file.")
        Return False
    EndIf

    ; Open the file for writing (append to the end of a file) and store the handle to a variable.
    Local $hFileOpen = FileOpen($sFilePath, $FO_APPEND)
    If $hFileOpen = -1 Then
        MsgBox($MB_SYSTEMMODAL, "", "An error occurred whilst writing the temporary file.")
        Return False
    EndIf

    ; Write data to the file using the handle returned by FileOpen.
    FileWriteLine($hFileOpen, @CRLF & $arrows_fletched & " " & _NowDate() & " " & _NowTime())

    ; Close the handle returned by FileOpen.
    FileClose($hFileOpen)

    ; Display the contents of the file passing the filepath to FileRead instead of a handle returned by FileOpen.
    ;MsgBox($MB_SYSTEMMODAL, "", "Contents of the file:" & @CRLF & FileRead($sFilePath))

EndFunc

Func ReadFile()
    ; Create a constant variable in Local scope of the filepath that will be read/written to.
    Local Const $sFilePath = "coords.txt"

    Local $hFileOpen = FileOpen($sFilePath, $FO_READ)
    If $hFileOpen = -1 Then
        MsgBox($MB_SYSTEMMODAL, "", "This must be your first time running. Z is to quit and X is to pause/unpause.")
        Return False
    EndIf

    ; Read the first line of the file using the handle returned by FileOpen.
    Local $sFileRead = FileRead($hFileOpen)

	;This is for the arrow shaft
	$firstx = FileReadLine($sFilePath)
	$firsty = FileReadLine($sFilePath,2)
	$secondx = FileReadLine($sFilePath,3)
	$secondy = FileReadLine($sFilePath,4)
	;

    ; Close the handle returned by FileOpen.
    FileClose($hFileOpen)


    ; Display the first line of the file.

    ;MsgBox($MB_SYSTEMMODAL, "", "Contents of config at ( " & $sFilePath & "):" & @CRLF & $sFileRead)

	;for $i = (Number($sAnswer)/150) to 1 Step -1
	Return True
EndFunc


Func WriteCoordsToFile()
    ; Create a constant variable in Local scope of the filepath that will be read/written to.
    Local Const $sFilePath = "coords.txt"

    ; Create a temporary file to write data to.
    If Not FileWrite($sFilePath, "Start of the FileWrite example, line 1. " & @CRLF) Then
        MsgBox($MB_SYSTEMMODAL, "", "An error occurred whilst writing the temporary file.")
        Return False
    EndIf

    ; Open the file for writing (overwrite file) and store the handle to a variable.
    Local $hFileOpen = FileOpen($sFilePath, $FO_OVERWRITE)
    If $hFileOpen = -1 Then
        MsgBox($MB_SYSTEMMODAL, "", "An error occurred whilst writing the temporary file.")
        Return False
    EndIf

    ; Write data to the file using the handle returned by FileOpen.
    FileWrite($hFileOpen, $Coord1x & @CRLF)
    FileWrite($hFileOpen, $Coord1y & @CRLF)
    FileWrite($hFileOpen, $Coord2x & @CRLF)
    FileWrite($hFileOpen, $Coord2y)

    ; Close the handle returned by FileOpen.
    FileClose($hFileOpen)

    ; Display the contents of the file passing the filepath to FileRead instead of a handle returned by FileOpen.
    ;MsgBox($MB_SYSTEMMODAL, "", "Contents of the file:" & @CRLF & FileRead($sFilePath))
    ;Fletch()
    ; Delete the temporary file.
    ;FileDelete($sFilePath)
EndFunc   ;==>Example

Func jPos()
    $jPos = MouseGetPos()
	If($CoordNum == 0) Then
	   SplashOff()
	   MsgBox(0, "Mouse x,y:", $jPos[0] & "," & $jPos[1])
	   $Coord1x = $jPos[0]
	   $Coord1y = $jPos[1]
	   $CoordNum = 1
    ElseIf($CoordNum == 1) Then
	   MsgBox(0, "Mouse x,y:", $jPos[0] & "," & $jPos[1])
	   $Coord2x = $jPos[0]
	   $Coord2y = $jPos[1]
	   $CoordNum = 2
	   WriteCoordsToFile()
	   $settingCoords = False
	   HotKeySet("c")
	   ReadFile()
    EndIf

EndFunc

Func Fletch()
   If ($firstRun)Then
	  $t = 6
	  If(ReadFile() == True)Then
		 $t = MsgBox (4, "Coords" ,"Would you like to update Coords?")
	  EndIf
	  If $t = 6 Then
		 SplashTextOn ("", "Mouse over top left of Arrow Shaft and press C, then bottom write and press C", 250, 150,-1,-1,1,-1,14,600)
		 HotKeySet("c","jPos")
		 $settingCoords = True
	  EndIf
	  $firstRun = False

   EndIf
   While ($Paused == False And $settingCoords == False)
	  If($i <= 0 And $settingCoords == False)Then
		 Local $sAnswer = InputBox("Fletcher", "How many to fletch?", "150", "",- 1, -1, 0, 0)
		 If(@Error) Then
			$quit = MsgBox($MB_SYSTEMMODAL +4, "", "Would you like to quit?")
			If($quit == $IDYES)Then
			   Exit
			EndIf
			   Return
		 EndIf
		 $i= (Number($sAnswer)/150)
		 If((Mod(Number($sAnswer),150) > 0 ))Then
			$extra = True
			$i = $i+1
		 EndIf
			$arrows_fletched = 0
	  EndIf
	  If($i > 0 And $settingCoords == False)Then
	  ;for $i = (Number($sAnswer)/150) to 1 Step -1
		 If($clicked == false and $Paused == False) Then
			$pressedSpace = false
			$i_reduced = false
			MouseMove ( Random(Number($firstx),Number($secondx),1), Random(Number($firsty),Number($secondy),1), Random(1,100,1) )
			MouseClick("primary")
		 EndIf
		 $clicked = true
		 If($pressedSpace == false and $Paused == False) Then
			sleep(Random(900,1500,1))
			Send("{SPACE}")
		 EndIf
		 $pressedSpace = true
		 If($i_reduced == false and $Paused == False) Then
			sleep(Random(11000,15000,1))
			$i = $i-1
			If($i == 0 And $extra==True)Then
			  $arrows_fletched = $arrows_fletched + (Mod(Number($sAnswer),150))
			Else
			  $arrows_fletched = $arrows_fletched + 150
			EndIf
		EndIf
		$i_reduced = true
		$clicked = false
   ElseIf($settingCoords == False)Then
	  MsgBox($MB_SYSTEMMODAL,"",$sAnswer & " headless arrows made.")
	  writetofile()
	  Return
   EndIf
   WEnd

EndFunc




