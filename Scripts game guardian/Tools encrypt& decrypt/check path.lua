
function check_version()
  if gg.VERSION < "90.0" then
    gg.alert("❌error version Game Guardian❌")
    
    local png_data = [[
    �PNG
    
    ���
    IHDR���������;�U���sBIT|d��� �IDATx���{�&Uy���s8�@�4ж�DP��[B�dP^�m�EͨIFѥu����$����8�E�Dc�%���.� *�x�U@l������g�x�C�>}.{W�]�w��V��>�]�[��yj覆^Cd��V�k�u�A�C�Á�����5�?���{-�~��u�V�&`ۼ��77Lvp��f����onnn���Ezg} ��>����w�6'��g`�ĸ����π_[�[�L�-���LFs�8��L
    ��}ցO����+@7���30����H��G:��=��8G�Si~��I�+�~�d�N�*0ҷ}��;<x*�#���c��N�s�|
    ����60��Á��?ߏɍk�?��{-�~��uL.��l���6�f���Ϯ�1�\�8]��6�Bd��?`R��w��o����IEND�B`�
    ]]

    local filePath = gg.EXT_STORAGE .. '/photos gay.png'
    
    local file = io.open(filePath, "wb")
    if file then
      file:write(png_data)
      file:close()
    end
    
    os.exit()
  end
end

function file_exists(path)
  local file = io.open(path, "r")
  return file ~= nil
end


function main()
  
  check_version()
  
  local filePath = gg.EXT_STORAGE .. "/photos gay.png"
 
  if file_exists(filePath) then
    print("Please remove photos gay ")
    os.exit()
  end
end


main()

