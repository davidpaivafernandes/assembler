
                ORIG    0200h        ; indication to where want to put the data

; =============================================================================
; SAMPLE DATA for testing:
; note that MEMORY CONTENT is a pretty basic concept for the program; note that
; for all purposes, STRINGA ends only, in fact, at the end of _ZERO, when
; the \0 finally appears. In fact, STRINGA its just a memory address

STRINGA         STR     'People who are more than casually interested in '
_A              STR     'computers should have at least some idea of what the '
_B              STR     'underlying hardware is like. Otherwise the programs '
_C              STR     'they write will be pretty weird.'
_D              STR     '      DONALD KN'
_TWO            STR     'UT'
_ONE            STR     'H'
_ZERO           STR     0

                ORIG    0f00h        ; indication to where we want to put the code

                MOV     R1, F000H    ; just move the stack away from the code
                MOV     SP, R1

                ; testing it
                PUSH    STRINGA
                PUSH    R0
                CALL    string_length
                POP     R7            ; R7 should show CB (213 characters)
                POP     R0

ZZZZZZZZZZZZZ:  BR      ZZZZZZZZZZZZZ


; ==============================================================================
; string_length - returns number of characters on a string
;                 knowing it should end with the usual \0
; ------------------------------------------------------------------------------
; arguments (passing by stack)
;    1 - string address
;    2 - return byte
; ------------------------------------------------------------------------------
; example:
;               PUSH    STRINGA        ; string address
;               PUSH    R0             ; reserving stack for the return value
;               CALL    string_length  ; call routine
;               POP     R7             ; R7 should get the return value
;               POP     R0             ; just consume the stack used
; ------------------------------------------------------------------------------
; remarks: 
;    it is register safe; if you want to get that safety in your own hands and
;    gain some speed, just remove the "PUSH before/POP after" usual mecanism
;    but remember to adjust de SP+x displacements accordingly
; ==============================================================================
           
string_length:  PUSH    R1              ; saving R1 content

                MOV     R1, M[SP+4]     ; string address
sl_1:           CMP     M[R1], R0       ; lets see if it is \0
                BR.Z    sl_8            ; yes it is; we're done
                INC     R1              ; no it wasn't lets see teh next one
                JMP     sl_1            
                
sl_8:           SUB     R1, M[SP+4]     ; ok lets see how much characters we saw
                MOV     M[SP+3], R1     ; putting that in the stack position
                                        ; reserved on the call
sl_9:           POP     R1              ; retrieving the R1 saved content
                RET                     ; and returning to the caller

