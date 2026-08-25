#pragma once

#include "godot_cpp/variant/utility_functions.hpp"

namespace godot::dgs {

#define DGS_PRINT_ERR(msg) UtilityFunctions::printerr("DGS:: " + String(msg));

} // namespace godot::dgs