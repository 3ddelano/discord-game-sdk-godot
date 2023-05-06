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
    int send_request_reply(int64_t user_id, int reply);
    int send_invite(int64_t user_id, int type, const String& content);
    int accept_invite(int64_t user_id);

    IDGSActivity();
    ~IDGSActivity();

   protected:
    IDiscordCore* _core = nullptr;
    static void _bind_methods();
};

}  // namespace godot
