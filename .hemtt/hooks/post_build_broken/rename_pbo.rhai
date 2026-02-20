let addons = HEMTT_OUT.join("addons");
let prefix_len = HEMTT.project().prefix().len();

for pbo_path in addons.list() {
    let rpbo = pbo_path.file_name();
    rpbo.crop(prefix_len + 1);
    let rpbo_path = addons.join(rpbo);
    print(rpbo_path);
    print(pbo_path);
    if !pbo_path.move(rpbo_path) {
        fatal("Failed to rename " + pbo_path + " to " + rpbo_path);
    }
}
print("rename PBOs");