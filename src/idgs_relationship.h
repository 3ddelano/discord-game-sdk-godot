#pragma once

#include "dgs_utils.h"
#include "idgs_core.h"
#pragma pack(push, 8)
#include "discord_game_sdk.h"
#pragma pack(pop)
#include "godot_cpp/classes/ref_counted.hpp"
#include "godot_cpp/core/binder_common.hpp"
#include "godot_cpp/core/class_db.hpp"
#include "godot_cpp/variant/callable.hpp"
#include "godot_cpp/variant/utility_functions.hpp"

namespace godot {

class IDGSRelationship : public RefCounted {
    GDCLASS(IDGSRelationship, RefCounted)

    static IDGSRelationship* singleton;

   public:
    static IDGSRelationship* get_singleton();

    void filter();
    Dictionary count();
    Dictionary get_user(int64_t user_id);
    Dictionary get_at(int index);

    IDGSRelationship();
    ~IDGSRelationship();

    static IDiscordRelationshipEvents _events;

    static void on_refresh(void* data) {
        IDGSRelationship::get_singleton()->emit_signal("refresh");
    }

    static void on_relationship_update(void* data, DiscordRelationship* relationship) {
        IDGSRelationship::get_singleton()->emit_signal("relationship_update", dgs_discord_relationship_to_dict(relationship));
    }

   protected:
    static void _bind_methods();
};

}  // namespace godot
