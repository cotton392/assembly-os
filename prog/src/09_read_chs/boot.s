%include    "../include/macro.s"
%include    "../include/define.s"

        ORG     BOOT_LOAD                       ;ロードアドレスをアセンブラに指示

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
        mov     [BOOT + drive.no], dl           ;ブートドライブを保存

        cdecl   puts, .s0                       ;文字列の表示

        mov     bx, BOOT_SECT - 1               ;BXに残りのブートセクタ数を代入
        mov     cx, BOOT_LOAD + SECT_SIZE       ;CXに次のブートアドレスを代入

        cdecl   read_chs, BOOT, bx, cx          ;read_chsの返り値はAXレジスタに保存される

        cmp     ax, bx
.10Q:   jz      .10E                            ;セクタ読み込みに失敗した場合はエラーメッセージを表示
.10T:   cdecl   puts, .e0
        call    reboot
.10E:

        jmp     stage_2                         ;ブート処理を第二段階に移行

.s0     db "booting...", 0x0A, 0x0D, 0          ;データ定義
.e0     db "Error: sector read", 0

ALIGN 2, db 0
BOOT:
    istruc  drive                               ;ブートドライブに関する情報
        at  drive.no,       dw 0                ;ドライブ番号
        at  drive.cyln,     dw 0                ;C: シリンダ
        at  drive.head,     dw 0                ;H: ヘッド
        at  drive.sect,     dw 2                ;S: セクタ
    iend        

%include    "../modules/real/puts.s"
%include    "../modules/real/reboot.s"
%include    "../modules/real/read_chs.s"

        times   510 - ($ - $$) db 0x00          ;ブートフラグ(先頭512バイトの終了)
        db 0x55, 0xAA

stage_2:                                        ;ブート処理の第二段階
        cdecl   puts, .s0

        jmp     $                               ;処理の終了

.s0     db "2nd stage...", 0x0A, 0x0D, 0

        times   BOOT_SIZE - ($ - $$)   db 0    ;パディング(8KB)