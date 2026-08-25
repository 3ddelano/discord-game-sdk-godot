
#pragma once

namespace godot::dgs {

#define DGS_BIND_RESULT_ENUM()                                                                                         \
    BIND_ENUM_CONSTANT(OK);                                                                                            \
    BIND_ENUM_CONSTANT(SERVICE_UNAVAILABLE);                                                                           \
    BIND_ENUM_CONSTANT(INVALID_VERSION);                                                                               \
    BIND_ENUM_CONSTANT(LOCK_FAILED);                                                                                   \
    BIND_ENUM_CONSTANT(INTERNAL_ERROR);                                                                                \
    BIND_ENUM_CONSTANT(INVALID_PAYLOAD);                                                                               \
    BIND_ENUM_CONSTANT(INVALID_COMMAND);                                                                               \
    BIND_ENUM_CONSTANT(INVALID_PERMISSIONS);                                                                           \
    BIND_ENUM_CONSTANT(NOT_FETCHED);                                                                                   \
    BIND_ENUM_CONSTANT(NOT_FOUND);                                                                                     \
    BIND_ENUM_CONSTANT(CONFLICT);                                                                                      \
    BIND_ENUM_CONSTANT(INVALID_SECRET);                                                                                \
    BIND_ENUM_CONSTANT(INVALID_JOIN_SECRET);                                                                           \
    BIND_ENUM_CONSTANT(NO_ELIGIBLE_ACTIVITY);                                                                          \
    BIND_ENUM_CONSTANT(INVALID_INVITE);                                                                                \
    BIND_ENUM_CONSTANT(NOT_AUTHENTICATED);                                                                             \
    BIND_ENUM_CONSTANT(INVALID_ACCESS_TOKEN);                                                                          \
    BIND_ENUM_CONSTANT(APPLICATION_MISMATCH);                                                                          \
    BIND_ENUM_CONSTANT(INVALID_DATA_URL);                                                                              \
    BIND_ENUM_CONSTANT(INVALID_BASE64);                                                                                \
    BIND_ENUM_CONSTANT(NOT_FILTERED);                                                                                  \
    BIND_ENUM_CONSTANT(LOBBY_FULL);                                                                                    \
    BIND_ENUM_CONSTANT(INVALID_LOBBY_SECRET);                                                                          \
    BIND_ENUM_CONSTANT(INVALID_FILENAME);                                                                              \
    BIND_ENUM_CONSTANT(INVALID_FILE_SIZE);                                                                             \
    BIND_ENUM_CONSTANT(INVALID_ENTITLEMENT);                                                                           \
    BIND_ENUM_CONSTANT(NOT_INSTALLED);                                                                                 \
    BIND_ENUM_CONSTANT(NOT_RUNNING);                                                                                   \
    BIND_ENUM_CONSTANT(INSUFFICIENT_BUFFER);                                                                           \
    BIND_ENUM_CONSTANT(PURCHASE_CANCELED);                                                                             \
    BIND_ENUM_CONSTANT(INVALID_GUILD);                                                                                 \
    BIND_ENUM_CONSTANT(INVALID_EVENT);                                                                                 \
    BIND_ENUM_CONSTANT(INVALID_CHANNEL);                                                                               \
    BIND_ENUM_CONSTANT(INVALID_ORIGIN);                                                                                \
    BIND_ENUM_CONSTANT(RATE_LIMITED);                                                                                  \
    BIND_ENUM_CONSTANT(OAUTH2_ERROR);                                                                                  \
    BIND_ENUM_CONSTANT(SELECT_CHANNEL_TIMEOUT);                                                                        \
    BIND_ENUM_CONSTANT(GET_GUILD_TIMEOUT);                                                                             \
    BIND_ENUM_CONSTANT(SELECT_VOICE_FORCE_REQUIRED);                                                                   \
    BIND_ENUM_CONSTANT(CAPTURE_SHORTCUT_ALREADY_LISTENING);                                                            \
    BIND_ENUM_CONSTANT(UNAUTHORIZED_FOR_ACHIEVEMENT);                                                                  \
    BIND_ENUM_CONSTANT(INVALID_GIFT_CODE);                                                                             \
    BIND_ENUM_CONSTANT(PURCHASE_ERROR);                                                                                \
    BIND_ENUM_CONSTANT(TRANSACTION_ABORTED);                                                                           \
    BIND_ENUM_CONSTANT(DRAWING_INIT_FAILED);

} // namespace godot::dgs