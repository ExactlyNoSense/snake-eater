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

%{
  private boolean zzIsMultilineMode = false;
%}

%public
%class SnakeskinLexer
%implements FlexLexer
%function advance
%type IElementType
%unicode
%state LINE_READING, LINE_SPLITTING, END_OF_LINE_SPLITTING


// Whitespace
WS_EOL = \R
WS_LINE = [ \t]
WS = {WS_EOL} | {WS_LINE}

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
LINE_COMMENT = "///"[^\r\n]*{WS_EOL}
COMMENT_BLOCK = {LINE_COMMENT}

%%
<YYINITIAL> {
  {WS}+ { }
  [^\R \t] { yybegin(LINE_READING); yypushback(1); }
}

<LINE_READING> {

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

  "as"                  { return AS; }
  "global"              { return GLOBAL; }
  "include"             { return INCLUDE; }
  "interface"           { return INTERFACE; }
  "namespace"           { return NAMESPACE; }
  "placeholder"         { return PLACEHOLDER; }
  "var"                 { return VAR; }

  "null"                { return NULL_LITERAL; }
  "undefined"           { return UNDEFINED_LITERAL; }
  true | false          { return BOOLEAN_LITERAL; }
  {STRING_LITERAL}      { return STRING_LITERAL; }
  {NUMERIC_LITERAL}     { return NUMERIC_LITERAL; }
  {COMMENT_BLOCK}       { return COMMENT_BLOCK; }
  {IDENTIFIER}          { return IDENTIFIER; }

  {WS_LINE}             { return WHITE_SPACE; }

// Multiline declaration
  {WS_LINE} "&"         { yybegin(LINE_SPLITTING); }
  {WS} "."              { yybegin(END_OF_LINE_SPLITTING); }

  {WS_EOL}  {
    if (zzIsMultilineMode) {
      return WHITE_SPACE;
    } else {
      yybegin(YYINITIAL);
      return EOS;
    }
  }

  <<EOF>>  { yybegin(YYINITIAL); return EOS; }
}

<LINE_SPLITTING> {
  {WS_LINE}+  { return WHITE_SPACE; }
  {WS_EOL}  {
    if (!zzIsMultilineMode) {
      zzIsMultilineMode = true;
    }
    yybegin(LINE_READING);
    yypushback(yylength());
  }

  <<EOF>>  { yybegin(YYINITIAL); return EOS; }

  .  { yybegin(LINE_READING); yypushback(1); return AMP; }
}

<END_OF_LINE_SPLITTING> {
  {WS_LINE}+  { return WHITE_SPACE; }
  {WS_EOL}  {
    if (zzIsMultilineMode) {
      zzIsMultilineMode = false;
    }
    yybegin(LINE_READING);
    yypushback(yylength());
  }

  <<EOF>>  { yybegin(YYINITIAL); return EOS; }

  .  { yybegin(LINE_READING); yypushback(1); return DOT; }
}

[^] { return BAD_CHARACTER; }
