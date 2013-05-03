; Generated NSIS script file (generated by makensitemplate.phtml 0.21)
; by 163.118.3.50 on Jun 05 02 @ 12:36

; Kervin Pierre, kervin@blueprint-tech.com
; 05JUN02

; Modified by Zentyal S.L. (2009-2010)

!define PRODUCT_NAME "Zentyal Migration Tool"
!define PRODUCT_VERSION "2.2"
!define PRODUCT_PUBLISHER "Zentyal S.L."
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\zentyal-migration.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

SetCompressor bzip2

; MUI 1.67 compatible ------
!include "MUI.nsh"

!include "x64.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!define MUI_LICENSEPAGE_CHECKBOX
!insertmacro MUI_PAGE_LICENSE "LICENSE.txt"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; Reserve files
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "zentyal-migration-tool-${PRODUCT_VERSION}.exe"
InstallDir "$PROGRAMFILES\zentyal-migration-tool"
InstallDirRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Zentyal\Migration Tool" ""
ShowInstDetails show
ShowUnInstDetails show

Section "" ; (default section)
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  ; add files / whatever that need to be installed here.
  WriteRegStr HKEY_LOCAL_MACHINE "SYSTEM\CurrentControlSet\Control\Lsa\passwdhk" "workingdir" "$INSTDIR"
  WriteRegStr HKEY_LOCAL_MACHINE "SYSTEM\CurrentControlSet\Control\Lsa\passwdhk" "port" "6677"
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\zentyal-migration-tool" "DisplayName" "$(^Name) (remove only)"
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\zentyal-migration-tool" "UninstallString" '"$INSTDIR\uninst.exe"'

  ; copy files
  File AUTHORS.txt
  File LICENSE.txt
  File README.passwdHk.txt
  File zentyal-migration.exe
  File migration.xml
  File zentyal-logo.png
  File getsid.vbs
  ; python files
  File atk.pyd
  File bz2.pyd
  File cairo._cairo.pyd
  File Crypto.Cipher.AES.pyd
  File _ctypes.pyd
  File freetype6.dll
  File gio._gio.pyd
  File glib._glib.pyd
  File gobject._gobject.pyd
  File gtk._gtk.pyd
  File intl.dll
  File libatk-1.0-0.dll
  File libcairo-2.dll
  File libexpat-1.dll
  File libfontconfig-1.dll
  File libgdk_pixbuf-2.0-0.dll
  File libgdk-win32-2.0-0.dll
  File libgio-2.0-0.dll
  File libglib-2.0-0.dll
  File libgmodule-2.0-0.dll
  File libgobject-2.0-0.dll
  File libgthread-2.0-0.dll
  File libgtk-win32-2.0-0.dll
  File libpango-1.0-0.dll
  File libpangocairo-1.0-0.dll
  File libpangoft2-1.0-0.dll
  File libpangowin32-1.0-0.dll
  File libpng14-14.dll
  File pangocairo.pyd
  File pango.pyd
  File select.pyd
  File _socket.pyd
  File _ssl.pyd
  File unicodedata.pyd
#  File win32security.pyd
  File zlib1.dll
  File setup-service.bat
  File zentyal-service-launcher.exe
  File zentyal-pwdsync-service.exe
  File zentyal-pwdsync-hook.exe
  File library.zip
  File python26.dll
#  File pywintypes26.dll
  ; gtk theme files
  File /r etc
  File /r lib
  File /r share
  ; passwdhk dll
  ${If} ${RunningX64}
    ${DisableX64FSRedirection}
    SetOutPath $SYSDIR
    File /oname=passwdHk.dll passwdhk64.dll
    ${EnableX64FSRedirection}
  ${Else}
    SetOutPath $SYSDIR
    File passwdHk.dll
  ${EndIf}
  SetOutPath $INSTDIR

  ; Make Shortcuts
  ReadRegStr $OUTDIR HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" "Common Administrative Tools"
  StrCmp $OUTDIR "" nocommon
  CreateShortCut "$OUTDIR\Zentyal Migration Tool.lnk" "$INSTDIR\zentyal-migration.exe"
nocommon:

  ; Install VC++ redistributable package
  SetOutPath $TEMP
  DetailPrint "Installing VC++ 2008 runtime"
  File vcredist_x86.exe
  ExecWait "$TEMP\vcredist_x86.exe /q"
  DetailPrint "Cleaning up"
  Delete $TEMP\vcredist_x86.exe

  SetOutPath $INSTDIR ; restore $OUTDIR

  DetailPrint "Running configuration wizard"
  ExecWait "$INSTDIR\zentyal-migration.exe"

  ; setup the service
  DetailPrint "Installing the service"
  ExecWait '"$INSTDIR\setup-service.bat" $INSTDIR'
  DetailPrint "Cleaning up"
  Delete "$INSTDIR\setup-service.bat"

  MessageBox MB_ICONEXCLAMATION|MB_OK "Warning: Make sure you enable the 'complexity requirements' under 'Password Policy' in 'Administrative Tools -> Domain Security Policy -> Account Policies'. Otherwise the password synchronization won't work."
  MessageBox MB_OK "Please restart before changes can take effect."

  ; write out uninstaller
  WriteUninstaller "$INSTDIR\uninst.exe"
SectionEnd ; end of default section


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) successfully uninstalled."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to uninstall $(^Name)?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  ExecWait '"$INSTDIR\zentyal-service-launcher.exe" -u'
  Delete "$INSTDIR\AUTHORS.txt"
  Delete "$INSTDIR\LICENSE.txt"
  Delete "$INSTDIR\README.passwdHk.txt"
  Delete "$INSTDIR\zentyal.ico"
  Delete "$INSTDIR\zentyal-logo.png"
  Delete "$INSTDIR\zentyal-migration.exe"
  Delete "$INSTDIR\zentyal-service-launcher.*"
  Delete "$INSTDIR\zentyal-pwdsync-service.exe"
  Delete "$INSTDIR\zentyal-pwdsync-hook.exe"
  Delete "$INSTDIR\getsid.vbs"
  Delete "$INSTDIR\migration.xml"
  Delete "$INSTDIR\atk.pyd"
  Delete "$INSTDIR\bz2.pyd"
  Delete "$INSTDIR\cairo._cairo.pyd"
  Delete "$INSTDIR\Crypto.Cipher.AES.pyd"
  Delete "$INSTDIR\_ctypes.pyd"
  Delete "$INSTDIR\freetype6.dll"
  Delete "$INSTDIR\gio._gio.pyd"
  Delete "$INSTDIR\glib._glib.pyd"
  Delete "$INSTDIR\gobject._gobject.pyd"
  Delete "$INSTDIR\gtk._gtk.pyd"
  Delete "$INSTDIR\intl.dll"
  Delete "$INSTDIR\libatk-1.0-0.dll"
  Delete "$INSTDIR\libcairo-2.dll"
  Delete "$INSTDIR\libexpat-1.dll"
  Delete "$INSTDIR\libfontconfig-1.dll"
  Delete "$INSTDIR\libgdk_pixbuf-2.0-0.dll"
  Delete "$INSTDIR\libgdk-win32-2.0-0.dll"
  Delete "$INSTDIR\libgio-2.0-0.dll"
  Delete "$INSTDIR\libglib-2.0-0.dll"
  Delete "$INSTDIR\libgmodule-2.0-0.dll"
  Delete "$INSTDIR\libgobject-2.0-0.dll"
  Delete "$INSTDIR\libgthread-2.0-0.dll"
  Delete "$INSTDIR\libgtk-win32-2.0-0.dll"
  Delete "$INSTDIR\libpango-1.0-0.dll"
  Delete "$INSTDIR\libpangocairo-1.0-0.dll"
  Delete "$INSTDIR\libpangoft2-1.0-0.dll"
  Delete "$INSTDIR\libpangowin32-1.0-0.dll"
  Delete "$INSTDIR\libpng14-14.dll"
  Delete "$INSTDIR\pangocairo.pyd"
  Delete "$INSTDIR\pango.pyd"
  Delete "$INSTDIR\select.pyd"
  Delete "$INSTDIR\_socket.pyd"
  Delete "$INSTDIR\_ssl.pyd"
  Delete "$INSTDIR\unicodedata.pyd"
#  Delete "$INSTDIR\win32security.pyd"
  Delete "$INSTDIR\zlib1.dll"
  Delete "$INSTDIR\library.zip"
#  Delete "$INSTDIR\pywintypes26.dll"
  Delete "$INSTDIR\python26.dll"
  ${If} ${RunningX64}
    ${DisableX64FSRedirection}
    Delete /REBOOTOK "$SYSDIR\passwdHk.dll"
    ${EnableX64FSRedirection}
  ${Else}
    Delete /REBOOTOK "$SYSDIR\passwdHk.dll"
  ${EndIf}
  RMDir /r "$INSTDIR\etc"
  RMDir /r "$INSTDIR\lib"
  RMDir /r "$INSTDIR\share"
  Delete "$INSTDIR\uninst.exe"
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Zentyal\Migration Tool"
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\zentyal-migration-tool"
  DeleteRegKey HKEY_LOCAL_MACHINE "SYSTEM\CurrentControlSet\Control\Lsa\passwdhk"
  ReadRegStr $OUTDIR HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" "Common Administrative Tools"
  Delete "$OUTDIR\Zentyal Migration Tool.lnk"
  RMDir "$INSTDIR"
SectionEnd

