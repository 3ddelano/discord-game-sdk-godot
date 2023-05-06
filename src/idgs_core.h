#pragma once

#include "dgs_utils.h"
#pragma pack(push, 8)
#include "discord_game_sdk.h"
#pragma pack(pop)
#include "godot_cpp/classes/ref_counted.hpp"
#include "godot_cpp/core/binder_common.hpp"
#include "godot_cpp/core/class_db.hpp"
#include "godot_cpp/variant/utility_functions.hpp"

namespace godot {

class IDGSCore : public RefCounted {
    GDCLASS(IDGSCore, RefCounted)

    static IDGSCore* singleton;
    IDiscordCore* _core = nullptr;

   public:
    static IDGSCore* get_singleton();
    void tick();
    int create_core(int64_t client_id, uint64_t flags);
    void destroy();
    void set_log_level(int level);

    IDGSCore();
    ~IDGSCore();

    static IDiscordUserManager* get_user_manager() {
        IDiscordCore* core = IDGSCore::get_singleton()->_core;
        return IDGSCore::get_singleton()->_core->get_user_manager(IDGSCore::get_singleton()->_core);
    };
    static IDiscordActivityManager* get_activity_manager() {
        IDiscordCore* core = IDGSCore::get_singleton()->_core;
        return IDGSCore::get_singleton()->_core->get_activity_manager(IDGSCore::get_singleton()->_core);
    };
    static IDiscordRelationshipManager* get_relationship_manager() {
        IDiscordCore* core = IDGSCore::get_singleton()->_core;
        return IDGSCore::get_singleton()->_core->get_relationship_manager(IDGSCore::get_singleton()->_core);
    };
    static IDiscordOverlayManager* get_overlay_manager() {
        IDiscordCore* core = IDGSCore::get_singleton()->_core;
        return IDGSCore::get_singleton()->_core->get_overlay_manager(IDGSCore::get_singleton()->_core);
    };

   protected:
    static void _bind_methods();
};

}  // namespace godot
