--local whoMatch= getColourString( matches[2] )
--local bodyMatch= getColourString( matches[3] )

-- Auction: a silvery war axe term ended with NO SALE
if not chatCapture then
  chatCapture=true
  
  -- Only capture body, exclude from ALL tab
  demonnic.chat:append("AUC", true)
end