#include "idgs_user.h"

using namespace godot;

#define DGS_USER_BIND_METHOD(meth) ClassDB::bind_method(D_METHOD(#meth), &IDGSUser::meth)

void IDGSUser::_bind_methods() {
    DGS_USER_BIND_METHOD(get_current_user);
    DGS_USER_BIND_METHOD(get_user);
    DGS_USER_BIND_METHOD(get_current_user_premium_type);
    DGS_USER_BIND_METHOD(current_user_has_flag);

    ADD_SIGNAL(MethodInfo("get_user_cb", PropertyInfo(Variant::DICTIONARY, "data")));
    ADD_SIGNAL(MethodInfo("current_user_update"));
}

Dictionary IDGSUser::get_current_user() {
    IDiscordUserManager* userManager = IDGSCore::get_user_manager();
    Dictionary ret;
    ret["result"] = -1;
    ret["user"] = Variant();
    ERR_FAIL_COND_V(userManager == nullptr, ret);

    DiscordUser* current_user = (DiscordUser*)memalloc(sizeof(DiscordUser));
    EDiscordResult res = userManager->get_current_user(userManager, current_user);

    ret["result"] = static_cast<int>(res);
    if (current_user != nullptr) {
        ret["user"] = dgs_discord_user_to_dict(current_user);
    } else {
        ret["user"] = Variant();
    }
    memdelete(current_user);

    return ret;
}

void IDGSUser::get_user(int64_t user_id) {
    IDiscordUserManager* userManager = IDGSCore::get_user_manager();
    ERR_FAIL_COND(userManager == nullptr);

    userManager->get_user(userManager, user_id, nullptr, [](void* data, EDiscordResult result, DiscordUser* user) {
        Dictionary ret;
        ret["result"] = static_cast<int>(result);
        if (user != nullptr) {
            ret["user"] = dgs_discord_user_to_dict(user);
        } else {
            ret["user"] = Variant();
        }

        IDGSUser::get_singleton()->emit_signal("get_user_cb", ret);
    });
}

Dictionary IDGSUser::get_current_user_premium_type() {
    IDiscordUserManager* userManager = IDGSCore::get_user_manager();
    Dictionary ret;
    ret["result"] = -1;
    ret["usr"] = Variant();
    ERR_FAIL_COND_V(userManager == nullptr, ret);

    EDiscordPremiumType* premium_type = (EDiscordPremiumType*)memalloc(sizeof(EDiscordPremiumType));
    EDiscordResult res = userManager->get_current_user_premium_type(userManager, premium_type);

    ret["result"] = static_cast<int>(res);
    if (premium_type != nullptr) {
        ret["premium_type"] = static_cast<int>(*premium_type);
    } else {
        ret["premium_type"] = 0;
    }
    memdelete(premium_type);

    return ret;
}

Dictionary IDGSUser::current_user_has_flag(int flag) {
    IDiscordUserManager* userManager = IDGSCore::get_user_manager();
    Dictionary ret;
    ret["result"] = -1;
    ret["usr"] = Variant();
    ERR_FAIL_COND_V(userManager == nullptr, ret);

    bool* has_flag = (bool*)memalloc(sizeof(bool));
    EDiscordResult res = userManager->current_user_has_flag(userManager, static_cast<EDiscordUserFlag>(flag), has_flag);

    ret["result"] = static_cast<int>(res);
    if (has_flag != nullptr) {
        ret["has_flag"] = *has_flag;
    } else {
        ret["has_flag"] = false;
    }
    memdelete(has_flag);

    return ret;
}

IDGSUser* IDGSUser::singleton = nullptr;
IDGSUser* IDGSUser::get_singleton() { return singleton; }

IDGSUser::IDGSUser() {
    // Initialize any variables here
    ERR_FAIL_COND(singleton != nullptr);
    singleton = this;
}

IDGSUser::~IDGSUser() {
    // Add your cleanup here
    ERR_FAIL_COND(singleton != this);
    singleton = nullptr;
}

IDiscordUserEvents IDGSUser::_events{
    &IDGSUser::on_current_user_update,
};