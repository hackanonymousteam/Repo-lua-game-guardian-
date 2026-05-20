local HELLAntiHook = {} 
for x,y in pairs(_G)
 do if type(y) == 'table' then
  for xx,yy in pairs(y) 
  do if type(yy) == 'function' and debug.getinfo(yy).source ~= '=[Java]'   then
   local dZvT="�" for i= 1,999 do pcall(string.dump,dZvT,dZvT,dZvT,dZvT) end end end end end
    if #HELLAntiHook > 0 then while(true) do  HELL()  end end
