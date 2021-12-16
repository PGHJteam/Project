import os
path = "./"
file_list = os.listdir(path)
font_list = [file for file in file_list if file.endswith(".imageset")]
base_path = os.getcwd()
for oldname in font_list:
    temp = oldname.split("-")
    newname = temp[0] + "-" + temp[1].split(".")[0].zfill(2) + ".imageset"
    print(newname)
    oldname = os.path.join(base_path, oldname)
    newname = os.path.join(base_path, newname)
    os.rename(oldname, newname)