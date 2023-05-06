#include "idgs_activity.h"

using namespace godot;

#define DGS_CORE_BIND_METHOD(meth) ClassDB::bind_method(D_METHOD(#meth), &IDGSActivity::meth)

void IDGSActivity::_bind_methods() {
    DGS_CORE_BIND_METHOD(register_command);
    DGS_CORE_BIND_METHOD(register_steam);
    DGS_CORE_BIND_METHOD(update_activity);
    DGS_CORE_BIND_METHOD(clear_activity);
    DGS_CORE_BIND_METHOD(send_request_reply);
    DGS_CORE_BIND_METHOD(send_invite);
    DGS_CORE_BIND_METHOD(accept_invite);

    ADD_SIGNAL(MethodInfo("activity_update", PropertyInfo(Variant::INT, "result")));
    ADD_SIGNAL(MethodInfo("activity_clear", PropertyInfo(Variant::INT, "result")));
    ADD_SIGNAL(MethodInfo("activity_join", PropertyInfo(Variant::STRING, "join_secret")));
    ADD_SIGNAL(MethodInfo("activity_join_spectate", PropertyInfo(Variant::STRING, "spectate_secret")));
    ADD_SIGNAL(MethodInfo("activity_join_request", PropertyInfo(Variant::DICTIONARY, "user")));
    ADD_SIGNAL(MethodInfo("activity_invite", PropertyInfo(Variant::DICTIONARY, "data")));
}

int IDGSActivity::register_command(const String& p_command) {
    IDiscordActivityManager* activity_manager = IDGSCore::get_activity_manager();
    ERR_FAIL_COND_V(activity_manager == nullptr, -1);

    CharString command = p_command.utf8();
    EDiscordResult res = activity_manager->register_command(activity_manager, command.get_data());
    return static_cast<int>(res);
}

int IDGSActivity::register_steam(int p_steam_id) {
    IDiscordActivityManager* activity_manager = IDGSCore::get_activity_manager();
    ERR_FAIL_COND_V(activity_manager == nullptr, -1);

    EDiscordResult res = activity_manager->register_steam(activity_manager, static_cast<uint32_t>(p_steam_id));
    return static_cast<int>(res);
}

void IDGSActivity::update_activity(Ref<RefCounted> p_activity) {
    IDiscordActivityManager* activity_manager = IDGSCore::get_activity_manager();
    ERR_FAIL_COND(activity_manager == nullptr);

    EDiscordActivityType type = static_cast<EDiscordActivityType>((int)p_activity->get("type"));
    int application_id = p_activity->get("application_id");
    String p_name = p_activity->get("name");
    String p_state = p_activity->get("state");
    String p_details = p_activity->get("details");
    int64_t timestamp_start = static_cast<int64_t>(p_activity->get("timestamp_start"));
    int64_t timestamp_end = static_cast<int64_t>(p_activity->get("timestamp_end"));
    String p_asset_large_image = p_activity->get("asset_large_image");
    String p_asset_large_text = p_activity->get("asset_large_text");
    String p_asset_small_image = p_activity->get("asset_small_image");
    String p_asset_small_text = p_activity->get("asset_small_text");
    String p_party_id = p_activity->get("party_id");
    int party_size_current = p_activity->get("party_size_current");
    int party_size_max = p_activity->get("party_size_max");
    EDiscordActivityPartyPrivacy party_privacy = static_cast<EDiscordActivityPartyPrivacy>((int)p_activity->get("party_privacy"));
    String p_secrets_match = p_activity->get("secrets_match");
    String p_secrets_join = p_activity->get("secrets_join");
    String p_secrets_spectate = p_activity->get("secrets_spectate");
    bool instance = p_activity->get("instance");

    CharString name = p_name.utf8();
    CharString state = p_state.utf8();
    CharString details = p_details.utf8();
    CharString asset_large_image = p_asset_large_image.utf8();
    CharString asset_large_text = p_asset_large_text.utf8();
    CharString asset_small_image = p_asset_small_image.utf8();
    CharString asset_small_text = p_asset_small_text.utf8();
    CharString party_id = p_party_id.utf8();
    CharString secrets_match = p_secrets_match.utf8();
    CharString secrets_join = p_secrets_join.utf8();
    CharString secrets_spectate = p_secrets_spectate.utf8();

    DiscordActivity activity{};
    activity.type = type;
    if (application_id != 0) {
        activity.application_id = static_cast<uint64_t>(application_id);
    }
    strncpy(activity.name, name.get_data(), 128);
    activity.name[128 - 1] = '\0';

    if (!p_state.is_empty()) {
        strncpy(activity.state, state.get_data(), 128);
        activity.state[128 - 1] = '\0';
    }
    if (!p_details.is_empty()) {
        strncpy(activity.details, details.get_data(), 128);
        activity.details[128 - 1] = '\0';
    }
    if (timestamp_start != 0) {
        activity.timestamps.start = timestamp_start;
    }
    if (timestamp_end != 0) {
        activity.timestamps.end = timestamp_end;
    }
    if (!p_asset_large_image.is_empty()) {
        strncpy(activity.assets.large_image, asset_large_image.get_data(), 128);
        activity.assets.large_image[128 - 1] = '\0';
    }
    if (!p_asset_large_text.is_empty()) {
        strncpy(activity.assets.large_text, asset_large_text.get_data(), 128);
        activity.assets.large_text[128 - 1] = '\0';
    }
    if (!p_asset_small_image.is_empty()) {
        strncpy(activity.assets.small_image, asset_small_image.get_data(), 128);
        activity.assets.small_image[128 - 1] = '\0';
    }
    if (!p_asset_small_text.is_empty()) {
        strncpy(activity.assets.small_text, asset_small_text.get_data(), 128);
        activity.assets.small_text[128 - 1] = '\0';
    }
    if (!p_party_id.is_empty()) {
        strncpy(activity.party.id, party_id.get_data(), 128);
        activity.party.id[128 - 1] = '\0';
    }
    activity.party.size.current_size = party_size_current;
    if (party_size_max != 0) {
        activity.party.size.max_size = party_size_max;
    }
    activity.party.privacy = party_privacy;
    if (!p_secrets_match.is_empty()) {
        strncpy(activity.secrets.match, secrets_match.get_data(), 128);
        activity.secrets.match[128 - 1] = '\0';
    }
    if (!p_secrets_join.is_empty()) {
        strncpy(activity.secrets.join, secrets_join.get_data(), 128);
        activity.secrets.join[128 - 1] = '\0';
    }
    if (!p_secrets_spectate.is_empty()) {
        strncpy(activity.secrets.spectate, secrets_spectate.get_data(), 128);
        activity.secrets.spectate[128 - 1] = '\0';
    }
    activity.instance = instance;

    activity_manager->update_activity(activity_manager, &activity, nullptr, [](void* data, EDiscordResult result) {
        IDGSActivity::get_singleton()->emit_signal("activity_update", static_cast<int>(result));
    });

    return;
}

void IDGSActivity::clear_activity() {
    IDiscordActivityManager* activity_manager = IDGSCore::get_activity_manager();
    ERR_FAIL_COND(activity_manager == nullptr);

    activity_manager->clear_activity(activity_manager, nullptr, [](void* data, EDiscordResult result) {
        IDGSActivity::get_singleton()->emit_signal("activity_clear", static_cast<int>(result));
    });
}
int IDGSActivity::send_request_reply(int64_t user_id, int reply) {
    return -1;
}
int IDGSActivity::send_invite(int64_t user_id, int type, const String& content) {
    return -1;
}
int IDGSActivity::accept_invite(int64_t user_id) {
    return -1;
}

IDGSActivity* IDGSActivity::singleton = nullptr;
IDGSActivity* IDGSActivity::get_singleton() { return singleton; }

IDGSActivity::IDGSActivity() {
    // Initialize any variables here
    ERR_FAIL_COND(singleton != nullptr);
    singleton = this;
}

IDGSActivity::~IDGSActivity() {
    // Add your cleanup here
    ERR_FAIL_COND(singleton != this);
    singleton = nullptr;
}
