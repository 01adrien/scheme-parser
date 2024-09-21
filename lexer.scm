(load "distribution.scm")

; Read a string token.
(define (read-string)
  (if (read-start #\" "not a string") 
      (read-string-tail '()) 
  )
)


; Read the rest of a string literal.
(define (read-string-tail read-so-far)
  (let ((char (get-non-eof-char))) 
    (cond ((char=? char #\") 
           (token-make 'string (list->string (reverse read-so-far))))
          ((char=? char #\\) 
           (read-string-tail (cons (read-escaped) read-so-far)))
          ((read-string-tail (cons char read-so-far)))
    )
  )
)

; Read the rest of an escape sequence.
(define (read-escaped)
  (let ((char (get-non-eof-char)))
    (if (or (char=? char #\") (char=? char #\\))
        char
        (error "invalid input for escape sequence")
    )
  )
)


; Read a boolean token.
(define (read-boolean)
  (if (read-start #\# "not a boolean") ; boolean starts with #
      (read-boolean-tail)
  )
)


; Read the rest of a boolean literal.
(define (read-boolean-tail)
  (let ((next-char (get-non-eof-char)))
    (cond ((char=? next-char #\f)
            (token-make 'boolean #f))
          ((char=? next-char #\t)
            (token-make 'boolean #t))
          (error "invalid boolean")
    )
  ) 
)


; Read a character token.
(define (read-character)
  (if (and (read-start #\# "not a character")  ; character must start
           (read-start #\\ "not a character")) ; with #\
      (read-character-tail)
  )
)


; Read the rest of a character literal.
(define (read-character-tail)
  (let ((char (read-char)) )
    (cond ((delimiter? (peek-char)) 
            (token-make 'character char))
          ((space? char) 
            (token-make 'character #\space))
          ((newline? char)
            (token-make 'character #\newline))
          ((tab? char)
            (token-make 'character #\tab))
          (error "invalid character ")
    )
  ) 
)


; Determine if the given character is a sign character.
(define (sign? char)
  (or (char=? char #\+) (char=? char #\-))
)


; Determine if the given character is a digit.
(define (digit? char)
  (and (char>=? char #\0) (char<=? char #\9))
)


; Determine if the given character is a letter.
(define (letter? char)
  (and (char>=? (char-downcase char) #\a) (char<=? (char-downcase char) #\z))
)


(define (list->number vals)
  (string->number (list->string vals)))


(define (read-number-tail read-so-far decimal-flag)
   (let ((char (peek-char)))
    (cond ((delimiter? char) 
            (token-make 'number (list->number (reverse read-so-far))))
          ((and (sign? char) (zero? (length read-so-far)))
            (read-number-tail (cons (read-char) read-so-far) decimal-flag))
          ((digit? char)
            (read-number-tail (cons (read-char) read-so-far) decimal-flag))
	  ((and (char=? char #\.) (not decimal-flag))
	    (read-number-tail (cons (read-char) read-so-far) #t))
          (error "invalid number")
    )
  ) 
)

; Read a number token.
(define (read-number)
   (read-number-tail '() #f)
)


(define (string-downcase str)
  (define (fn str-as-list res-str)
    (if (null? (cdr str-as-list))
      (string-append res-str (string (char-downcase (car str-as-list))))
      (fn 
        (cdr str-as-list) 
        (string-append res-str (string (char-downcase (car str-as-list))))
      )
    )
  )
  (fn (string->list str) "")
)



(define extended-char '(#\! #\$ #\% #\& #\* #\+ #\- #\. #\/ #\: #\< #\= #\> #\? #\@ #\^ #\_ #\~))
; Read an identifier token.
(define (read-identifier)
  (let ((char (peek-char)))
    (if (and (not (member char extended-char)) (not (letter? char)))
      (error "invalid char")
      (token-make 'identifier (string->symbol (string-downcase (read-to-whitespace '()))))
    )
  )  
)



; Read a punctuator token (i.e. one of ( ) #( . ' ` , ,@ ).
(define (read-punctuator)
  '() ; replace with your code
)


; Read a comment. Discards the data and returns an unspecified value.
(define (read-comment)
  (if (read-start #\; "not a comment")
      (read-comment-tail)
  )
)

; Read the rest of a comment.
(define (read-comment-tail)
  (clear-line)
)


; Read a token, which can be a boolean, character, string, identifier,
; number, or punctuator. Discards whitespace and comments.
(define (read-token)
  (let ((next-char (peek-char)))
    (cond ((eof-object? next-char) ; eof
           (read-char)) ; just return eof
          ((whitespace? next-char) ; whitespace
           (read-char) ; discard it
           (read-token)) ; read another token
          ((char=? next-char #\;) ; comment
           (read-comment) ; discard it
           (read-token)) ; read another token
          ; complete this procedure
          (else
           (error "bad token"))
    )
  )
)

; Lexer interface: reads all data from standard input and produces a
; list of tokens if no error arises. Aborts if there is an error.
(define (tokenize)
  (tokenize-tail '())
)

(define (tokenize-tail read-so-far)
  (let ((next-token (read-token)))
    (if (eof-object? next-token)
        (reverse read-so-far)
        (tokenize-tail (cons next-token read-so-far))
    )
  )
)
