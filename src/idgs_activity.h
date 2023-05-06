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

class IDGSActivity : public RefCounted {
    GDCLASS(IDGSActivity, RefCounted)

    static IDGSActivity* singleton;

   public:
    static IDGSActivity* get_singleton();
    int register_command(const String& command);
    int register_steam(int steam_id);
    void update_activity(Ref<RefCounted> activity);
    void clear_activity();
    void send_request_reply(int64_t user_id, int reply);
    void send_invite(int64_t user_id, int type, const String& content);
    void accept_invite(int64_t user_id);

    static void on_activity_join(void* data, const char* join_secret) {
        IDGSActivity::get_singleton()->emit_signal("join", join_secret);
    };

    static void on_activity_spectate(void* data, const char* spectate_secret) {
        IDGSActivity::get_singleton()->emit_signal("spectate", spectate_secret);
    };

    static void on_activity_join_request(void* data, DiscordUser* user) {
        IDGSActivity::get_singleton()->emit_signal("join_request", dgs_discord_user_to_dict(user));
    };

    static void on_activity_invite(void* data, EDiscordActivityActionType type, DiscordUser* user, DiscordActivity* activity) {
        IDGSActivity::get_singleton()->emit_signal("invite", static_cast<int>(type), dgs_discord_user_to_dict(user), dgs_discord_activity_to_dict(activity));
    };

    IDGSActivity();
    ~IDGSActivity();

    static IDiscordActivityEvents _events;

   protected:
    IDiscordCore* _core = nullptr;
    static void _bind_methods();
};

}  // namespace godot
