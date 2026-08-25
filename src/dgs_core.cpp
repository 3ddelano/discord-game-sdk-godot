#include "dgs_core.h"

#include "dgs_enums.h"
#include "dgs_util.h"
#include "discord_game_sdk.h"
#include "godot_cpp/classes/canvas_item.hpp"
#include "godot_cpp/classes/engine.hpp"
#include "godot_cpp/core/class_db.hpp"

using namespace godot::dgs;

void DGSCore::_bind_methods() {
    ClassDB::bind_method(D_METHOD("create_core", "client_id", "flags"), &DGSCore::create_core);
    ADD_SIGNAL(MethodInfo("msg_logged", PropertyInfo(Variant::STRING, "level"), PropertyInfo(Variant::STRING, "msg")));

    DGS_BIND_RESULT_ENUM();
}

DGSCore::Result DGSCore::create_core(const uint64_t p_client_id, const uint64_t p_flags) {
    if (!is_inside_tree()) {
        DGS_PRINT_ERR("create_core: Not inside tree. Use add_child(core) to add it to the scene.");
        return INTERNAL_ERROR;
    }

    if (internal_) {
        DGS_PRINT_ERR("create_core: Core is already created.");
        return CONFLICT;
    }

    DiscordCreateParams params{};
    DiscordCreateParamsSetDefault(&params);
    params.client_id = p_client_id;
    params.flags = p_flags;
    params.event_data = this;

    const EDiscordResult res = DiscordCreate(DISCORD_VERSION, &params, &internal_);

    if (!internal_) {
        DGS_PRINT_ERR("create_core: Failed to create core.");
        return INTERNAL_ERROR;
    }

    if (internal_) {
        static auto wrapper = [](void *callbackData, EDiscordLogLevel level, char const *message) -> void {
            auto core = static_cast<DGSCore *>(callbackData);

            String level_str = "DEBUG";
            if (level == DiscordLogLevel_Info) {
                level_str = "INFO";
            } else if (level == DiscordLogLevel_Warn) {
                level_str = "WARN";
            } else if (level == DiscordLogLevel_Error) {
                level_str = "ERROR";
            }

            core->emit_signal("msg_logged", level_str, String(static_cast<const char *>(message)));
        };
        internal_->set_log_hook(internal_, DiscordLogLevel_Debug, this, wrapper);
    }

    return static_cast<Result>(res);
}

DGSCore::DGSCore() {}

DGSCore::~DGSCore() {
    if (internal_) {
        internal_->destroy(internal_);
        internal_ = nullptr;
    }
}

void DGSCore::_process(double delta) {
    if (internal_) {
        internal_->run_callbacks(internal_);
    }
}
