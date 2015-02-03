#stream utility
**chicken-scheme lazy stream**  
sicpの3章で出てくる遅延ストリーム用です  

##Usage
```scheme
(use mystream)
```
##Reference
####cons-stream
[procedure] ```(cons-stream x y)```  
return a lazy cons  
```scheme
	(define-syntax cons-stream
	  (syntax-rules ()
		((_ x y)
		  (cons x (delay y)))))
```
####stream-car, stream-cdr
stream-carはcarと等価です  
stream-cdrはlazy-consのcdr部をforceします  
####stream-null?, the-empty-stream
the-empty-streamは'()と、stream-null?はnull?と等価です  
####stream-ref
####stream-take
####stream-map
####stream-for-each
####stream-filter
####display-stream
####stream-enumerate-intarval
####integers-starting-from

