#lang racket

(require 2htdp/image)
(require (for-syntax racket/base syntax/parse))
(require "color-names.rkt")
(require rackunit)

(define CHAR-OFFSET 300)

(define x (rectangle 20 20 "solid" "orangered"))

; retrieves the color object corresponding to a color's name
(define/contract (get-color color)
  (-> string? color?)
  (first (image->color-list (rectangle 1 1 "solid" color))))

; (colors->names Expr) : Expr
(define-syntax colors->names
  (syntax-parser
    [(_ c-list:expr)
     #'(map get-color c-list)]))

(define colors (colors->names color-names))

; converts a list of colors (representing an image) to text
(define/contract (colors->text colors width width/acc)
  (-> (listof color?) exact-nonnegative-integer? exact-nonnegative-integer? (listof char?))
  (cond [(empty? colors) empty]
        [(= width/acc (- width 0)) (cons #\newline (colors->text colors width 0))]
        [else (cons (color->char (first colors))
                                  (colors->text (rest colors) width (+ width/acc 1)))]))

; converts a color to a corresponding character
(define/contract (color->char color)
  (-> color? char?)
  (cond
    [(exact-nonnegative-integer? (index-of colors color)) (integer->char (+ CHAR-OFFSET (index-of colors color)))]
    [else (raise-syntax-error 'color "invalid image color" color)]))

; gets the dimensions of an image given text representation
(define/contract (dims text)
  (-> string? (listof exact-nonnegative-integer?))
  (list (string-find text "\n") (length (string-split (string-replace text "\n" " ")))))

; gets a color given the corresponding character
(define/contract (char->color char)
  (-> char? string?)
  (cond
    [(< (- (char->integer char) CHAR-OFFSET) (length color-names))
     (list-ref color-names (- (char->integer char) CHAR-OFFSET))]
    [else (raise-syntax-error 'color "character does not denote permitted color" char)]))

; writes a list of characters
(define (writec lst)
  (cond
    [(empty? lst) ""]
    [else (write-char (first lst)) (writec (rest lst))]))

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