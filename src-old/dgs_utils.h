#pragma once
#include "discord_game_sdk.h"
#include "godot_cpp/classes/resource_loader.hpp"
#include "godot_cpp/classes/script.hpp"
#include "godot_cpp/core/class_db.hpp"
#include "godot_cpp/variant/dictionary.hpp"
#include "godot_cpp/variant/string.hpp"

using namespace godot;

#define VARIANT_TO_CHARSTRING(str) ((String)str).utf8()

#define DGS_BIND_METHOD(m_class, m_name) ClassDB::bind_method(D_METHOD(#m_name), &m_class::m_name)

static Variant dgs_discord_log_message_to_obj(EDiscordLogLevel level, const char* msg) {
    if (msg == nullptr) {
        return Variant();
    }
    Dictionary ret;
    ret["level"] = static_cast<int>(level);
    ret["msg"] = String(msg);

    Ref<Script> log_data_script = ResourceLoader::get_singleton()->load("res://addons/discord-game-sdk-godot/data/DiscordLogData.gd");
    Ref<RefCounted> logObj;
    logObj.instantiate();
    logObj->set_script(log_data_script);
    logObj->call("from_dict", ret);
    return logObj;
}

static Variant dgs_discord_user_to_obj(DiscordUser* user) {
    if (user == nullptr) {
        return Variant();
    }
    Dictionary ret;
    ret["id"] = user->id;
    ret["username"] = String(user->username);
    ret["discriminator"] = user->discriminator;
    ret["avatar"] = String(user->avatar);
    ret["bot"] = user->bot ? true : false;

    Ref<Script> user_data_script = ResourceLoader::get_singleton()->load("res://addons/discord-game-sdk-godot/data/DiscordUserData.gd");
    Ref<RefCounted> userObj;
    userObj.instantiate();
    userObj->set_script(user_data_script);
    userObj->call("from_dict", ret);
    return userObj;
}

static Variant dgs_discord_activity_to_obj(DiscordActivity* activity) {
    if (activity == nullptr) {
        return Variant();
    }
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

    Ref<Script> activity_data_script = ResourceLoader::get_singleton()->load("res://addons/discord-game-sdk-godot/data/DiscordActivityData.gd");
    Ref<RefCounted> activityObj;
    activityObj.instantiate();
    activityObj->set_script(activity_data_script);
    activityObj->call("from_dict", ret);
    return activityObj;
}

static Variant dgs_discord_presence_to_obj(DiscordPresence* presence) {
    if (presence == nullptr) {
        return Variant();
    }
    Dictionary ret;
    ret["status"] = static_cast<int>(presence->status);
    ret["activity"] = dgs_discord_activity_to_obj(&presence->activity);

    Ref<Script> presence_data_script = ResourceLoader::get_singleton()->load("res://addons/discord-game-sdk-godot/data/DiscordPresenceData.gd");
    Ref<RefCounted> presenceObj;
    presenceObj.instantiate();
    presenceObj->set_script(presence_data_script);
    presenceObj->call("from_dict", ret);
    return presenceObj;
}

static Variant dgs_discord_relationship_to_obj(DiscordRelationship* relationship) {
    if (relationship == nullptr) {
        return Variant();
    }
    Dictionary ret;
    ret["type"] = static_cast<int>(relationship->type);
    ret["user"] = dgs_discord_user_to_obj(&relationship->user);
    ret["presence"] = dgs_discord_presence_to_obj(&relationship->presence);

    Ref<Script> relationship_data_script = ResourceLoader::get_singleton()->load("res://addons/discord-game-sdk-godot/data/DiscordRelationshipData.gd");
    Ref<RefCounted> relationshipObj;
    relationshipObj.instantiate();
    relationshipObj->set_script(relationship_data_script);
    relationshipObj->call("from_dict", ret);
    return relationshipObj;
}