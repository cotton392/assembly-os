memcpy:
        push    bp                          ;スタックフレームの構築
        mov     bp, sp

        push    ecx                         ;レジスタの保存
        push    esi
        push    edi

        cld                                 ;バイト単位でのコピー
        mov     di, [bp + 4]
        mov     si, [bp + 6]
        mov     cx, [bp + 8]

        rep movsb

        pop     edi                         ;レジスタの復帰
        pop     esi
        pop     ecx

        mov     esp, ebp                    ;スタックフレームの破棄
        pop     ebp

        ret
