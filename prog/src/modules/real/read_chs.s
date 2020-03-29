read_chs:
        push    bp                              ;スタックフレームの構築
        mov     bp, sp
        push    3                               ;リトライ回数
        push    0                               ;読み込みセクタ数

        push    bx                              ;レジスタの保存
        push    cx
        push    dx
        push    es
        push    si

        mov     si, [bp + 4]                    ;処理の開始

        mov     ch, [si + drive.cyln + 0]       ;CHにシリンダ番号(下位バイト)を代入
        mov     cl, [si + drive.cyln + 1]       ;CLにシリンダ番号(上位バイト)を代入
        shl     cl, 6                           ;CLを6ビット左にシフト
        or      cl, [si + drive.sect]           ;CLとセクタ番号のor演算

        mov     dh, [si + drive.head]           ;DHにヘッド番号を代入
        mov     dl, [si + 0]                    ;DLにドライブ番号を代入
        mov     ax, 0x0000                      ;AXに0x0000を代入
        mov     es, ax                          ;ESにセグメントを代入
        mov     bx, [bp + 8]                    ;BXにコピー先を代入

.10L:
        mov     ah, 0x02                        ;AHに読み込み命令を代入
        mov     al, [bp + 6]                    ;ALにセクタ数を代入

        int     0x13
        jnc     .11E

        mov     al, 0
        jmp     .10E
.11E:

        cmp     al, 0
        jne     .10E

        mov     ax, 0
        dec     word [bp - 2]
        jnz     .10L
.10E:
        mov     ah, 0                           ;ステータス情報は破棄

        pop     si                              ;レジスタの復帰
        pop     es
        pop     dx
        pop     cx
        pop     bx

        mov     sp, bp                          ;スタックフレームの破棄
        pop     bp

        ret