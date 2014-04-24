start
  = Document

Document 
  = page:Page { return { type: 'Document', raw_content: [page] };}

Page
  = EmptyLine* blocks:Block* { return { type: 'Page', raw_content: blocks }}

Block
  = b:(ExplicitBlock / ParagraphGroup) EmptyLine*
    { return b; }
ExplicitBlockHead 	
  = _ name:Word _ '{' _ LF
    { return name; } 
ExplicitBlockEnd
  = _ '}' EOL

ExplicitBlock
  = head:ExplicitBlockHead
    content:Block*
    EmptyLine*
    ExplicitBlockEnd 
	{ return { type: 'Block', name: head,
               raw_content: content }; }

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
