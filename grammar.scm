; Lexer for Scheme. The following is the lexical specification that it
; handles:
;
; <token> --> <identifier> | <boolean> | <number>
;     | <character> | <string> | ( | ) | #( | ' | ` | , | ,@ | .
;
; <delimiter> --> <whitespace> | ( | ) | " | ;
;
; <whitespace> --> <space or newline>
;
; <comment> --> ; <all subsequent characters up to a line break>
;
; <atmosphere> --> <whitespace> | <comment>
;
; <intertoken space> --> <atmosphere>*
;
; <identifier> --> <initial> <subsequent>*  | <peculiar identifier>
;
; <initial> --> <letter> | <special initial>
;
; <letter> --> [a-z]
;
; <special initial> --> ! | $ | % | & | * | / | : | < | =
;     | > | ? | ^ | _ | ~
;
; <subsequent> --> <initial> | <digit> | <special subsequent>
;
; <digit> --> [0-9]
;
; <special subsequent> --> + | - | . | @
;
; <peculiar identifier> --> + | - | ...
;
; <boolean> --> #t | #f
;
; <character> --> #\ <any character> | #\ <character name>
;
; <character name> --> space | newline
;
; <string> --> " <string element>* "
;
; <string element> --> <any character other than " or \>
;     | \" | \\
;
; <number> --> <integer> | <decimal>
;
; <integer> --> <sign> <digit>+
;
; <decimal> --> <sign> <digit>+ . <digit>* | <sign> . <digit>+
;
; <sign> --> <empty> | + | -
