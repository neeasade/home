;; does not work
#lang racket
(require racket/draw racket/math)

(define s1 '(99 99))
(define s2 '(1 1))

(define wl 0.00000001)

(define D 0.00001)

(define wht '(0 0 0))
(define blk '(255 255 255))

(define (sq x)
  (* x x))

(define (path-difference y)
  (let ([d1 (sqrt (+ (sq (- D (car s1))) (sq (- y (cadr s1)))))]
        [d2 (sqrt (+ (sq (- D (car s2))) (sq (- y (cadr s2)))))])
    (- d1 d2)))

(define (get-path-factor n)
  (let ([m (/ n wl)])
    (- m (floor m))))

(define (color mix)
  (map (λ (l1 l2)
         (inexact->exact
          (round
           (+ (* (- 1 mix) l1)
              (* mix l2)))))
       wht blk))

(define img% (make-object bitmap% 100 50))
(define img-dc% (new bitmap-dc% [bitmap img%]))
(define clr% (make-object color%))

(define center (/ (send img% get-width) 2))

(define (color-object mix)
  (let ([cl (color mix)])
    (send clr% set (car cl) (cadr cl) (caddr cl))))

(andmap (λ (y)
          (color-object (get-path-factor (path-difference y)))
          (for ([x (in-range 0 50)])
            (send img-dc% set-pixel y x clr%)
            (send img-dc% set-pixel (+ center y) x clr%)))
        (range center))

(send img% save-file "img.png" 'png)
