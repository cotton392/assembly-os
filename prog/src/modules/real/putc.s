putc:
        push    bp                              ;スタックフレームの構築
        mov     bp, sp

        push    ax                              ;レジスタの保存
        push    bx

        mov     al, [bp + 4]                    ;出力文字を取得
        mov     ah, 0x0E                        ;テレタイプ式で1文字出力
        mov     bx, 0x0000                      ;ページ番号と文字色を0に設定
        int     0x10                            ;ビデオBIOSコール

        pop     bx                              ;レジスタの復帰
        pop     ax

        mov     sp, bp                          ;スタックフレームの破棄
        pop     bp

        ret