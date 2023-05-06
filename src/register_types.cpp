#include "register_types.h"

#include "godot_cpp/classes/engine.hpp"
#include "godot_cpp/godot.hpp"
#include "idgs_activity.h"
#include "idgs_core.h"
#include "idgs_overlay.h"
#include "idgs_user.h"

using namespace godot;

static IDGSCore *_idgsCore;
static IDGSActivity *_idgsActivity;
static IDGSOverlay *_idgsOverlay;
static IDGSUser *_idgsUser;

void initialize_dgs_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }

    ClassDB::register_class<IDGSCore>();
    _idgsCore = memnew(IDGSCore);
    Engine::get_singleton()->register_singleton("IDGSCore", IDGSCore::get_singleton());

    ClassDB::register_class<IDGSActivity>();
    _idgsActivity = memnew(IDGSActivity);
    Engine::get_singleton()->register_singleton("IDGSActivity", IDGSActivity::get_singleton());

    ClassDB::register_class<IDGSOverlay>();
    _idgsOverlay = memnew(IDGSOverlay);
    Engine::get_singleton()->register_singleton("IDGSOverlay", IDGSOverlay::get_singleton());

    ClassDB::register_class<IDGSUser>();
    _idgsUser = memnew(IDGSUser);
    Engine::get_singleton()->register_singleton("IDGSUser", IDGSUser::get_singleton());
}

void uninitialize_dgs_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }

    Engine::get_singleton()->unregister_singleton("IDGSCore");
    memdelete(_idgsCore);

    Engine::get_singleton()->unregister_singleton("IDGSActivity");
    memdelete(_idgsActivity);

    Engine::get_singleton()->unregister_singleton("IDGSOverlay");
    memdelete(_idgsOverlay);

    Engine::get_singleton()->unregister_singleton("IDGSUser");
    memdelete(_idgsUser);
}

extern "C" {
// Initialization.
GDExtensionBool GDE_EXPORT dgs_library_init(const GDExtensionInterface *p_interface, const GDExtensionClassLibraryPtr p_library, GDExtensionInitialization *r_initialization) {
    godot::GDExtensionBinding::InitObject init_obj(p_interface, p_library, r_initialization);

    init_obj.register_initializer(initialize_dgs_module);
    init_obj.register_terminator(uninitialize_dgs_module);
    init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

    return init_obj.init();
}
}