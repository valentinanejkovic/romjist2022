PORT 1     EQU   0C00H
PORT2      EQU   0C01H
PORT3      EQU    0C02H
PORT4      EQU    1000H
PORT5      EQU    1001H
PORT6      EQU    1002H
PORT7      EQU    1800H
PORT8      EQU     1801H
PORT9      EQU     1802H
STEK        EQU     08FFH
REL           EQU    0800H
RBR          EQU     0802H
RLI            EQU     0804H
RLP           EQU     0805H
RDU          EQU     0807H
RTR           EQU     0809H
RBRM       EQU      080AH
VPOV       EQU      080BH
VDR         EQU       080CH
CONST    EQU       080DH
ADR         EQU       080EH
STOR       EQU       080FH
                ORG    00H
                PUSH  PSW
                PUSH  B
                PUSH  D
                PUSH  H
                JMP     PREK1
                HLT
PREK1:   LHLD   RDU
                INX      H
                SHLD  RDU  
                MOV    A,L
                DAA
                MOV    L,A
                MOV    A,H
                ACI       0H
                DAA
               MOV    H,A
               SHLD   PORT1
               EI
               POP       H
               POP       D
               POP       B
               POP       PSW
               RET
              ORG      40H
MNOZ: MOV      E,L
              MVI        D,0H
              MOV       A,H
              LXI          H,0H
              MVI        B,08D
LOOP1: DAD      H
               RAL 
               JNC        LOOP2
               DAD      D
LOOP2:  DCR   B
               JNZ         LOOP1
                 RET
                 ORG        80H
PRETV:   MVI   D,4D
                MVI         C,16D
                MVI          B,10D
JUMP1:  MVI    A,255D
               SUB         C
               MOV       E,A
               LDA        ADR
              ANA        C
              JZ             JUMP2
              LDA        ADR
              ANA        E
             ADD        B
             STA         ADR
JUMP2:  STC
            CMC
            MOV        A,C
            RAL
            MOV        C,A
            STC
            CMC
             MOV        A,B
             RAL
             MOV        B,A
             DCR          D
             JNZ          JUMP1
             RET
             ORG     COH
                LXI       H,0800H
                MVI      D,FFH
SKOK1:  MVI    M,0H
                INX        H
                DCR       D
                JNZ         SKOK1
                MVI       A,OH
                STA       PORT6
                STA       PORT7
                STA       PORT9
PET:       MVI       A,0H
               STA       RBR
               LHLD    PORT4
               MOV      A,L
               STA        ADR
               CALL     PRETV
               LDA       ADR
               STA        STOR
              MOV      A,H
              STA        ADR
              CALL     PRETV
               LDA       ADR
               MOV       H,A
               MVI         L,100H
               CALL      MNOZ
               MVI        D,0H
               LDA        STOR
               MOV       E,A
               DAD        D
SHLD      REL
               MVI         A,40H
               STA         PORT9
 SKOK2:  LDA      PORT8
                 ANI          16D
                 JNZ           SKOK2
                 LDA          RBR
                 INR            A
                 STA           RBR
SKOK3:   LDA      PORT8
                 ANI           16D
                 JNZ            SKOK3
                 LDA          PORT8
                 ANI           64D
                 JNZ            SKOK2
                LDA           RBR
                STA           PORT6
                MOV         L,A
                LDA          CONST
                MOV        H ,A
               CALL       MNOZ
               SHLD       RPR
               XCHG
SKOK4:    LHLD     RDU
                   DAD     D
                   SHLD   RLP
                   MOV     B,H
                   MOV     C,L
                   LHLD    REL
                 MOV     A,H
                 CMP      B
                 JNZ        SKOK4
                 MOV     A,L
                 CMP      C
                 JNZ       SKOK4
SKOK5:  LDA       RTR
                STA       PORT7
                INR        A
                STA        RTR
                MVI        A,01H
                STA        PORT9
SKOK6:  LDA      PORT 8
               ANI          20H
               JNZ           SKOK6
               LDA         PORT3
               STA          RBRM
               MVI          A,01H
               STA          PORT9
               LDA         RBRM
               MOV        E,A
               LDA         RBR
               CMP        E
               JNZ          SKOK5
               MVI        A,30H
                STA         PORT9
SKOK7:   LDA   PORT8
                 ANI          04H
                 JZ             SKOK7
                 MVI         A,08H
                 STA         PORT9
SKOK8:   LDA     PORT8    
                 ANI          08H
                 JZ             SKOK8
                 MVI         A,0H
                 STA         PORT9
                 MVI         L,0H
                 MVI         H,0H
                 SHLD       RDU
                 MVI         A,02H
                 STA         PORT9
                 MVI         A,06H
                 STA         PORT9
SKOK9:   LDA   PORT8
                 ANI          20H
                JNZ          SKOK9
                LDA        PORT3
                STA         VPOV
                MVI         A,0H
                STA         PORT9
                MVI         A,FFH
                STA         PORT6
SKO10:   LDA     RTR
               DCR         A
               STA         RTR
               STA         PORT7
               MOV       E,A
               LDA        VPOV
                 CMP        E
                 JNZ          SKO10
SKO11:    LDA  PORT8
                 ANI          02H
                 JZ             SKO11
                 MVI         A,03H
                 STA          PORT9   
                 MVI         A,07H
                STA         PORT9
SKO12:   LDA        PORT8
                ANI         20H
                JNZ          SKO12
                LDA        PORT3
                STA        VDR
                MVI        A,0H
                STA        PORT9
SKO13:  LDA  RTR
               INR        A
              STA        RTR
              MOV      E,A
              STA        PORT7
              LDA       VDR
              CMP       E
              JNZ        SKO13
              LDA      VDR
              STA       PORT6
              JMP       PET
              END 