function colorm()
  
  local sph = gg.prompt({
      "\ncolors: \n\n0 : Black | 1 : White  | 2: Red | 3 : Lime | 4 : Blue | 5: Yellow |   6: Orange | 7: Pink | 8: Purple | 9: Brown | 10: Gray | 11: Silver | 12: Gold | 13: Turquoise | 14: Lime Green | 15: Coral | 16: Sky Blue | 17: Indigo | 18: Olive | 19: Beige \n\nselect color [0;19]",
      "select color [0;19]",
      "select color [0;19]",
      "select color [0;19]",
      "select color [0;19]"
    },
    {0, 0, 0,0,0}, 
    {"number", "number", "number", "number","number"} -- Tipos de entrada esperados
  )
  
  if sph == nil then
    return
  else
    local sphr = "#000000"  
    
        if sph[1] == "0" then
      sphr = "#000000"
    elseif sph[1] == "1" then
      sphr = "#FFFFFF"
    elseif sph[1] == "2" then
      sphr = "#FF0000"
    elseif sph[1] == "3" then
      sphr = "#00FF00"
    elseif sph[1] == "4" then
      sphr = "#0000FF"
    elseif sph[1] == "5" then
      sphr = "#FFFF00"
    elseif sph[1] == "6" then
      sphr = "#FFA500"
    elseif sph[1] == "7" then
      sphr = "#FFC0CB"
    elseif sph[1] == "8" then
      sphr = "#800080"
    elseif sph[1] == "9" then
      sphr = "#A52A2A"
    elseif sph[1] == "10" then
      sphr = "#808080"
    elseif sph[1] == "11" then
      sphr = "#C0C0C0"
    elseif sph[1] == "12" then
      sphr = "#FFD700"
    elseif sph[1] == "13" then
      sphr = "#40E0D0"
    elseif sph[1] == "14" then
      sphr = "#32CD32"
    elseif sph[1] == "15" then
      sphr = "#FF7F50"
    elseif sph[1] == "16" then
      sphr = "#87CEEB"
    elseif sph[1] == "17" then
      sphr = "#4B0082"
    elseif sph[1] == "18" then
      sphr = "#808000"
    elseif sph[1] == "19" then
      sphr = "#F5F5DC"
    end
    
    local sphr2 = "#000000"  
        if sph[2] ~= sph[1] then
      if sph[2] == "0" then
        sphr2 = "#000000"
      elseif sph[2] == "1" then
        sphr2 = "#FFFFFF"
      elseif sph[2] == "2" then
        sphr2 = "#FF0000"
      elseif sph[2] == "3" then
        sphr2 = "#00FF00"
      elseif sph[2] == "4" then
        sphr2 = "#0000FF"
      elseif sph[2] == "5" then
        sphr2 = "#FFFF00"
      elseif sph[2] == "6" then
        sphr2 = "#FFA500"
      elseif sph[2] == "7" then
        sphr2 = "#FFC0CB"
      elseif sph[2] == "8" then
        sphr2 = "#800080"
      elseif sph[2] == "9" then
        sphr2 = "#A52A2A"
      elseif sph[2] == "10" then
        sphr2 = "#808080"
      elseif sph[2] == "11" then
        sphr2 = "#C0C0C0"
      elseif sph[2] == "12" then
        sphr2 = "#FFD700"
      elseif sph[2] == "13" then
        sphr2 = "#40E0D0"
      elseif sph[2] == "14" then
        sphr2 = "#32CD32"
      elseif sph[2] == "15" then
        sphr2 = "#FF7F50"
      elseif sph[2] == "16" then
        sphr2 = "#87CEEB"
      elseif sph[2] == "17" then
        sphr2 = "#4B0082"
      elseif sph[2] == "18" then
        sphr2 = "#808000"
      elseif sph[2] == "19" then
        sphr2 = "#F5F5DC"
      end
    end
    local sphr3 = "#000000"  
    
        if sph[3] ~= sph[1] and sph[3] ~= sph[2] then
      if sph[3] == "0" then
        sphr3 = "#000000"
      elseif sph[3] == "1" then
        sphr3 = "#FFFFFF"
      elseif sph[3] == "2" then
        sphr3 = "#FF0000"
      elseif sph[3] == "3" then
        sphr3 = "#00FF00"
      elseif sph[3] == "4" then
        sphr3 = "#0000FF"
      elseif sph[3] == "5" then
        sphr3 = "#FFFF00"
      elseif sph[3] == "6" then
        sphr3 = "#FFA500"
      elseif sph[3] == "7" then
        sphr3 = "#FFC0CB"
      elseif sph[3] == "8" then
        sphr3 = "#800080"
      elseif sph[3] == "9" then
        sphr3 = "#A52A2A"
      elseif sph[3] == "10" then
        sphr3 = "#808080"
      elseif sph[3] == "11" then
        sphr3 = "#C0C0C0"
      elseif sph[3] == "12" then
        sphr3 = "#FFD700"
      elseif sph[3] == "13" then
        sphr3 = "#40E0D0"
      elseif sph[3] == "14" then
        sphr3 = "#32CD32"
      elseif sph[3] == "15" then
        sphr3 = "#FF7F50"
      elseif sph[3] == "16" then
        sphr3 = "#87CEEB"
      elseif sph[3] == "17" then
        sphr3 = "#4B0082"
      elseif sph[3] == "18" then
        sphr3 = "#808000"
      elseif sph[3] == "19" then
        sphr3 = "#F5F5DC"
      end
    end
    
    local sphr4 = "#000000"  
       if sph[4] ~= sph[1] then
      if sph[4] == "0" then
        sphr4 = "#000000"
      elseif sph[4] == "1" then
        sphr4 = "#FFFFFF"
      elseif sph[4] == "2" then
        sphr4 = "#FF0000"
      elseif sph[4] == "3" then
        sphr4 = "#00FF00"
      elseif sph[4] == "4" then
        sphr4 = "#0000FF"
      elseif sph[4] == "5" then
        sphr4 = "#FFFF00"
      elseif sph[4] == "6" then
        sphr4 = "#FFA500"
      elseif sph[4] == "7" then
        sphr4 = "#FFC0CB"
      elseif sph[4] == "8" then
        sphr4 = "#800080"
      elseif sph[4] == "9" then
        sphr4 = "#A54A4A"
      elseif sph[4] == "10" then
        sphr4 = "#808080"
      elseif sph[4] == "11" then
        sphr4 = "#C0C0C0"
      elseif sph[4] == "12" then
        sphr4 = "#FFD700"
      elseif sph[4] == "13" then
        sphr4 = "#40E0D0"
      elseif sph[4] == "14" then
        sphr4 = "#34CD34"
      elseif sph[4] == "15" then
        sphr4 = "#FF7F50"
      elseif sph[4] == "16" then
        sphr4 = "#87CEEB"
      elseif sph[4] == "17" then
        sphr4 = "#4B0084"
      elseif sph[4] == "18" then
        sphr4 = "#808000"
      elseif sph[4] == "19" then
        sphr4 = "#F5F5DC"
      end
    end
    
    local sphr5 = "#000000"  
        if sph[5] ~= sph[1] then
      if sph[5] == "0" then
        sphr5 = "#000000"
      elseif sph[5] == "1" then
        sphr5 = "#FFFFFF"
      elseif sph[5] == "2" then
        sphr5 = "#FF0000"
      elseif sph[5] == "3" then
        sphr5 = "#00FF00"
      elseif sph[5] == "4" then
        sphr5 = "#0000FF"
      elseif sph[5] == "5" then
        sphr5 = "#FFFF00"
      elseif sph[5] == "6" then
        sphr5 = "#FFA500"
      elseif sph[5] == "7" then
        sphr5 = "#FFC0CB"
      elseif sph[5] == "8" then
        sphr5 = "#800080"
      elseif sph[5] == "9" then
        sphr5 = "#A55A5A"
      elseif sph[5] == "10" then
        sphr5 = "#808080"
      elseif sph[5] == "11" then
        sphr5 = "#C0C0C0"
      elseif sph[5] == "12" then
        sphr5 = "#FFD700"
      elseif sph[5] == "13" then
        sphr5 = "#50E0D0"
      elseif sph[5] == "14" then
        sphr5 = "#35CD35"
      elseif sph[5] == "15" then
        sphr5 = "#FF7F50"
      elseif sph[5] == "16" then
        sphr5 = "#87CEEB"
      elseif sph[5] == "17" then
        sphr5 = "#5B0085"
      elseif sph[5] == "18" then
        sphr5 = "#808000"
      elseif sph[5] == "19" then
        sphr5 = "#F5F5DC"
      end
    end
   
    local xml =  [[
    
    <layer-list xmlns:android="http://schemas.android.com/apk/res/android">
	<item android:left="0.0px" android:top="0.0px" android:right="0.0px" android:bottom="0.0px">
		<shape>
			<gradient android:startColor="]] .. sphr .. [[" android:endColor="]] .. sphr2 .. [[" android:angle="270.0" android:type="linear" android:gradientRadius="100.0" android:centerColor="#0c00e5ff" />
			<corners android:radius="10.0dip" />
		</shape>
	</item>
	<item android:left="0.0px" android:top="0.0px" android:right="0.0px" android:bottom="0.0px">
		<shape>
			<gradient android:startColor="]] .. sphr3 .. [[" android:endColor="]] .. sphr4.. [[" android:angle="180.0" android:type="linear" android:centerX="0.0" android:centerY="0.7" android:gradientRadius="200.0" android:centerColor="#0cff00ff" />
			<corners android:radius="10.0dip" />
		</shape>
	</item>
	<item android:left="0.0px" android:top="0.0px" android:right="0.0px" android:bottom="0.0px">
		<shape>
			<gradient android:startColor="]] .. sphr4 .. [[" android:endColor="]] .. sphr3 .. [[" android:angle="0.0" android:type="linear" android:centerX="0.5" android:centerY="0.3" android:gradientRadius="200.0" android:centerColor="#0cff00ff" />
			<corners android:radius="10.0dip" />
		</shape>
	</item>
	<item android:left="0.0px" android:top="0.0px" android:right="0.0px" android:bottom="0.0px">
		<shape>
			<gradient android:startColor="]] .. sphr3 .. [[" android:endColor="]] .. sphr3 ..[[" android:angle="360.0" android:type="linear" android:centerX="0.3" android:centerY="0.0" android:gradientRadius="200.0" android:centerColor="#0c016dff" />
			<corners android:radius="10.0dip" />
			<padding android:left="2.0dip" android:top="2.0dip" android:right="2.0dip" android:bottom="2.0dip" />
		</shape>
	</item>
	<item android:left="2.0px" android:top="2.0px" android:right="2.0px" android:bottom="2.0px">
		<shape>
			<corners android:radius="10.0dip" />
			<stroke android:width="1.0px" android:color="]] .. sphr5 .. [[" />
			<padding android:left="1.0dip" android:top="1.0dip" android:right="1.0dip" android:bottom="1.0dip" />
		</shape>
	</item>
	<item android:left="3.0px" android:top="3.0px" android:right="3.0px" android:bottom="3.0px">
		<shape>
			<solid android:color="]] .. sphr .. [[" />
			<corners android:radius="10.0dip" />
			<stroke android:width="1.0px" android:color="]] .. sphr5 .. [[" />
		</shape>
	</item>
	<item android:left="0.0px" android:top="0.0px" android:right="0.0px" android:bottom="0.0px">
		<shape>
			<corners android:radius="10.0dip" />
			<stroke android:width="3.0dip" android:color="]] .. sphr4 .. [[" />
			<padding android:left="5.0dip" android:top="4.0dip" android:right="4.0dip" android:bottom="4.0dip" />
		</shape>
	</item>
</layer-list>

]]
    
function escreverArquivo(nomeArquivo, conteudo)
    local file = io.open(nomeArquivo, "w") 
    if file then
        file:write(conteudo)
        file:close() 
        print("Arquivo '" .. nomeArquivo .. "' save in storage/emulated/0/.")
    else
        print("Erro ao tentar criar o arquivo '" .. nomeArquivo .. "'.")
    end
end

local nomeDoArquivo = "Background.xml"
local conteudoDoArquivo = xml

escreverArquivo(nomeDoArquivo, conteudoDoArquivo)

  --  print(xml)  
    
    return sphr  
  end
end

colorm()  