        BOOT_LOAD       equ     0x7C00          ;ブートプログラムのロード位置

        ORG     BOOT_LOAD

%include    "../include/macro.s"

entry:                                          ;エントリポイント
        jmp     ipl                             ;IPLへジャンプ

        times   90 - ($ - $$) db 0x90           ;BPB(BIOS Parameter Block)
        
ipl:                                            ;IPL(Initial Program Loader)
        cli                                     ;割り込み禁止

        mov     ax, 0x0000
        mov     ds, ax
        mov     es, ax
        mov     ss, ax
        mov     sp, BOOT_LOAD

        sti                                     ;割り込み許可
        mov     [BOOT.DRIVE], dl                ;ブートドライブを保存

        cdecl   puts, .s0                       ;文字列の表示

        cdecl   reboot                          ;再起動して戻ってこない

        cdecl   itoa,  8086, .s1, 8, 10, 0b0001 ;数値の表示
        cdecl   puts, .s1

        cdecl   itoa,  8086, .s1, 8, 10, 0b0011
        cdecl   puts, .s1

        jmp     $

.s0     db "booting...", 0x0A, 0x0D, 0          ;データ定義
.s1     db "--------", 0x0A, 0x0D, 0

ALIGN 2, db 0
BOOT:
.DRIVE:         dw 0

%include    "../modules/real/puts.s"
%include    "../modules/real/itoa.s"
%include    "../modules/real/reboot.s"

        times   510 - ($ - $$) db 0x00          ;ブートフラグ(先頭512バイトの終了)
        db      0x55, 0xAA