
 local my_gg = "com.pr3da7ol.gg" --  replace with (your package name gg)

local graf = gg.PACKAGE

if graf then
    if graf == my_gg then
      --  print("gg correct")
    else
        gg.alert("gg incorrect, please use the correct gg")
        os.exit()
    end
else
    gg.alert("Failed to get the package name")
    os.exit()
end