memcmp:
        push    bp                          ;スタックフレームの構築
        mov     bp, sp

        push    bx                          ;レジスタの保存
        push    cx
        push    dx
        push    si
        push    di

        cld                                 ;引数の取得
        mov     si, [bp + 4]
        mov     di, [bp + 6]
        mov     cx, [bp + 8]

        repe cmpsb                          ;バイト単位での比較
        jnz     .10F
        mov     ax, 0                       ;0(一致)をaxに代入
        jmp     .10E

.10F
        mov     ax, -1                      ;-1(不一致)をaxに代入

.10E
        pop     di                          ;レジスタの復帰
        pop     si
        pop     dx
        pop     cx
        pop     bx

        mov     sp, bp                      ;スタックフレームの破棄
        pop     bp

        ret