#pragma once

#include "dgs_utils.h"
#include "idgs_core.h"
#pragma pack(push, 8)
#include "discord_game_sdk.h"
#pragma pack(pop)
#include "godot_cpp/classes/ref_counted.hpp"
#include "godot_cpp/core/binder_common.hpp"
#include "godot_cpp/core/class_db.hpp"
#include "godot_cpp/variant/utility_functions.hpp"

namespace godot {

class IDGSOverlay : public RefCounted {
    GDCLASS(IDGSOverlay, RefCounted)

    static IDGSOverlay* singleton;

   public:
    static IDGSOverlay* get_singleton();
    bool is_enabled();
    bool is_locked();
    void set_locked(bool locked);
    void open_activity_invite(int type);
    void open_guild_invite(const String& code);
    void open_voice_settings();

    static void on_toggle(void* data, bool locked) {
        IDGSOverlay::get_singleton()->emit_signal("toggle", locked);
    };

    IDGSOverlay();
    ~IDGSOverlay();

    static IDiscordOverlayEvents _events;

   protected:
    static void _bind_methods();
};

}  // namespace godot
