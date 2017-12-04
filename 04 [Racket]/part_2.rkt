#lang racket

(define (lines filename)
    (file->lines filename))

(define (advent4)
    (define counter 0)
    (for ([line (in-list (lines "input"))])
        (define words (string-split line))
        (define sorted-words
            (map (lambda (w)
                (sort (string->list w) char>?)) words))
        (define no-duplicates (remove-duplicates sorted-words))
        (if (equal? (length sorted-words) (length no-duplicates))
            (set! counter (add1 counter)) (void)))
    (printf "~s\n" counter))

(advent4)