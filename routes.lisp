(in-package #:cronies)

(restas:define-route main-route ("/:something")
  (if (ppcre:scan "^.+\.js$" something)
      (restas:redirect 'js-route
                       :file-path something)
  (format nil "
<h1>some:~a</h1>
<h1>path:~a</h1>
<h1>hostname:~a</h1>
<h1>parameters:~a</h1>
<h1>user agent:~a</h1>"
          something
         (hunchentoot:request-uri hunchentoot:*request*)
         (hunchentoot:host hunchentoot:*request*)
         (hunchentoot:post-parameter "you")
         (hunchentoot:user-agent))))

(restas:define-route js-route ("/js/:file-path")
  (format nil "you are trying to download file ~a"
          file-path))

(defparameter *mtable-template*
  "{namespace tpl}
{template mtable}
<h1>Multiplication table</h1>
<table border=4>
{for $yi in range(0, $y + 1)}
<tr>
{if $yi == 0}
<th></th>
{for $xi in range(1, $x + 1)}
<th>{$xi}</th>
{/for}
{else}
<th>{$yi}</th>
{for $xi in range(1, $x + 1)}
<td>{$xi * $yi}</td>
{/for}
{/if}
</tr>
{/for}
</table>
{/template}")

(closure-template:compile-template :common-lisp-backend *mtable-template*)
(defparameter *mtable-js-template* (closure-template:compile-template :javascript-backend *mtable-template*))

(restas:define-route nul-table-route ("/mtable/:x/:y")

  (tpl:mtable `(:x ,(parse-integer x)
                :y ,(parse-integer y))))

(restas:define-route mul-js-table-route ("mjstable/:x/:y")
  (format nil "<head>
<script type=\"text/javascript\" src=\"http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js\">
</script>
</head>
<body>
<script type=\"text/javascript\">
~a
</script>
<script type=\"text/javascript\">
$(document).ready(function(){
data=new Object()
data.x = ~a
data.y = ~a
container=document.createElement('div')
container.innerHTML=tpl.mtable(data)
document.body.appendChild(container)
})
</script>
</body>" *mtable-js-template* (parse-integer x) (parse-integer y)))

(restas:define-route reload-counter ("/counter")
  (let ((cnt (hunchentoot:cookie-in "cronies.count")))
    (if cnt
        (progn
          (hunchentoot:set-cookie "cronies.count" :value (+ 1 (parse-integer cnt)))
          (format nil "<h1>count: ~a</h1>" cnt))
        (progn
          (hunchentoot:set-cookie "cronies.count" :value 2)
          (format nil "<h1>count: ~a</h1>" 1)))))