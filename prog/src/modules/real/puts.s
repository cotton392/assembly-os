puts:
        push    bp                              ;スタックフレームの構築
        mov     bp, sp

        push    ax                              ;レジスタの保存
        push    bx
        push    si

        mov     si, [bp + 4]                    ;SIに文字列のアドレスを代入

        mov     ah, 0x0E                        ;テレタイプ式で1文字出力
        mov     bx, 0x0000                      ;ページ番号と文字色を0に設定
        cld                                     ;DFに0を代入しアドレスを加算

.10L:
        lodsb

        cmp     al, 0                           ;ALが0である場合break、そうでない場合は文字を出力して.10Lの先頭に戻る
        je      .10E

        int     0x10
        jmp     .10L
.10E:

        pop     si                              ;レジスタの復帰
        pop     bx
        pop     ax

        mov     sp, bp                          ;スタックフレームの破棄
        pop     bp

        ret