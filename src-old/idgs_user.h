#pragma once

#include "dgs_utils.h"
#include "idgs_core.h"
#pragma pack(push, 8)
#include "discord_game_sdk.h"
#pragma pack(pop)
#include "godot_cpp/classes/ref_counted.hpp"
#include "godot_cpp/core/binder_common.hpp"
#include "godot_cpp/core/class_db.hpp"
#include "godot_cpp/core/memory.hpp"
#include "godot_cpp/variant/utility_functions.hpp"

namespace godot {

class IDGSUser : public RefCounted {
    GDCLASS(IDGSUser, RefCounted)

    static IDGSUser* singleton;

   public:
    static IDGSUser* get_singleton();
    Dictionary get_current_user();
    void get_user(int64_t user_id);
    Dictionary get_current_user_premium_type();
    Dictionary current_user_has_flag(int flag);

    IDGSUser();
    ~IDGSUser();

    static void on_current_user_update(void* data) {
        IDGSUser::get_singleton()->emit_signal("current_user_update");
    }

    static IDiscordUserEvents _events;

   protected:
    static void _bind_methods();
};

}  // namespace godot
