;确定可弹出的驱动器列表
DriveList = Empty
DriveGet, DriveList, List, REMOVABLE

if DriveList
    goto, start_eject

MsgBox, 没有需要弹出的驱动器
return

start_eject:

InputBox, Driveletter, 请输入要弹出的盘符 , %DriveList%
if ErrorLevel=1
    return

StringUpper, Driveletter, Driveletter ;将用户输入的盘符转换成大写

IfInString, Driveletter, %DriveList%
{
    Driveletter = %Driveletter%:
    hVolume := DllCall("CreateFile"
        , Str, "\\.\" . Driveletter
        , UInt, 0x80000000 | 0x40000000  ; GENERIC_READ | GENERIC_WRITE
        , UInt, 0x1 | 0x2  ; FILE_SHARE_READ | FILE_SHARE_WRITE
        , UInt, 0
        , UInt, 0x3  ; OPEN_EXISTING
        , UInt, 0, UInt, 0)
    if hVolume <> -1
    {
        DllCall("DeviceIoControl"
            , UInt, hVolume
            , UInt, 0x2D4808   ; IOCTL_STORAGE_EJECT_MEDIA
            , UInt, 0, UInt, 0, UInt, 0, UInt, 0
            , UIntP, dwBytesReturned  ; 不使用.
            , UInt, 0)
        DllCall("CloseHandle", UInt, hVolume)
    }
    
}
else
{
    Msgbox, 请输入一个列表中的盘符
    goto, start_eject
}