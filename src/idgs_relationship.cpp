#include "idgs_relationship.h"

using namespace godot;

#define DGS_RELATIONSHIP_BIND_METHOD(meth) ClassDB::bind_method(D_METHOD(#meth), &IDGSRelationship::meth)

void IDGSRelationship::_bind_methods() {
    DGS_RELATIONSHIP_BIND_METHOD(filter);
    DGS_RELATIONSHIP_BIND_METHOD(count);
    DGS_RELATIONSHIP_BIND_METHOD(get_user);
    DGS_RELATIONSHIP_BIND_METHOD(get_at);

    ADD_SIGNAL(MethodInfo("refresh"));
    ADD_SIGNAL(MethodInfo("relationship_update", PropertyInfo(Variant::OBJECT, "relationship")));
}

// void IDGSRelationship::filter(Callable p_filter_func) {
void IDGSRelationship::filter() {
    IDiscordRelationshipManager* relationship_manager = IDGSCore::get_relationship_manager();
    ERR_FAIL_COND(relationship_manager == nullptr);

    relationship_manager->filter(
        relationship_manager, nullptr, [](void* data, DiscordRelationship* relationship) -> bool {
            // Hacky fix: We load all the relationships in GDextension and do the filtering in GDScript because I am unable to get Callable to work in GDextension
            return true;
        });
    return;
}

Dictionary IDGSRelationship::count() {
    IDiscordRelationshipManager* relationship_manager = IDGSCore::get_relationship_manager();
    Dictionary ret;
    ret["result"] = DiscordResult_InternalError;
    ret["count"] = 0;
    ERR_FAIL_COND_V(relationship_manager == nullptr, ret);

    int count = 0;
    EDiscordResult res = relationship_manager->count(relationship_manager, &count);
    ret["result"] = static_cast<int>(res);
    ret["count"] = count;
    return ret;
}

Dictionary IDGSRelationship::get_user(int64_t p_user_id) {
    IDiscordRelationshipManager* relationship_manager = IDGSCore::get_relationship_manager();
    Dictionary ret;
    ret["result"] = DiscordResult_InternalError;
    ret["relationship"] = Variant();
    ERR_FAIL_COND_V(relationship_manager == nullptr, ret);

    DiscordRelationship relationship{};
    EDiscordResult res = relationship_manager->get(relationship_manager, p_user_id, &relationship);

    ret["result"] = static_cast<int>(res);
    ret["relationship"] = dgs_discord_relationship_to_obj(&relationship);
    return ret;
}

Dictionary IDGSRelationship::get_at(int p_index) {
    IDiscordRelationshipManager* relationship_manager = IDGSCore::get_relationship_manager();
    Dictionary ret;
    ret["result"] = DiscordResult_InternalError;
    ret["relationship"] = Variant();
    ERR_FAIL_COND_V(relationship_manager == nullptr, ret);

    DiscordRelationship relationship{};
    EDiscordResult res = relationship_manager->get_at(relationship_manager, p_index, &relationship);
    ret["result"] = static_cast<int>(res);
    ret["relationship"] = dgs_discord_relationship_to_obj(&relationship);
    return ret;
}

IDGSRelationship* IDGSRelationship::singleton = nullptr;
IDGSRelationship* IDGSRelationship::get_singleton() { return singleton; }

IDGSRelationship::IDGSRelationship() {
    // Initialize any variables here
    ERR_FAIL_COND(singleton != nullptr);
    singleton = this;
}

IDGSRelationship::~IDGSRelationship() {
    // Add your cleanup here
    ERR_FAIL_COND(singleton != this);
    singleton = nullptr;
}

IDiscordRelationshipEvents IDGSRelationship::_events{
    &IDGSRelationship::on_refresh,
    &IDGSRelationship::on_relationship_update,
};