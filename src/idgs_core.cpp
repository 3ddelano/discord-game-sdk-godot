#include "idgs_core.h"

using namespace godot;

#define DGS_CORE_BIND_METHOD(meth) ClassDB::bind_method(D_METHOD(#meth), &IDGSCore::meth)

void IDGSCore::_bind_methods() {
    DGS_CORE_BIND_METHOD(tick);
    DGS_CORE_BIND_METHOD(create_core);
    DGS_CORE_BIND_METHOD(destroy);
    DGS_CORE_BIND_METHOD(set_log_level);

    ADD_SIGNAL(MethodInfo("discord_log", PropertyInfo(Variant::OBJECT, "log_msg")));
}

int IDGSCore::create_core(int64_t p_client_id, uint64_t p_flags) {
    DiscordCreateParams params{};
    DiscordCreateParamsSetDefault(&params);
    params.client_id = p_client_id;
    params.flags = p_flags;
    params.events = nullptr;
    params.event_data = this;
    params.user_events = &IDGSUser::_events;
    params.activity_events = &IDGSActivity::_events;
    params.relationship_events = &IDGSRelationship::_events;
    params.overlay_events = &IDGSOverlay::_events;

    EDiscordResult res = DiscordCreate(DISCORD_VERSION, &params, &_core);
    if (res != DiscordResult_Ok || !_core) {
        UtilityFunctions::printerr("\nDGS Error: Got Result: ", static_cast<int>(res), "\n\tat: ", __func__, " (", __FILE__, ":", __LINE__, ") ", "\n ");
    } else {
        // Loads the current user
        get_user_manager();

        // Loads the relationships
        get_relationship_manager();
    }

    return static_cast<int>(res);
}

void IDGSCore::destroy() {
    if (_core != nullptr) {
        _core->destroy(_core);
        _core = nullptr;
    }
}

void IDGSCore::set_log_level(int p_level) {
    ERR_FAIL_COND(_core == nullptr);

    _core->set_log_hook(_core, static_cast<EDiscordLogLevel>(p_level), nullptr, [](void* data, EDiscordLogLevel level, const char* msg) {
        IDGSCore::get_singleton()->emit_signal("discord_log", dgs_discord_log_message_to_obj(level, msg));
    });
}

IDGSCore* IDGSCore::singleton = nullptr;
IDGSCore* IDGSCore::get_singleton() { return singleton; }

IDGSCore::IDGSCore() {
    // Initialize any variables here
    ERR_FAIL_COND(singleton != nullptr);
    singleton = this;
}

IDGSCore::~IDGSCore() {
    // Add your cleanup here
    ERR_FAIL_COND(singleton != this);
    destroy();
    singleton = nullptr;
}

void IDGSCore::tick() {
    if (_core != nullptr) {
        _core->run_callbacks(_core);
    }
}