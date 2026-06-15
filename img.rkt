#lang racket

(require 2htdp/image)
(require (for-syntax racket/base syntax/parse))
(require "color-names.rkt")
(require rackunit)

(define CHAR-OFFSET 300)

(define x (rectangle 20 20 "solid" "orangered"))

(define/contract (get-color color)
  (-> string? color?)
  (first (image->color-list (rectangle 1 1 "solid" color))))

(define-syntax colors->names
  (syntax-parser
    [(_ c-list:expr)
     #'(map get-color c-list)]))

(define colors (colors->names color-names))

(define/contract (image->text img)
  (-> image? string?)
  (list->string (colors->text (image->color-list img) (image-width img) 0)))

(define/contract (colors->text colors width width/acc)
  (-> (listof color?) exact-nonnegative-integer? exact-nonnegative-integer? (listof char?))
  (cond [(empty? colors) empty]
        [(= width/acc (- width 0)) (cons #\newline (colors->text colors width 0))]
        [else (cons (color->char (first colors))
                                  (colors->text (rest colors) width (+ width/acc 1)))]))

(define/contract (color->char color)
  (-> color? char?)
  (cond
    [(exact-nonnegative-integer? (index-of colors color)) (integer->char (+ CHAR-OFFSET (index-of colors color)))]
    [else (raise-syntax-error 'color "invalid image color" color)]))

; converts a text representation to an image
(define/contract (text->image text)
  (-> string? image?)
  (color-list->bitmap (map char->color (string->list (string-replace text "\n" "")))
                      (first (dims text))
                      (second (dims text))))

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

(define (writec lst)
  (cond
    [(empty? lst) ""]
    [else (write-char (first lst)) (writec (rest lst))]))

(writec (colors->text (image->color-list x) (image-width x) 0))

(define-syntax img
  (syntax-parser
    [(_ img:expr)
     #'(image->text img)]))

(img x)