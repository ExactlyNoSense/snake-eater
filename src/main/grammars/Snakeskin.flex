package idea.snakeskin.lang.lexer;

import com.intellij.lexer.FlexLexer;
import com.intellij.psi.tree.IElementType;

import java.util.*;
import static com.intellij.psi.TokenType.*;
import static idea.snakeskin.lang.psi.SsElementTypes.*;

%%

%{
  /**
  * When the lexer is using as syntax highlighter, LexerEditorHighlighter
  * checks if start position, state and token type are the same after
  * each new token. But when the lexer generates DEDENT tokens, it doesn't
  * change its position, state and token type. So that leads to
  * exception in LexerEditorHighlighter. To prevent this, the hack was
  * implemented:
  * cretead two absolutely the same dedent states
  * dedent states swap after each DEDENT token generation
  *
  * @param isHighlighter - true if the lexer is using for highlighting
  */
  public SnakeskinLexer(boolean isHighlighter) {
    this(null);
    indentionStack.push(0);
    zzIsHighlighter = isHighlighter;
  }
%}

%{
  private boolean zzIsMultilineMode = false;
  private boolean zzFromTemplate = false;
  private int currentDirectiveState = -1;
  private boolean zzIsHighlighter = false;
  private int zzNextDedentState = DEDENT_BLOCK;

  private Stack<Integer> indentionStack = new Stack<>();
  private int currentIndent = 0;

  private boolean zzIsInterpolationMode = false;
  private int zzInterpolationBracesCount = 0;
  private int zzLastInterpolationDirective = -1;
  private InterpolationStart zzInterpolationStart = InterpolationStart.NONE;

  private enum InterpolationStart {
    NONE,
    TAG,
    CLASS,
    ID,
    ATTR,
    ATTR_VALUE,
    LITERAL
  }

  private IElementType endStatement(boolean isEof) {
    if (isEof) {
      toDedent();
    }
    else {
      yybegin(YYINITIAL);
    }
    currentIndent = 0;
    return EOS;
  }

  private void toDedent() {
    yybegin(zzNextDedentState);
    if (zzIsHighlighter) {
      zzNextDedentState = zzNextDedentState == DEDENT_BLOCK ? DEDENT_BLOCK_2 : DEDENT_BLOCK;
    }
  }

  private IElementType toXmlParsing(IElementType tagType) {
    currentDirectiveState = XML_DIRECTIVE;
    yybegin(XML_DIRECTIVE);
    return tagType;
  }

  // expects '{WS_LINE} "&"' rule
  private IElementType toStartOfLineSplitting() {
    // returns AMP to stream
    yypushback(1);
    yybegin(CHECK_LINE_SPLITTING);
    return WHITE_SPACE;
  }

  // expects '{WS_LINE} "."' or '{WS_EOL} "."' rules
  // for prefix '{WS_LINE}' argument isEndOfLine should be false
  // for prefix '{WS_EOL}' argument isEndOfLine should be true
  private IElementType toEndOfLineSplitting(boolean isEndOfLine) {
    // returns DOT to stream
    yypushback(1);

    if (!zzIsMultilineMode) {
      return isEndOfLine ? endStatement(false) : WHITE_SPACE;
    }

    yybegin(CHECK_END_OF_LINE_SPLITTING);
    return WHITE_SPACE;
  }
%}

%public
%class SnakeskinLexer
%implements FlexLexer
%function advance
%type IElementType
%unicode
%state CONTROL_DIRECTIVE, XML_DIRECTIVE, TEMPLATE_DIRECTIVE
%state START_CONTROL_DIRECTIVE
%state TAG_INTERPOLATION_END, CSS_SELECTORS_INTERPOLATION_END, ATTR_INTERPOLATION_END
%state CSS_SELECTORS, CSS_SELECTORS_INTERPOLATION_START
%state XML_ATTRS, XML_ATTR_VALUE, XML_ATTR_MULTILINE_VALUE, LITERAL
%state CHECK_LINE_SPLITTING, START_OF_LINE_SPLITTING, CHECK_END_OF_LINE_SPLITTING, END_OF_LINE_SPLITTING
%state INDENT_BLOCK, DEDENT_BLOCK, DEDENT_BLOCK_2


// Whitespace
WS_EOL = \R
WS_LINE = [ \t]
WS = {WS_EOL} | {WS_LINE}

// Identifiers
IDENTIFIER = [_\$\p{xidstart}][\$\p{xidcontinue}]*
WITH_IDENTIFIER = @[_\$\p{xidstart}][\$\p{xidcontinue}]*
GLOBAL_IDENTIFIER = @@[_\$\p{xidstart}][\$\p{xidcontinue}]*

XML_ID_START = [-@_:a-zA-Z]
XML_ID_CONTINUE = [-_:a-zA-Z0-9]
XML_IDENTIFIER = {XML_ID_START} {XML_ID_CONTINUE}*

CSS_NAME_CONTINUE = \$|([^ \t\r\n\$\#\.\[\]\\]|\$[^ \t\r\n\{\#\.\[\]\\])([^ \t\n\r\$\#\.\[\]\\]|\$[^ \t\n\r\{\#\.\[\]\\])*\$?
CSS_CLASS_SELECTOR = \.{CSS_NAME_CONTINUE}?
CSS_ID_SELECTOR = #{CSS_NAME_CONTINUE}

ATTR_NAME = \$|([^ \t\r\n\$]|\$[^ \t\r\n\{])([^ \t\n\r\$]|\$[^ \t\n\r\{])*\$?

PLACEHOLDER = "%" ~"%"

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

// Regular expression
REGEXP_LITERAL = "/" ~"/" {REGEXP_FLAGS}?
REGEXP_FLAGS = [gimsuy]+

// Comments
LINE_COMMENT = "///".*
BLOCK_COMMENT = "/*"~"*/"
COMMENT = {LINE_COMMENT} | {BLOCK_COMMENT}

%%
<YYINITIAL> {
  {WS_LINE}  {
        currentIndent += yylength();
        return WHITE_SPACE;
      }
  {WS_EOL}  {
        currentIndent = 0;
        return WHITE_SPACE;
      }

  // Main special characters that start control directives
  ("-" | "#") {WS}  {
          yypushback(yylength());
          currentDirectiveState = START_CONTROL_DIRECTIVE;
          yybegin(INDENT_BLOCK);
      }
  // Other special characters that start control directives
  (":" | "?" | "()" | "*" | "+=" | ">") {WS}  {
        yypushback(yylength());
        currentDirectiveState = CONTROL_DIRECTIVE;
        yybegin(INDENT_BLOCK);
      }
  // '<' starts tags
  "<" {WS}  {
        yypushback(yylength());
        currentDirectiveState = XML_DIRECTIVE;
        yybegin(INDENT_BLOCK);
      }

  {COMMENT}  { return COMMENT_BLOCK; }

  . {
      yypushback(yylength());
      currentDirectiveState = TEMPLATE_DIRECTIVE;
      yybegin(INDENT_BLOCK);
    }

  <<EOF>>  { toDedent(); }
}

<INDENT_BLOCK> {
  [^] {
        yypushback(yylength());
        yybegin(currentDirectiveState);

        int stackTop = indentionStack.peek();
        if (stackTop < currentIndent) {
          indentionStack.push(currentIndent);
          return INDENT;
        }
        else if (stackTop > currentIndent) {
          toDedent();
        }
      }
}

<DEDENT_BLOCK, DEDENT_BLOCK_2> {
  [^]  {
    yypushback(yylength());
    if (indentionStack.peek() > currentIndent) {
      indentionStack.pop();

      // Snakeskin allow blocks inside one parent block to start with different amount of spaces.
      //
      // Example:
      // ('>' - space)
      // >block parent
      // >>>block childOne
      // >>block childTwo
      // >>>block grandChild
      //
      // In this case it's necessery to push current indention into indention stack,
      // since childOne and childTwo actually have the same indention and grandChild's
      // indention should be treated correctly (because it starts with the same amount of spaces as childOne).
      if (indentionStack.peek() < currentIndent) {
        indentionStack.push(currentIndent);
        yybegin(currentDirectiveState);
      } else {
        toDedent();
        return DEDENT;
      }
    }
    else {
      yybegin(currentDirectiveState);
    }
  }

  <<EOF>>  {
      if (indentionStack.peek() > 0) {
        indentionStack.pop();
        toDedent();
        return DEDENT;
      }
      else {
        return null;
      }
    }
}

<START_CONTROL_DIRECTIVE> {
  "-"                   { return MINUS_START; }
  "#"                   { return SHARP_START; }

  "link"                { return toXmlParsing(LINK); }
  "script"              { return toXmlParsing(SCRIPT); }
  "style"               { return toXmlParsing(STYLE); }
  "tag"                 { return toXmlParsing(TAG); }

  {WS_LINE}             { return WHITE_SPACE; }

  [^]  {
        yypushback(yylength());
        currentDirectiveState = CONTROL_DIRECTIVE;
        yybegin(CONTROL_DIRECTIVE);
      }
}

<CONTROL_DIRECTIVE> {

  "|" "!"? {IDENTIFIER} {
        yypushback(yylength() - 1);
        return FILTER_PIPE;
       }
  "{"                   {
        if (zzIsInterpolationMode) {
          zzInterpolationBracesCount++;
        }
        return BRACE_OPEN;
      }
  "}"                   {
        if (zzIsInterpolationMode) {
          if(zzInterpolationBracesCount > 0) {
            zzInterpolationBracesCount--;
          } else {
            int interpolationEndState = -1;

            switch(zzInterpolationStart) {
              case TAG:
                interpolationEndState = TAG_INTERPOLATION_END;
                break;
              case ID:
              case CLASS:
                interpolationEndState = CSS_SELECTORS_INTERPOLATION_END;
                break;
              case ATTR:
                interpolationEndState = ATTR_INTERPOLATION_END;
                break;
              case ATTR_VALUE:
              case LITERAL:
                interpolationEndState = zzLastInterpolationDirective;
                break;
            }
            zzIsInterpolationMode = false;
            yybegin(interpolationEndState);

            return INTERPOLATION_CLOSE;
          }
        }
        if (zzFromTemplate) {
          zzFromTemplate = false;
          yybegin(TEMPLATE_DIRECTIVE);
        }
        return BRACE_CLOSE;
      }
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
  "=>"                  { return FAT_ARROW; }
  "?"                   { return QUESTION; }
  "@"                   { return AT; }
  "_"                   { return UNDERSCORE; }
  "$"                   { return DOLLAR; }
  "@["                  { return AT_BRACK; }
  "@@["                 { return AT_AT_BACK; }
  "<<="                 { return LT_LT_EQ; }
  ">>="                 { return GT_GT_EQ; }
  ">>>="                { return GT_GT_GT_EQ; }
  "<<"                  { return LT_LT; }
  ">>"                  { return GT_GT; }
  ">>>"                 { return GT_GT_GT; }

  "as"                  { return AS; }
  "async"               { return ASYNC; }
  "await"               { return AWAIT; }
  "block"               { return BLOCK; }
  "break"               { return BREAK; }
  "call"                { return CALL; }
  "case"                { return CASE; }
  "catch"               { return CATCH; }
  "const"               { return CONST; }
  "continue"            { return CONTINUE; }
  "default"             { return DEFAULT; }
  "delete"              { return DELETE; }
  "do"                  { return DO; }
  "doctype"             { return DOCTYPE; }
  "else"                { return ELSE; }
  "extends"             { return EXTENDS; }
  "eval"                { return EVAL; }
  "from"                { return FROM; }
  "finally"             { return FINALLY; }
  "for"                 { return FOR; }
  "forEach"             { return FOREACH; }
  "forIn"               { return FORIN; }
  "func"                { return FUNC; }
  "global"              { return GLOBAL; }
  "head"                { return HEAD; }
  "if"                  { return IF; }
  "import"              { return IMPORT; }
  "in"                  { return IN; }
  "include"             { return INCLUDE; }
  "instanceof"          { return INSTANCEOF; }
  "interface"           { return INTERFACE; }
  "link"                { return LINK; }
  "namespace"           { return NAMESPACE; }
  "new"                 { return NEW; }
  "output"              { return OUTPUT; }
  "placeholder"         { return PLACEHOLDER; }
  "putIn"               { return PUT_IN; }
  "return"              { return RETURN; }
  "script"              { return SCRIPT; }
  "style"               { return STYLE; }
  "super"               { return SUPER; }
  "switch"              { return SWITCH; }
  "tag"                 { return TAG; }
  "target"              { return TARGET; }
  "template"            { return TEMPLATE; }
  "throw"               { return THROW; }
  "try"                 { return TRY; }
  "typeof"              { return TYPEOF; }
  "unless"              { return UNLESS; }
  "var"                 { return VAR; }
  "void"                { return VOID; }
  "while"               { return WHILE; }
  "with"                { return WITH; }

  "null"                { return NULL_LITERAL; }
  "undefined"           { return UNDEFINED_LITERAL; }
  true | false          { return BOOLEAN_LITERAL; }
  {PLACEHOLDER}         { return PLACEHOLDER; }
  {STRING_LITERAL}      { return STRING_LITERAL; }
  {NUMERIC_LITERAL}     { return NUMERIC_LITERAL; }
  {REGEXP_LITERAL}      { return REGEXP; }
  {IDENTIFIER}          { return IDENTIFIER; }
  {WITH_IDENTIFIER}     { return WITH_IDENTIFIER; }
  {GLOBAL_IDENTIFIER}   { return GLOBAL_IDENTIFIER; }

  {COMMENT}             { return COMMENT_BLOCK; }

  {WS_LINE}             { return WHITE_SPACE; }

// Multiline declaration
  {WS_LINE} "&"         { return toStartOfLineSplitting(); }
  {WS_LINE} "."         { return toEndOfLineSplitting(false); }
  {WS_EOL} "."          { return toEndOfLineSplitting(true); }

  {WS_EOL}  {
    if (zzIsMultilineMode) {
      return WHITE_SPACE;
    } else {
      return endStatement(false);
    }
  }

  <<EOF>>  { return endStatement(true); }
}

// For tag name only
<XML_DIRECTIVE> {
  "<"                   { return TAG_START; }
  "." | "#" | "["       {
        yypushback(1);
        yybegin(CSS_SELECTORS);
      }
  "?"                   |
  {XML_IDENTIFIER}      {
        yybegin(CSS_SELECTORS);
        return XML_IDENTIFIER;
      }
  {XML_IDENTIFIER}"${"  {
        yypushback(2);
        return XML_IDENTIFIER_PART_START;
      }
  "${"                  {
        zzInterpolationStart = InterpolationStart.TAG;
        zzIsInterpolationMode = true;
        zzLastInterpolationDirective = XML_DIRECTIVE;
        yybegin(CONTROL_DIRECTIVE);
        return INTERPOLATION_OPEN;
      }

  {WS_LINE}             { return WHITE_SPACE; }

// Multiline declaration
  {WS_LINE} "&"         { return toStartOfLineSplitting(); }
  {WS_LINE} "."         { return toEndOfLineSplitting(false); }
  {WS_EOL} "."          { return toEndOfLineSplitting(true); }

  {WS_EOL}  {
    if (zzIsMultilineMode) {
      return WHITE_SPACE;
    } else {
      return endStatement(false);
    }
  }

  {COMMENT}  { return COMMENT_BLOCK; }

  <<EOF>>  { return endStatement(true); }
}

// For classes and ids only.
// Spaces cannot match any rule here.
<CSS_SELECTORS> {
  "["                   { return BRACK_OPEN; }
  "]"                   { return BRACK_CLOSE; }
  {CSS_ID_SELECTOR}     { return ID_SELECTOR; }
  {CSS_CLASS_SELECTOR}  { return CLASS_SELECTOR; }

  {CSS_ID_SELECTOR}"${" {
        yypushback(2);
        yybegin(CSS_SELECTORS_INTERPOLATION_START);
        zzInterpolationStart = InterpolationStart.ID;
        return ID_SELECTOR_PART_START;
      }
  {CSS_CLASS_SELECTOR}"${"  {
        yypushback(2);
        yybegin(CSS_SELECTORS_INTERPOLATION_START);
        zzInterpolationStart = InterpolationStart.CLASS;
        return CLASS_SELECTOR_PART_START;
      }

  <<EOF>>  { return endStatement(true); }

  [^]  {
        yypushback(yylength());
        currentDirectiveState = XML_ATTRS;
        yybegin(XML_ATTRS);
      }
}

// A rule from CSS_SELECTORS is not able to start with "${" - only "." and "#" or brackets,
// so put interpolation rule for css selectors here
<CSS_SELECTORS_INTERPOLATION_START> {
  "${"  {
        zzIsInterpolationMode = true;
        zzLastInterpolationDirective = CSS_SELECTORS;
        yybegin(CONTROL_DIRECTIVE);
        return INTERPOLATION_OPEN;
      }
}

// For attributes only
<XML_ATTRS> {
  "="  {
        if (zzIsMultilineMode) {
          yybegin(XML_ATTR_MULTILINE_VALUE);
        } else {
          yybegin(XML_ATTR_VALUE);
        }
        return EQ;
      }
  "|"  { return PIPE; }

  {ATTR_NAME}  { return ATTR_NAME; }

  {ATTR_NAME}"${"  {
        yypushback(2);
        return ATTR_NAME_PART;
      }

  "${"  {
        zzInterpolationStart = InterpolationStart.ATTR;
        zzIsInterpolationMode = true;
        zzLastInterpolationDirective = XML_ATTRS;
        yybegin(CONTROL_DIRECTIVE);
        return INTERPOLATION_OPEN;
      }

  {WS_LINE}             { return WHITE_SPACE; }

  // Multiline declaration
  {WS_LINE} "&"         { return toStartOfLineSplitting(); }
  {WS_LINE} "."         { return toEndOfLineSplitting(false); }
  {WS_EOL} "."          { return toEndOfLineSplitting(true); }

  {WS_EOL}  {
    if (zzIsMultilineMode) {
      return WHITE_SPACE;
    } else {
      return endStatement(false);
    }
  }

  {COMMENT}  { return COMMENT_BLOCK; }

  <<EOF>>  { return endStatement(true); }
}

<XML_ATTR_VALUE> {
  {WS_LINE}            { return WHITE_SPACE; }
  {WS_LINE}\|{WS_LINE}  |
  {WS_EOL}              {
        yypushback(yylength());
        yybegin(XML_ATTRS);
      }
  \$\{                  {
        zzInterpolationStart = InterpolationStart.ATTR_VALUE;
        zzIsInterpolationMode = true;
        zzLastInterpolationDirective = XML_ATTR_VALUE;
        yybegin(CONTROL_DIRECTIVE);
        return INTERPOLATION_OPEN;
      }
  ([^ \t\r\n\|\$]|\$[^\r\n\{]|\|[^ \t\r\n])([^ \t\r\n\$]|[ \t]+[^ \t\r\n\|\$]|[ \t]+\|[^ \t\r\n]|(\$|[ \t]+\$)[^\r\n\{])*  {
        return ATTR_VALUE;
      }
  <<EOF>>               { return endStatement(true); }
}

<XML_ATTR_MULTILINE_VALUE> {
  {WS}                  { return WHITE_SPACE; }
  {WS}\|{WS}            |
  {WS} "."              {
        yypushback(yylength());
        yybegin(XML_ATTRS);
      }
  \$\{                  {
        zzInterpolationStart = InterpolationStart.ATTR_VALUE;
        zzIsInterpolationMode = true;
        zzLastInterpolationDirective = XML_ATTR_MULTILINE_VALUE;
        yybegin(CONTROL_DIRECTIVE);
        return INTERPOLATION_OPEN;
      }
  ([^ \t\r\n\|\$\.]|\|[^ \t\r\n]|\$[^\{])([^ \t\r\n\$]|(\$|[ \t\r\n]+\$)[^\{]|[ \t\r\n]+([^ \t\r\n\|\.\$]|\|[^ \t\r\n]|\.[ \t]*[^ \t\r\n]))*  {
        return ATTR_VALUE;
      }
  <<EOF>>               { return endStatement(true); }
}

<TEMPLATE_DIRECTIVE> {
  "{"                   {
        zzFromTemplate = true;
        currentDirectiveState = CONTROL_DIRECTIVE;
        yybegin(CONTROL_DIRECTIVE);
        return BRACE_OPEN;
      }
  "{{"                  {
        yybegin(LITERAL);
        return BRACE_OPEN_OPEN;
      }
  {WS_EOL}              { return endStatement(false); }
  [^{\r\n]+             { return TEMPLATE_TEXT; }

  {COMMENT}  { return COMMENT_BLOCK; }

  <<EOF>>               { return endStatement(true); }
}

<LITERAL> {
  {WS_EOL}              {
        yypushback(yylength());
        yybegin(TEMPLATE_DIRECTIVE);
      }
  \$\{                  {
        zzInterpolationStart = InterpolationStart.LITERAL;
        zzIsInterpolationMode = true;
        zzLastInterpolationDirective = LITERAL;
        yybegin(CONTROL_DIRECTIVE);
        return INTERPOLATION_OPEN;
      }
  ( [^\r\n\}\$] | ( \}[^\r\n\}] | \$[^\{] ) )+  {
        return TEMPLATE_LITERAL;
      }
  "}}"  {
        yybegin(TEMPLATE_DIRECTIVE);
        return BRACE_CLOSE_CLOSE;
      }
  . { return BAD_CHARACTER; }
}

// Finishes of an interpolation
// A separate state is needed because the end of an identifier
// could be right after the end of an interpolation (without white space).
<TAG_INTERPOLATION_END>  {
  {XML_IDENTIFIER}  {
        yybegin(zzLastInterpolationDirective);
        zzInterpolationStart = InterpolationStart.NONE;
        return XML_IDENTIFIER_PART_END;
      }
}

<CSS_SELECTORS_INTERPOLATION_END>  {
  {CSS_NAME_CONTINUE}  {
        yybegin(zzLastInterpolationDirective);
        IElementType token = zzInterpolationStart == InterpolationStart.ID ? ID_SELECTOR_PART_END : CLASS_SELECTOR_PART_END;
        zzInterpolationStart = InterpolationStart.NONE;
        return token;
      }
  {CSS_NAME_CONTINUE}"${"  {
        // Can't return to CSS_SELECTORS since there is no rule "${"
        // No need to reset zzInterpolationStart
        yybegin(CSS_SELECTORS_INTERPOLATION_START);
        yypushback(2);
        return zzInterpolationStart == InterpolationStart.ID ? ID_SELECTOR_PART_END : CLASS_SELECTOR_PART_END;
      }
}

<ATTR_INTERPOLATION_END>  {
  {ATTR_NAME}  {
        yybegin(zzLastInterpolationDirective);
        zzInterpolationStart = InterpolationStart.NONE;
        return ATTR_NAME_PART;
      }
  {ATTR_NAME}"${" {
        yybegin(zzLastInterpolationDirective);
        zzInterpolationStart = InterpolationStart.NONE;
        yypushback(2);
        return ATTR_NAME_PART;
      }
}

<TAG_INTERPOLATION_END, CSS_SELECTORS_INTERPOLATION_END, ATTR_INTERPOLATION_END>  {
  <<EOF>>  { yybegin(zzLastInterpolationDirective); }
  [^]  {
        zzInterpolationStart = InterpolationStart.NONE;
        yybegin(zzLastInterpolationDirective);
        yypushback(yylength());
      }
}

// Checks that there is no a non WS symbol after substring "&".
// In this case it's a start of line splitting.
// If there is a non WS symbol after "&", then it's just an AMP token.
<CHECK_LINE_SPLITTING> {
  "&" / {WS_LINE}* {WS_EOL}  {
    yypushback(yylength());
    yybegin(START_OF_LINE_SPLITTING);
  }

  <<EOF>>  { return endStatement(true); }

  .  { yybegin(currentDirectiveState); return AMP; }
}

// Returns correct token for "&" character and whitespaces
<START_OF_LINE_SPLITTING> {
  "&"  { return ML_OPEN; }
  {WS_LINE}+  { return WHITE_SPACE; }
  {WS_EOL}  {
    if (!zzIsMultilineMode) {
      zzIsMultilineMode = true;
    }
    yybegin(currentDirectiveState);
    yypushback(yylength());
  }
}

// Checks that there is no a non WS symbol after substring ".".
// In this case it's the end of line splitting.
// If there is a non WS symbol after ".", then it's just a DOT token.
<CHECK_END_OF_LINE_SPLITTING> {
  "." / {WS_LINE}* {WS_EOL}  {
    yypushback(yylength());
    yybegin(END_OF_LINE_SPLITTING);
  }

  <<EOF>>  { return endStatement(true); }

  .  { yybegin(currentDirectiveState); return DOT; }
}

// Returns correct token for "." character and whitespaces
<END_OF_LINE_SPLITTING> {
  "."  { return ML_CLOSE; }
  {WS_LINE}+  { return WHITE_SPACE; }
  {WS_EOL}  {
    if (zzIsMultilineMode) {
      zzIsMultilineMode = false;
    }
    yybegin(currentDirectiveState);
    yypushback(yylength());
  }
}

[^] { return BAD_CHARACTER; }
