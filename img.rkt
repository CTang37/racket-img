#lang racket

(require 2htdp/image)
(require (for-syntax racket/base syntax/parse))
(require "color-names.rkt")
(require rackunit)

(define CHAR-OFFSET 300)

; retrieves the color object corresponding to a color's name
(define/contract (get-color color)
  (-> string? color?)
  (first (image->color-list (rectangle 1 1 "solid" color))))

(check-equal? (get-color "red") (color 255 0 0 255))

; (colors->names Expr) : Expr
(define-syntax colors->names
  (syntax-parser
    [(_ c-list:expr)
     #'(map get-color c-list)]))

(define colors (colors->names color-names))

; converts a color to a corresponding character
(define/contract (color->char color)
  (-> color? char?)
  (cond
    [(exact-nonnegative-integer? (index-of colors color)) (integer->char (+ CHAR-OFFSET (index-of colors color)))]
    [else (raise-syntax-error 'color "invalid image color" color)]))

(check-equal? (color->char (color 0 255 0 255)) #\Ũ)

; converts a list of colors (representing an image) to text
; invariant: width/acc is the current width of the text row
(define/contract (colors->text colors width width/acc)
  (-> (listof color?) exact-nonnegative-integer? exact-nonnegative-integer? (listof char?))
  (cond [(empty? colors) empty]
        [(= width/acc (- width 0)) (cons #\newline (colors->text colors width 0))]
        [else (cons (color->char (first colors))
                                  (colors->text (rest colors) width (+ width/acc 1)))]))

(check-equal? (colors->text (list (color 255 255 255 255) (color 0 0 0 255)) 2 0) '[#\Ư #\Ʒ])

; gets the dimensions of an image given text representation
(define/contract (dims text)
  (-> string? (listof exact-nonnegative-integer?))
  (list (string-find text "\n") (length (string-split (string-replace text "\n" " ")))))

(check-equal? (dims "ŨŨŨ\nŨŨŨ\n") '[3 2])

; gets a color's name given the corresponding character
(define/contract (char->color char)
  (-> char? string?)
  (cond
    [(< (- (char->integer char) CHAR-OFFSET) (length color-names))
     (list-ref color-names (- (char->integer char) CHAR-OFFSET))]
    [else (raise-syntax-error 'color "character does not denote permitted color" char)]))

(check-equal? (char->color #\ō) "yellow")

; (rep String) : Expr
; converts a textual representation to an image
(define-syntax rep
  (syntax-parser
    [(_ text:string)
     #'(color-list->bitmap (map char->color (string->list (string-replace text "\n" "")))
                      (first (dims text))
                      (second (dims text)))]))

; (image Expr) : String
; converts an image to a textual representation
(define-syntax image
  (syntax-parser
    [(_ img:expr)
     #'(list->string (colors->text (image->color-list img) (image-width img) 0))]))