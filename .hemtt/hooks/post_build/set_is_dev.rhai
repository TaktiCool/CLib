// Read the current contents of the mod.cpp
// file from the project source

if (HEMTT.is_release()) {
    let macro_path = HEMTT_VFS
        .join("addons")
        .join("CLib")
        .join("CLib_Macros.hpp");
    let macro_hpp = macro_path
        .open_file()
        .read();

    macro_hpp.replace("// #define ISDEV", "#define ISDEV");

    macro_path
        .create_file()
        .write(macro_hpp); 
}