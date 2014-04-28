{
  var _ = require("underscore");
}

start
  = Document

Document 
  = page:Page { return { type: 'Document', raw_content: [page] };}

Page
  = EmptyLine* blocks:Block* { return { type: 'Page', raw_content: blocks }}

ClassName
  = '.' classname:Word { return classname; }
ClassNames
  = cn:ClassName cns:ClassNames { cns.unshift(cn); return cns; }
  / cn:ClassName { return [ cn ]; }
IdName
  = '#' idname:Word { return idname; }
IdNames
  = id:IdName ids:IdNames { ids.unshift(id); return ids; }
  / id:IdName { return [ id ]; }

CommandName
  = name:Word idnames:IdNames? classes:ClassNames?
    { return { name: name, ids: idnames, classes: classes }}

Block
  = b:(ExplicitBlock / ParagraphGroup) EmptyLine*
    { return b; }
ExplicitBlockHead 	
  = _ name:CommandName _ '{' _ LF
    { return name; } 

ExplicitBlockEnd
  = _ '}' EOL

ExplicitBlock
  = head:ExplicitBlockHead
    content:Block*
    EmptyLine*
    ExplicitBlockEnd 
	{ return _.extend({ type: 'Block', raw_content: content }, head); }

ParagraphGroup
  = pg:Paragraphs
    { return { type: 'ParagraphGroup',
               raw_content: pg }; }

ParagraphDelimiter
  = ExplicitBlockHead / ExplicitBlockEnd

Paragraphs
  = p:Paragraph LF pg:Paragraphs
    { pg.unshift(p); return pg;}
  / p:Paragraph
    { return [p]; }

Paragraph
  = !ParagraphDelimiter dl:DocumentLine 
    { return { type: 'Paragraph', raw_content: [dl] }; }

DocumentLine
  = l:Character+ &EOL
    { return { type: 'text', content: l.join('') } }

Alpha
  = [a-zA-Z]
WordChar
  = Alpha / [-_]
Word
  = s:Alpha r:WordChar* { r.unshift(s); return r.join(''); }
Character
  = !LF c:.
    { return c; } 
EmptyLine
  = LF _ EOL / _ LF
LF
  = "\n"

_ = SPC*

SPC
  = [ \t]
EOL
  = LF / EOF
EOF
  = !.
