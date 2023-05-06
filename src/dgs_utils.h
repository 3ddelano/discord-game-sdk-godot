#pragma once
#include "godot_cpp/core/class_db.hpp"
#include "godot_cpp/variant/string.hpp"

#define VARIANT_TO_CHARSTRING(str) ((godot::String)str).utf8()
#define EOSG_GET_STRING(str) ((str == nullptr) ? "" : godot::String(str))

#define DGS_TYPE_DiscordResult int
#define DGS_TYPE_DiscordClientId int64_t
#define DGS_TYPE_DiscordVersion int32_t
#define DGS_TYPE_DiscordSnowflake int64_t
#define DGS_TYPE_DiscordTimestamp int64_t
#define DGS_TYPE_DiscordUserId int64_t
#define DGS_TYPE_DiscordLocale godot::String
#define DGS_TYPE_DiscordBranch godot::String
#define DGS_TYPE_DiscordLobbyId int64_t
#define DGS_TYPE_DiscordLobbySecret godot::String
#define DGS_TYPE_DiscordMetadataKey godot::String
#define DGS_TYPE_DiscordMetadataValue godot::String
#define DGS_TYPE_DiscordNetworkPeerId uint64_t
#define DGS_TYPE_DiscordNetworkChannelId uint8_t
#define DGS_TYPE_DiscordPath godot::String
#define DGS_TYPE_DiscordDateTime godot::String

#define DGS_BIND_METHOD(m_class, m_name) ClassDB::bind_method(D_METHOD(#m_name), &m_class::m_name)
