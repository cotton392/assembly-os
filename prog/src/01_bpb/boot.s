entry:
        jmp     ipl                         ;IPLへジャンプ

        times   90 - ($ - $$) db 0x90       ;BPB(BIOS Parameter Block)
        
ipl:                                        ;IPL(Initial Program Loader)
        jmp     $
        times   510 - ($ - $$) db 0x00
        db      0x55, 0xAA