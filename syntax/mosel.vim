" Vim syntax file
" Language: Mosel
" Current Maintainer: Sebastien Lannez <SebastienLannez@fico.com>
" Version: 1.0
" Last Change: July 2013
" Contributors: Yves Colombani <YvesColombani@fico.com>

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syntax case ignore

" List of keywords and operators
syn keyword moselOperator	and div in mod not or sum prod min max
syn keyword moselOperator	inter union
syn keyword moselStatement	is_binary is_continuous is_free is_integer
syn keyword moselStatement	is_partint is_semcont is_semint is_sos1 is_sos2
syn keyword moselStatement	uses options include
syn keyword moselStatement	forall while break next
syn keyword moselStatement	forward
syn keyword moselStatement	to from
syn keyword moselStatement	as case
syn keyword moselStatement	else elif then
syn keyword moselStatement	array boolean integer real set string
syn keyword moselStatement	linctr mpvar of dynamic range
syn keyword moselStatement	list record imports requirements 
syn keyword moselStatement	package contained
syn keyword moselStatement	version
syn keyword moselConstant	true false

syn keyword moselTodo contained	TODO YCO BUG

" In case someone wants to see the predefined functions/procedures
if exists("mosel_functions")
 syn keyword moselFunction	setparam getparam create fopen fclose
 syn keyword moselFunction	write writeln read readln exists fselect
 syn keyword moselFunction	getfid getsize getfirst getlast substr strfmt
 syn keyword moselFunction	maxlist minlist sqrt sin cos arctan
 syn keyword moselFunction	isodd bittest random log finalize finalise
 syn keyword moselFunction	getsol getobjval getrcost getdual getslack
 syn keyword moselFunction	getact ishidden sethidden gettype settype
 syn keyword moselFunction	getcoeff setcoeff getvars exit fflush
 syn keyword moselFunction	makesos1 makesos2 iseof exportprob
 syn keyword moselFunction	fskipline setrandseed
 syn keyword moselFunction	ceil round
 syn keyword moselFunction	load compile run

 " mmsystem
 syn keyword moselFunction	gettime
 syn keyword moselFunction	fdelete 

 " mmjobs
 syn keyword moselFunction	getfromid modid disconnect 

endif

" (De)Select IVE style
fun! Mosel_symbopt(p)
 if a:p==1
  let mosel_symbol_operator=1
  syn match   moselSymbolOperator      "[:<>+-/*=\^.;]"
  syn match   moselSymbolOpStat        "[\[{}\]]"
  syn match   moselSymbolOpStat        "(!\@!"
  syn match   moselSymbolOpStat        "!\@<!)"
 else
   syn clear moselSymbolOperator
   syn clear moselSymbolOpStat
   unlet mosel_symbol_operator
 endif
endfunc

if exists("mosel_symbol_operator")
 call Mosel_symbopt(1)
endif

" String
  "wrong strings
"  syn region  moselStringError matchgroup=moselStringError start=+'+ end=+'+ end=+$+
"  syn region  moselStringError matchgroup=moselStringError start=+"+ end=+"+ end=+$+ contains=moselStringEscape

  "right strings
  syn match   moselStringEscape	contained '\\.'
  syn region  moselString matchgroup=moselString start=+'+ end=+'+ 
	\ oneline
  syn region  moselString matchgroup=moselString start=+"+ end=+"+ 
	\ oneline contains=moselStringEscape
  " To see the start and end of strings:
" syn region  moselString matchgroup=moselStringError start=+'+ end=+'+ oneline


" Format for identifiers and numbers
"syn match  moselIdentifier	display	"\<[a-zA-Z_][a-zA-Z0-9_]*\>"
syn match  moselNumber	display	"-\=\<\d\+\>"
syn match  moselNumber	display	"-\=\<\d\+\.\d\+\>"
syn match  moselNumber	display	"-\=\<\d\+\.\d\+[eE]-\=\d\+\>"
syn match  moselNumber	display	"-\=\<\d\+[eE]-\=\d\+\>"

" To make <TABS> visible
if exists("mosel_no_tabs")
  syn match moselShowTab "\t"
endif


" List of blocks
syn region moselModel matchgroup=moselStatement 
      \ start=/^\s*model/ end=/^\s*end-model/ 
      \ transparent fold 
syn region moselPackage matchgroup=moselStatement 
      \ start=/^\s*package/ end=/^\s*end-package/ 
      \ transparent fold 
syn cluster mRoot add=moselModel,moselPackage

syn region moselParam matchgroup=moselStatement
      \ start=/^\s*parameters/ end=/^\s*end-parameters/ 
      \ containedin=moselModel transparent fold
syn region moselDeclr matchgroup=moselStatement
      \ start=/^\s*declarations/ end=/end-declarations/ 
      \ containedin=@mRoot transparent fold
syn region moselPDecl matchgroup=moselStatement
      \ start=/^\s*public\s*declarations/ end=/end-declarations/ 
      \ containedin=@mRoot transparent fold
syn region moselIniti matchgroup=moselStatement
      \ start=/^\s*initiali[sz]ations/ end=/end-initiali[sz]ations/ 
      \ containedin=@mRoot transparent fold
syn cluster mDatadef add=moselParam,moselDeclr,modelPDecl

syn region moselProc matchgroup=moselStatement
      \ start=/^\s*procedure\|^\s*public\s*procedure/ end=/^\s*end-procedure/ 
      \ containedin=@mRoot transparent fold
syn region moselFunc matchgroup=moselStatement
      \ start=/^\s*function\|^\s*public\s*function/ end=/^\s*end-function/
      \ containedin=@mRoot transparent fold
syn cluster mMethod add=moselProc,moselFunc

syn region moselBlock matchgroup=moselStatement
      \ start=/[^-]do/ end=/end-do/ 
      \ contained transparent fold
syn region moselIf matchgroup=moselStatement
      \ start=/[^-]if/ end=/end-if/ 
      \ contained transparent fold

syn region moselBlock matchgroup=moselStatement
      \ start=/\s*repeat/ end=/until/ 
      \ contained transparent fold

" Enable manual fodling
syn region moselFold matchgroup=moselComment
      \ start="{{{" end="}}}"                 
      \ transparent fold

" Format of comments
syn region moselComment
      \ start="(!" end="!)" contains=moselTodo fold
syn region moselComment
      \ start="!" end="$" contains=moselTodo
" syn cluster mComment add=moselCommentA,moselCommentB

function! MoselFoldText()
  let nl = v:foldend - v:foldstart + 1
  let comment = substitute(getline(v:foldstart),".*","\\0","g")
  let txt = '+ (' . nl . ' lines) ' . comment
  return txt
endfunction


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_mosel_syn_inits")
  if version < 508
    let did_mosel_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink moselComment		Comment
if !exists("mosel_only_comments")
  HiLink moselConstant		Constant
  HiLink moselNumber		Constant
  HiLink moselString		String
  HiLink moselStringEscape	Special
  HiLink moselStringError	Error
  HiLink moselIdentifier	Identifier
  HiLink moselException		Exception
  HiLink moselFunction		Function
  HiLink moselOperator		Operator
  HiLink moselStatement		Statement
  HiLink moselSymbolOperator	Operator
  HiLink moselSymbolOpStat	Statement
  HiLink moselTodo		Todo
  HiLink moselError		Error
  HiLink moselShowTab		Error

  HiLink mRoot  	        Statement
endif

  delcommand HiLink
endif

syn sync fromstart
set foldtext=MoselFoldText()
set foldmethod=syntax

let b:current_syntax = "mosel"

" vim: ts=8 sw=2
