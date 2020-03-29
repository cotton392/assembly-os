reboot:
        cdecl   puts, .s0                       ;再起動メッセージを表示

.10L:
        mov     ah, 0x10                        ;キー入力待ち
        int     0x16                            ;キー入力のBIOSコール

        cmp     al, ' '                         ;ALが「 」であったときにbreakする
        jne     .10L

        cdecl   puts, .s1                       ;改行

        int     0x19                            ;再起動のBIOSコール

.s0     db  0x0A, 0x0D, "Push SPACE key to reboot...", 0
.s1     db  0x0A, 0x0D, 0x0A, 0x0D, 0
