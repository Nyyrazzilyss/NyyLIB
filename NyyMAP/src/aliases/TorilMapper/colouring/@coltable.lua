local colourtable=getCustomEnvColorTable()

echo("257-272 are defaults\n")

for k,v in pairs(colourtable) do

  --if (k < 257 or k > 272) then
    hecho(string.format("\n#%02x%02x%02x Color entry: %d { %d %d %d }", v[1], v[2], v[3], k, v[1], v[2], v[3]) )
  --end
end
