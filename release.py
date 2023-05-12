import zipfile
import shutil
import os

addon_folder = "sample/addons/"
addon_name = "discord-game-sdk-godot"
keep_only_release_libs = True
exclude_patterns = [".lib", ".exp", ".ilk", ".pdb", ".obj", ".os"]


def read_version_from_plugin_config():
    version = ""
    with open(addon_folder + addon_name + "/plugin.cfg", "r") as f:
        for line in f:
            if line.startswith("version="):
                version = line.split("=")[1].replace('"', "").strip()
                break
    return version


def copytree(src, dst, symlinks=False, ignore=None):
    if not os.path.exists(dst):
        os.makedirs(dst)
    for item in os.listdir(src):
        try:
            if item == ".git" or item.index("debug") > -1:
                continue
        except ValueError:
            pass
        s = os.path.join(src, item)
        d = os.path.join(dst, item)
        if os.path.isdir(s):
            copytree(s, d, symlinks, ignore)
        else:
            if not any(x in s for x in exclude_patterns):
                shutil.copy2(s, d)


def make_zip_archive(source, destination):
    base = os.path.basename(destination)
    name = base.split('.')[0]
    archive_from = os.path.dirname(source)
    archive_to = os.path.basename(source.strip(os.sep))
    shutil.make_archive(name, "zip", archive_from, archive_to)
    shutil.move(f'{name}.zip', destination)


def release():
    version = read_version_from_plugin_config()
    copytree(addon_folder, "tmp/addons/")
    shutil.copy2("README.md", f"tmp/addons/{addon_name}")
    shutil.copy2("LICENSE.md", f"tmp/addons/{addon_name}")
    file_name = f"{addon_name}-v{version}.zip"
    make_zip_archive("tmp/addons", file_name)
    shutil.rmtree("tmp")
    return file_name


if __name__ == "__main__":
    file_name = release()
    print(f"Release complete!: {file_name}")
