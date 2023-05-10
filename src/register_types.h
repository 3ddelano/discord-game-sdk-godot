#pragma once

void initialize_dgs_module();
void uninitialize_dgs_module();

#define DGS_REGISTER_SINGLETON(_var, _class) \
    ClassDB::register_class<_class>();       \
    _var = memnew(_class);                   \
    Engine::get_singleton()                  \
        ->register_singleton(#_class, _class::get_singleton());

#define DGS_DEREGISTER_SINGLETON(_var, _class)              \
    Engine::get_singleton()->unregister_singleton(#_class); \
    memdelete(_var);