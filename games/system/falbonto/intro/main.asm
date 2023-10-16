;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; A betöltés utáni nyitókép oldala
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INTRO_SCREEN:
    LD HL, 0x8000 - 80
    LD DE, 0x8000 - 40
    LD BC, 40
    LDIR
    CALL ROM_READ_KEY_INTO_C_CY
    LD HL, TEXT
    LD DE, INTRO_SCROLL_SPEED
    CALL SCROLL_TEXT_INIT_HL_DE
    CALL EXX_INTRO_MUSIC_INIT
WAIT_FOR_I:
    CALL EXX_INTRO_MUSIC_NEXT
    CALL SCROLL_TEXT_NEXT_STEP
    CALL ANY_KEY_PRESSED_NZ_A_B1          ; A_ban az adat B-ben a címindex 1-től HL-ben az olvasott teljes cím
    JR Z, WAIT_FOR_I
    AND KEYBOARD_DATA_I
    JR NZ, WAIT_REMEGES
    LD A, B
    CP KEYBOARD_ADDRESS_INDEX1_I
    JR Z, INDULAS
WAIT_REMEGES:
    CALL REMEGES
    JR WAIT_FOR_I
INDULAS:
    CALL CLS2
    CALL SET_FULLTEXT_MODE
    CALL SHOW_INTRO_TEXT
    CALL SET_GRAPHMODE_192_UP
    RET

SHOW_INTRO_TEXT:
    CALL TEXT_CLS
    LD HL, HELPTEXT
    CALL PRINT_MULTILINE_TEXT_HL
SHOW_INTRO_TEXT_LOOP:
    LD A, (C_SCREEN_ADDR)
    XOR 128
    LD (C_SCREEN_ADDR), A
    LD A, (R_SCREEN_ADDR)
    XOR 128
    LD (R_SCREEN_ADDR), A
    LD A, (G_SCREEN_ADDR)
    XOR 128
    LD (G_SCREEN_ADDR), A
    LD A, (D_SCREEN_ADDR)
    XOR 128
    LD (D_SCREEN_ADDR), A

    LD A, GAME_MODE_TRAINING
    LD (GAME_MODE), A
    CALL KEY_G_PRESSED_Z
    RET Z

    LD A, GAME_MODE_PLAYER
    LD (GAME_MODE), A
    CALL KEY_CR_PRESSED_Z
    RET Z

    LD A, GAME_MODE_DEMO
    LD (GAME_MODE), A
    CALL KEY_D_PRESSED_Z
    RET Z

    JR SHOW_INTRO_TEXT_LOOP

include 'intro/effects.asm'

TEXT: DB "   ",115,119,145," FALBONTO 2023 ",145,119,115,"  NYOMJ ",201,"-T AZ INDULASHOZ ... (MAST NE! :)             ",0

C_SCREEN_ADDR: EQU 0xC300-80+16
R_SCREEN_ADDR: EQU C_SCREEN_ADDR+1
G_SCREEN_ADDR: EQU C_SCREEN_ADDR+40
D_SCREEN_ADDR: EQU G_SCREEN_ADDR+36

HELPTEXT: 
    DB "            FALBONTO 2023", 13, 13
    DB "EGY LABDAVAL KELL KIUTNI A FAL TEGLAIT.", 13
    DB "A LABDA NEM MEHET KI A JATEKTERROL.", 13
    DB "MOZGO UTOHOZ ERVE A LABDA IS ELMOZDUL.",13
    DB "VIGYAZAT, VANNAK TRUKKOS TEGLAK IS! :)", 13
    DB "HA MINDEN TEGLA ELFOGYOTT, UJ SZINTRE", 13
    DB "LEPHETSZ!", 13
    DB "IRANYITAS:", 13
    DB "  BALRA:  ",'B'+128,'A'+128,'L'+128,' '+128,'S'+128,'H'+128,'I'+128,'F'+128,'T'+128, 13
    DB "  JOBBRA: ",'J'+128,'O'+128,'B'+128,'B'+128,' '+128,'S'+128,'H'+128,'I'+128,'F'+128,'T'+128, 13
    DB "  FEL:    ",'A'+128, 13
    DB "  LE:     ",'Z'+128, 13
    ;DB "  LABDA INDITASA: ",'S'+128,'P'+128,'A'+128,'C'+128,'E'+128, 13
    DB "  VEGE:   ",'V'+128, 13
    DB 13,13
    DB "HA FELKESZULTEL, KEZDHETUNK:",13
    DB "NORMAL JATEK INDITASA: ",'C'+128,'R'+128, 13
    DB "GYAKORLO MOD INDITASA: ",'G'+128, 13
    DB "DEMO MOD INDITASA: ",'D'+128, 13
    DB 0