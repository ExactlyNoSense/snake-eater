package idea.snakeskin.lang.lexer;

import com.intellij.lexer.FlexLexer;
import com.intellij.psi.tree.IElementType;

import static com.intellij.psi.TokenType.*;
import static idea.snakeskin.lang.psi.SsElementTypes.*;

%%

%{
  public SnakeskinLexer() {
    this((java.io.Reader)null);
  }
%}

%public
%class SnakeskinLexer
%implements FlexLexer
%function advance
%type IElementType
%unicode


// Whitespace
WHITE_SPACE_EOL = \R
WHITE_SPACE_LINE = [ \t]
WHITE_SPACE_CHAR = {WHITE_SPACE_EOL} | {WHITE_SPACE_LINE}
WHITE_SPACE = {WHITE_SPACE_CHAR}+

// Identifier
IDENTIFIER = [_\p{xidstart}][\p{xidcontinue}]*

// Number literals
DECIMAL_INTEGER_LITERAL = 0 | [1-9][0-9]*
EXPONENT = [Ee] [+-]? [0-9]+
DECIMAL_LITERAL = {DECIMAL_INTEGER_LITERAL} "." [0-9]* {EXPONENT}?
 | "." [0-9]* {EXPONENT}?
 | {DECIMAL_INTEGER_LITERAL} {EXPONENT}?

HEX_LITERAL = 0 [xX] [0-9a-fA-F]+
OCTAL_LITERAL = 0 [oO] [0-7]+
BINARY_LITERAL = 0 [bB] [01]+

NUMERIC_LITERAL = {DECIMAL_LITERAL} | {HEX_LITERAL} | {OCTAL_LITERAL} | {BINARY_LITERAL}

// String literal
DOUBLE_QUOTED_STRING_LITERAL = \"[^\r\n\"]*\"
SINGLE_QUOTED_STRING_LITERAL = '[^\r\n']*'
STRING_LITERAL = {DOUBLE_QUOTED_STRING_LITERAL} | {SINGLE_QUOTED_STRING_LITERAL}


// Comments
LINE_COMMENT = "///"[^\r\n]*{WHITE_SPACE_EOL}
COMMENT_BLOCK = {LINE_COMMENT}

%%
<YYINITIAL> {
  {WHITE_SPACE}         { return WHITE_SPACE; }

  "{"                   { return BRACE_OPEN; }
  "}"                   { return BRACE_CLOSE; }
  "["                   { return BRACK_OPEN; }
  "]"                   { return BRACK_CLOSE; }
  "("                   { return PAREN_OPEN; }
  ")"                   { return PAREN_CLOSE; }
  ":"                   { return COLON; }
  ";"                   { return SEMICOLON; }
  ","                   { return COMMA; }
  "."                   { return DOT; }
  "="                   { return EQ; }
  "=="                  { return EQ_EQ; }
  "==="                 { return EQ_EQ_EQ; }
  "#"                   { return SHARP; }
  "!"                   { return EXCLAMATION; }
  "!="                  { return NOT_EQ; }
  "!=="                 { return NOT_EQ_EQ; }
  "+"                   { return PLUS; }
  "++"                  { return PLUS_PLUS; }
  "+="                  { return PLUS_EQ; }
  "-"                   { return MINUS; }
  "--"                  { return MINUS_MINUS; }
  "-="                  { return MINUS_EQ; }
  "|"                   { return PIPE; }
  "||"                  { return PIPE_PIPE; }
  "|="                  { return PIPE_EQ; }
  "&"                   { return AMP; }
  "&&"                  { return AMP_AMP; }
  "&="                  { return AMP_EQ; }
  "~"                   { return TILDE; }
  "<"                   { return LT; }
  "<="                  { return LT_EQ; }
  "^"                   { return CARET; }
  "^="                  { return CARET_EQ; }
  "*"                   { return ASTERISK; }
  "*="                  { return ASTERISK_EQ; }
  "/"                   { return SLASH; }
  "/="                  { return SLASH_EQ; }
  "%"                   { return PERCENT; }
  "%="                  { return PERCENT_EQ; }
  ">"                   { return GT; }
  ">="                  { return GT_EQ; }
  "->"                  { return ARROW; }
  "?"                   { return QUESTION; }
  "@"                   { return AT; }
  "_"                   { return UNDERSCORE; }
  "$"                   { return DOLLAR; }
  "var"                 { return VAR; }
  "null"                { return NULL_LITERAL; }
  "undefined"           { return UNDEFINED_LITERAL; }
  true | false          { return BOOLEAN_LITERAL; }
  {STRING_LITERAL}      { return STRING_LITERAL; }
  {NUMERIC_LITERAL}     { return NUMERIC_LITERAL; }
  {COMMENT_BLOCK}       { return COMMENT_BLOCK; }
  {IDENTIFIER}          { return IDENTIFIER; }


}

[^] { return BAD_CHARACTER; }
