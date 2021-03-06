// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef TOPAZ_EXAMPLES_MEDIA_VU_METER_VU_METER_PARAMS_H_
#define TOPAZ_EXAMPLES_MEDIA_VU_METER_VU_METER_PARAMS_H_

#include <string>

#include "lib/fxl/command_line.h"
#include "lib/fxl/macros.h"

namespace examples {

class VuMeterParams {
 public:
  VuMeterParams(const fxl::CommandLine& command_line);

  bool is_valid() const { return is_valid_; }

 private:
  bool is_valid_;

  FXL_DISALLOW_COPY_AND_ASSIGN(VuMeterParams);
};

}  // namespace examples

#endif  // TOPAZ_EXAMPLES_MEDIA_VU_METER_VU_METER_PARAMS_H_
