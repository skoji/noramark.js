start
  = Document

Document
  = EmptyLine* blocks:Block* { return '<html><body>' + blocks.join("\n") + '</body></html>';}

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
	{ return "<" + head + ">\n" + content.join("") + "\n</" + head + ">"; }

ParagraphGroup
  = pg:Paragraphs
    { return '<div class="pgroup">\n' + pg.join("\n") + "\n</div>"; }

ParagraphDelimiter
  = ExplicitBlockHead / ExplicitBlockEnd

Paragraphs
  = p:Paragraph LF pg:Paragraphs
    { pg.unshift(p); return pg;}
  / p:Paragraph
    { return [p]; }

Paragraph
  = !ParagraphDelimiter dl:DocumentLine 
    { return "<p>" + dl + "</p>"; }

DocumentLine
  = l:Character+ &EOL
    { return l.join(''); }

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