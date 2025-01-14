;; Forked from tree-sitter-go
;; Copyright (c) 2014 Max Brunsfeld (The MIT License)

;;
; Identifiers

(type_identifier) @type
(type_spec name: (type_identifier) @type.definition)
(field_identifier) @property
(identifier) @variable
(package_identifier) @namespace

(parameter_declaration (identifier) @parameter)
(variadic_parameter_declaration (identifier) @parameter)

(label_name) @label

(const_spec
  name: (identifier) @constant)

; Function calls

(call_expression
  function: (identifier) @function.call)

(call_expression
  function: (selector_expression
    field: (field_identifier) @method.call))

; Function definitions

(function_declaration
  name: (identifier) @function)

(method_declaration
  name: (field_identifier) @method)

(method_spec 
  name: (field_identifier) @method) 

; Constructors

((call_expression (identifier) @constructor)
  (#lua-match? @constructor "^[nN]ew.+$"))

((call_expression (identifier) @constructor)
  (#lua-match? @constructor "^[mM]ake.+$"))

; Operators

[
  "=" @operator.assign
  ":=" @operator.declaration
]

[
  "+="
  "-="
  "*="
  "/="
  "%="
  "++"
  "--"
  "^="
  "|="
  "&="
  ">>="
  "<<="
] @operator.assign_combined

[
  "<-"
  "..."
] @operator.misc

(unary_expression
  operator: [ "*" "&" ] @operator.misc)

[
  "+" ;; TODO: can also be concat strings, we can't differentiate though, i.e. s := a + b
  "-"
  "/"
  "%"
] @operator.arithmetic

;; special case multiplication (*) to differentiate from pointer (*)
(binary_expression
  operator: "*" @operator.arithmetic)

[
  "~"
  "|"
  "^"
  "<<"
  ">>"
] @operator.bitwise

;; special case bitwise AND (&) to differentiate from take address (&)
(binary_expression
  operator: "&" @operator.bitwise)

[
  "<"
  "<="
  ">="
  ">"
  "=="
  "!="
] @operator.relational

[
  "!"
  "&&"
  "||"
] @operator.logical

; Keywords

[
  "break"
  "chan"
  "const"
  "continue"
  "default"
  "defer"
  "go"
  "goto"
  "interface"
  "map"
  "range"
  "select"
  "struct"
  "type"
  "var"
  "fallthrough"
] @keyword

"func" @keyword.function
"return" @keyword.return

"for" @repeat

[
  "import"
  "package"
] @include

[
  "else"
  "case"
  "switch"
  "if"
 ] @conditional


;; Builtin types

((type_identifier) @type.builtin
 (#any-of? @type.builtin
           "any"
           "bool"
           "byte"
           "complex128"
           "complex64"
           "error"
           "float32"
           "float64"
           "int"
           "int16"
           "int32"
           "int64"
           "int8"
           "rune"
           "string"
           "uint"
           "uint16"
           "uint32"
           "uint64"
           "uint8"
           "uintptr"))


;; Builtin functions

((identifier) @function.builtin
 (#any-of? @function.builtin
           "append"
           "cap"
           "close"
           "complex"
           "copy"
           "delete"
           "imag"
           "len"
           "make"
           "new"
           "panic"
           "print"
           "println"
           "real"
           "recover"))


; Delimiters

"." @punctuation.delimiter
"," @punctuation.delimiter
":" @punctuation.delimiter
";" @punctuation.delimiter

"(" @punctuation.bracket
")" @punctuation.bracket
"{" @punctuation.bracket
"}" @punctuation.bracket
"[" @punctuation.bracket
"]" @punctuation.bracket


; Literals

(interpreted_string_literal) @string
(raw_string_literal) @string @spell
(rune_literal) @string
(escape_sequence) @string.escape

(int_literal) @number
(float_literal) @float
(imaginary_literal) @number

[
 (true)
 (false)
] @boolean

(nil) @constant.builtin

(keyed_element
  . (literal_element (identifier) @field))
(field_declaration name: (field_identifier) @field)

; Comments

(comment) @comment @spell

;; Doc Comments

(source_file . (comment)+ @comment.documentation)

(source_file
  (comment)+ @comment.documentation
  . (const_declaration))

(source_file
  (comment)+ @comment.documentation
  . (function_declaration))

(source_file
  (comment)+ @comment.documentation
  . (type_declaration))

(source_file
  (comment)+ @comment.documentation
  . (var_declaration))

; Errors

(ERROR) @error

; Spell

((interpreted_string_literal) @spell
  (#not-has-parent? @spell import_spec))
