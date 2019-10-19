#lang racket/base

(define argv (current-command-line-arguments))

(define x1 (vector-ref argv 0))
(define x2 (vector-ref argv 1))
(define n 10)

(when (= 3 (vector-length argv))
  (set! n (string->number (vector-ref argv 2))))

(define (hex->rgb hex)
  (map (λ (x) (string->number x 16))
       (list (substring hex 1 3) (substring hex 3 5) (substring hex 5))))

(define (rgb->hex rgb)
  (foldl (λ (a str) (string-append str (number->string a 16)))
         "#" rgb))

(define r1 (hex->rgb x1))
(define r2 (hex->rgb x2))

(define (color mix)
  (rgb->hex
   (map (λ (l1 l2)
          (round (+ (* (- 1 mix) l1)
                    (* mix l2))))
        r1 r2)))

(for ([x (in-range n)])
  (printf "~a " (color (/ x n))))

(displayln "")
