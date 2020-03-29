        BOOT_LOAD       equ     0x7C00          ;ブートプログラムのロード位置

        ORG     BOOT_LOAD

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

        jmp     $

ALIGN 2, db 0
BOOT:
.DRIVE:         dw 0

        times   510 - ($ - $$) db 0x00          ;ブートフラグ(先頭512バイトの終了)
        db      0x55, 0xAA