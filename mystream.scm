;;; mystream.scm
(module mystream
  *
  (import scheme chicken srfi-1 posix extras)

  (define-syntax cons-stream
    (syntax-rules ()
      ((_ x y)
       (cons x (delay y)))))
  (define (stream-car stream)
    (car stream))
  (define (stream-cdr stream)
    (force (cdr stream)))
  (define the-empty-stream '())
  (define (stream-null? z)
    (null? z))
  
  (define (stream-ref s n)
    (if (= n 0)
        (stream-car s)
        (stream-ref (stream-cdr s) (- n 1))))
  (define (stream-take stream n)
    (if (or (stream-null? stream) (zero? n)) '()
        (cons (stream-car stream)
              (stream-take (stream-cdr stream) (sub1 n)))))
    
  (define (stream-map proc . argstreams)
    (if (any stream-null? argstreams)
        the-empty-stream
        (cons-stream
         (apply proc (map stream-car argstreams))
         (apply stream-map
                (cons proc (map stream-cdr argstreams))))))
  (define (stream-for-each proc . argstreams)
    (if (any stream-null? argstreams)
        'done
        (begin (apply proc (map stream-car argstreams))
               (apply stream-for-each
                      (cons proc (map stream-cdr argstreams))))))

  (define (stream-fold proc base head . argstreams)
    (if (any stream-null? (cons head argstreams)) base
        (apply stream-fold proc (apply proc base (map stream-car (cons head argstreams)))
               (stream-cdr head)
               (map stream-cdr argstreams))))

  (define (stream-append . argstreams)
    (if (null? argstreams) the-empty-stream
        (let ((1st-stream (car argstreams)))
          (if (null? 1st-stream)
              (apply stream-append (cdr argstreams))
              (cons-stream (stream-car 1st-stream)
                           (apply stream-append (cons (stream-cdr 1st-stream)
                                                      (cdr argstreams))))))))
  
  (define (stream-filter pred stream) ;真なる要素を一つ見つけるまでforceし続ける
    (cond ((stream-null? stream) the-empty-stream)
          ((pred (stream-car stream))
           (cons-stream (stream-car stream)
                        (stream-filter pred
                                       (stream-cdr stream))))
          (else
           (stream-filter pred
                          (stream-cdr stream)))))

  (define (list->stream lst)
    (cond ((null? lst) the-empty-stream)
          (else (cons-stream (car lst)
                             (list->stream (cdr lst))))))
  (define (stream->list stream)
    (cond ((stream-null? stream) '())
          (else (cons (stream-car stream) (stream->list (stream-cdr stream))))))
  
  
  (define (display-stream s)
    (stream-for-each (lambda (x) (pp x) (sleep 1)) s))

  (define-syntax stream-of
    (syntax-rules (in is)
      ((_ (var in stream) clause)
       (stream-map (lambda (var)
                     clause)
                   stream))))

  (define (stream-starting-from n #!optional (step (lambda (x) (+ x 1))))
    (cons-stream n (stream-starting-from (step n) step)))
  
  (define (stream-enumerate-intarval low high #!optional (step 1))
    (if (> low high)
        the-empty-stream
        (cons-stream
         low
         (stream-enumerate-intarval (+ low step) high))))

  (define (make-inf-stream #!optional (fill 0))
    (cons-stream fill (make-inf-stream fill)))
  
  (define (integers-starting-from n #!key (step 1))
    (cons-stream n (integers-starting-from (+ n step))))
  
  (define integers (integers-starting-from 1))  

  )
