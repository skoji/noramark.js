start
  = Document

Document
  = EmptyLine* blocks:Block* { return blocks.join("\n"); }

Block
  = b:(ExplicitBlock / ParagraphGroup) EmptyLine*
    { return b; }
ExplicitBlockHead 	
  = SPC* name:Word SPC* '{' SPC* { return name; }
ExplicitBlockEnd
  = SPC* '}' 

ExplicitBlock
  = head:ExplicitBlockHead LF
    content:Block*
    EmptyLine*
    ExplicitBlockEnd EOL
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
  = LF SPC* EOL / SPC* LF
LF
  = "\n"
SPC
  = [ \t]
EOL
  = "\n" / EOF
EOF
  = !.
