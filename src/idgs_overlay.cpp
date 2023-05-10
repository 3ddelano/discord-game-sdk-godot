#include "idgs_overlay.h"

using namespace godot;

#define DGS_OVERLAY_BIND_METHOD(meth) ClassDB::bind_method(D_METHOD(#meth), &IDGSOverlay::meth)

void IDGSOverlay::_bind_methods() {
    DGS_OVERLAY_BIND_METHOD(is_enabled);
    DGS_OVERLAY_BIND_METHOD(is_locked);
    DGS_OVERLAY_BIND_METHOD(set_locked);
    DGS_OVERLAY_BIND_METHOD(open_activity_invite);
    DGS_OVERLAY_BIND_METHOD(open_guild_invite);
    DGS_OVERLAY_BIND_METHOD(open_voice_settings);

    ADD_SIGNAL(MethodInfo("set_locked_cb", PropertyInfo(Variant::BOOL, "result")));
    ADD_SIGNAL(MethodInfo("open_activity_invite_cb", PropertyInfo(Variant::BOOL, "result")));
    ADD_SIGNAL(MethodInfo("open_guild_invite_cb", PropertyInfo(Variant::BOOL, "result")));
    ADD_SIGNAL(MethodInfo("open_voice_settings_cb", PropertyInfo(Variant::BOOL, "result")));

    ADD_SIGNAL(MethodInfo("toggle", PropertyInfo(Variant::BOOL, "locked")));
}

bool IDGSOverlay::is_enabled() {
    IDiscordOverlayManager* overlayManager = IDGSCore::get_overlay_manager();
    ERR_FAIL_COND_V(overlayManager == nullptr, false);
    bool enabled = false;
    overlayManager->is_enabled(overlayManager, &enabled);
    return enabled;
}

bool IDGSOverlay::is_locked() {
    IDiscordOverlayManager* overlayManager = IDGSCore::get_overlay_manager();
    ERR_FAIL_COND_V(overlayManager == nullptr, false);
    bool locked = false;
    overlayManager->is_locked(overlayManager, &locked);
    return locked;
}

void IDGSOverlay::set_locked(bool p_locked) {
    IDiscordOverlayManager* overlayManager = IDGSCore::get_overlay_manager();
    ERR_FAIL_COND(overlayManager == nullptr);
    overlayManager->set_locked(overlayManager, p_locked, nullptr, [](void* data, EDiscordResult result) {
        IDGSOverlay::get_singleton()->emit_signal("set_locked_cb", static_cast<int>(result));
    });
}

void IDGSOverlay::open_activity_invite(int p_type) {
    IDiscordOverlayManager* overlayManager = IDGSCore::get_overlay_manager();
    ERR_FAIL_COND(overlayManager == nullptr);
    overlayManager->open_activity_invite(overlayManager, static_cast<EDiscordActivityActionType>(p_type), nullptr, [](void* data, EDiscordResult result) {
        IDGSOverlay::get_singleton()->emit_signal("open_activity_invite_cb", static_cast<int>(result));
    });
}

void IDGSOverlay::open_guild_invite(const String& p_code) {
    IDiscordOverlayManager* overlayManager = IDGSCore::get_overlay_manager();
    ERR_FAIL_COND(overlayManager == nullptr);
    overlayManager->open_guild_invite(overlayManager, p_code.utf8().get_data(), nullptr, [](void* data, EDiscordResult result) {
        IDGSOverlay::get_singleton()->emit_signal("open_guild_invite_cb", static_cast<int>(result));
    });
}

void IDGSOverlay::open_voice_settings() {
    IDiscordOverlayManager* overlayManager = IDGSCore::get_overlay_manager();
    ERR_FAIL_COND(overlayManager == nullptr);
    overlayManager->open_voice_settings(overlayManager, nullptr, [](void* data, EDiscordResult result) {
        IDGSOverlay::get_singleton()->emit_signal("open_voice_settings_cb", static_cast<int>(result));
    });
}

IDGSOverlay* IDGSOverlay::singleton = nullptr;
IDGSOverlay* IDGSOverlay::get_singleton() { return singleton; }

IDGSOverlay::IDGSOverlay() {
    // Initialize any variables here
    ERR_FAIL_COND(singleton != nullptr);
    singleton = this;
}

IDGSOverlay::~IDGSOverlay() {
    // Add your cleanup here
    ERR_FAIL_COND(singleton != this);
    singleton = nullptr;
}

IDiscordOverlayEvents IDGSOverlay::_events{
    &IDGSOverlay::on_toggle,
};