#pragma once

#include "godot_cpp/classes/ref_counted.hpp"

#pragma pack(push, 8)
#include "discord_game_sdk.h"
#pragma pack(pop)

#include "godot_cpp/classes/node.hpp"

#include <cstdint>

namespace godot::dgs {

class DGSCore : public Node {
    GDCLASS(DGSCore, Node);

  public:
    enum Result {
        OK = 0,
        SERVICE_UNAVAILABLE = 1,
        INVALID_VERSION = 2,
        LOCK_FAILED = 3,
        INTERNAL_ERROR = 4,
        INVALID_PAYLOAD = 5,
        INVALID_COMMAND = 6,
        INVALID_PERMISSIONS = 7,
        NOT_FETCHED = 8,
        NOT_FOUND = 9,
        CONFLICT = 10,
        INVALID_SECRET = 11,
        INVALID_JOIN_SECRET = 12,
        NO_ELIGIBLE_ACTIVITY = 13,
        INVALID_INVITE = 14,
        NOT_AUTHENTICATED = 15,
        INVALID_ACCESS_TOKEN = 16,
        APPLICATION_MISMATCH = 17,
        INVALID_DATA_URL = 18,
        INVALID_BASE64 = 19,
        NOT_FILTERED = 20,
        LOBBY_FULL = 21,
        INVALID_LOBBY_SECRET = 22,
        INVALID_FILENAME = 23,
        INVALID_FILE_SIZE = 24,
        INVALID_ENTITLEMENT = 25,
        NOT_INSTALLED = 26,
        NOT_RUNNING = 27,
        INSUFFICIENT_BUFFER = 28,
        PURCHASE_CANCELED = 29,
        INVALID_GUILD = 30,
        INVALID_EVENT = 31,
        INVALID_CHANNEL = 32,
        INVALID_ORIGIN = 33,
        RATE_LIMITED = 34,
        OAUTH2_ERROR = 35,
        SELECT_CHANNEL_TIMEOUT = 36,
        GET_GUILD_TIMEOUT = 37,
        SELECT_VOICE_FORCE_REQUIRED = 38,
        CAPTURE_SHORTCUT_ALREADY_LISTENING = 39,
        UNAUTHORIZED_FOR_ACHIEVEMENT = 40,
        INVALID_GIFT_CODE = 41,
        PURCHASE_ERROR = 42,
        TRANSACTION_ABORTED = 43,
        DRAWING_INIT_FAILED = 44
    };

  protected:
    static void _bind_methods();

  public:
    Result create_core(uint64_t p_client_id, uint64_t p_flags);
    DGSCore();
    ~DGSCore() override;
    void _process(double delta) override;

  private:
    IDiscordCore *internal_ = nullptr;

    // void _log_hook(void* hook_data, EDiscordLogLevel level, const char *msg);
};
} // namespace godot::dgs

VARIANT_ENUM_CAST(godot::dgs::DGSCore::Result);
