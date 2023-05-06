#pragma once
#include "discord_game_sdk.h"
#include "godot_cpp/core/class_db.hpp"
#include "godot_cpp/variant/dictionary.hpp"
#include "godot_cpp/variant/string.hpp"

using namespace godot;

#define VARIANT_TO_CHARSTRING(str) ((String)str).utf8()

#define DGS_BIND_METHOD(m_class, m_name) ClassDB::bind_method(D_METHOD(#m_name), &m_class::m_name)

static Dictionary dgs_discord_user_to_dict(DiscordUser* user) {
    Dictionary ret;
    ret["id"] = user->id;
    ret["username"] = String(user->username);
    ret["discriminator"] = user->discriminator;
    ret["avatar"] = String(user->avatar);
    ret["bot"] = user->bot ? true : false;
    return ret;
}

static Dictionary dgs_discord_activity_to_dict(DiscordActivity* activity) {
    Dictionary ret;
    ret["type"] = static_cast<int>(activity->type);
    ret["application_id"] = activity->application_id;
    ret["name"] = String(activity->name);
    ret["state"] = String(activity->state);
    ret["details"] = String(activity->details);
    ret["timestamp_start"] = activity->timestamps.start;
    ret["timestamp_end"] = activity->timestamps.end;
    ret["asset_large_image"] = String(activity->assets.large_image);
    ret["asset_large_text"] = String(activity->assets.large_text);
    ret["asset_small_image"] = String(activity->assets.small_image);
    ret["asset_small_text"] = String(activity->assets.small_text);
    ret["party_id"] = String(activity->party.id);
    ret["party_size_current"] = activity->party.size.current_size;
    ret["party_size_max"] = activity->party.size.max_size;
    ret["party_privacy"] = static_cast<int>(activity->party.privacy);
    ret["secrets_match"] = String(activity->secrets.match);
    ret["secrets_join"] = String(activity->secrets.join);
    ret["secrets_spectate"] = String(activity->secrets.spectate);
    ret["instance"] = activity->instance ? true : false;
    return ret;
}