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

        mov     ah, 0x02                        ;AHに読み込み命令を代入
        mov     al, 1                           ;ALに読み込みセクタ数を代入
        mov     cx, 0x0002                      ;CXにシリンダ/セクタを代入
        mov     dh, 0x00                        ;DHにヘッド位置を代入
        mov     dl, [BOOT.DRIVE]                ;DLにドライブ番号を代入
        mov     bx, 0x7c00 + 512                ;BXにオフセットを代入
        int     0x13
.10Q:   jnc     .10E                            ;セクタ読み込みに失敗した場合はエラーメッセージを表示
.10T:   cdecl   puts, .e0
        call    reboot
.10E:

        jmp     stage_2                         ;ブート処理を第二段階に移行

.s0     db "booting...", 0x0A, 0x0D, 0          ;データ定義
.e0     db "Error: sector read", 0

ALIGN 2, db 0
BOOT:
.DRIVE:         dw 0

%include    "../modules/real/puts.s"
%include    "../modules/real/reboot.s"

        times   510 - ($ - $$) db 0x00          ;ブートフラグ(先頭512バイトの終了)
        db 0x55, 0xAA

stage_2:                                        ;ブート処理の第二段階
        cdecl   puts, .s0

        jmp     $                               ;処理の終了

.s0     db "2nd stage...", 0x0A, 0x0D, 0

        times   (1024 * 8) - ($ - $$)   db 0    ;パディング(8KB)