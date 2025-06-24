-- ^(?:< .* > )?([A-Za-z]+ )says ('.*')$
-- ^(?:< .* > )?([A-Za-z]+ )projects ('.*')$
-- ^(?:< .* > )?(You )say ('.*')$
-- ^(?:< .* > )?(You )project ('.*')$

-- Oghma says with a melodious voice 'I can see it either way'
-- Dugmaren mutters in a surly voice 'ok'

-- You sign 'can someone sign something?'
-- Nilan signs 'hi'


-- says is not compacted

--local whoMatch= getColourString( matches[2] )
-- local bodyMatch= getColourString( matches[3] )

if not chatCapture then
  chatCapture=true
  demonnic.chat:append("SAYS")
end