#include "register_types.h"

#include "godot_cpp/classes/engine.hpp"
#include "godot_cpp/godot.hpp"
#include "idgs_activity.h"
#include "idgs_core.h"
#include "idgs_overlay.h"
#include "idgs_relationship.h"
#include "idgs_user.h"

using namespace godot;

static IDGSCore *_idgsCore;
static IDGSActivity *_idgsActivity;
static IDGSOverlay *_idgsOverlay;
static IDGSUser *_idgsUser;
static IDGSRelationship *_idgsRelationship;

void initialize_dgs_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }

    DGS_REGISTER_SINGLETON(_idgsCore, IDGSCore);
    DGS_REGISTER_SINGLETON(_idgsActivity, IDGSActivity);
    DGS_REGISTER_SINGLETON(_idgsOverlay, IDGSOverlay);
    DGS_REGISTER_SINGLETON(_idgsUser, IDGSUser);
    DGS_REGISTER_SINGLETON(_idgsRelationship, IDGSRelationship);
}

void uninitialize_dgs_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }

    DGS_DEREGISTER_SINGLETON(_idgsCore, IDGSCore);
    DGS_DEREGISTER_SINGLETON(_idgsActivity, IDGSActivity);
    DGS_DEREGISTER_SINGLETON(_idgsOverlay, IDGSOverlay);
    DGS_DEREGISTER_SINGLETON(_idgsUser, IDGSUser);
    DGS_DEREGISTER_SINGLETON(_idgsRelationship, IDGSRelationship);
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