// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "apps/maxwell/services/context/context_engine.fidl.h"
#include "apps/maxwell/src/integration/test.h"

// Base fixture to support test cases requiring Context Engine.
class ContextEngineTestBase : public MaxwellTestBase {
 public:
  ContextEngineTestBase()
      : context_engine_(ConnectToService<maxwell::context::ContextEngine>(
            "file:///system/apps/context_engine")) {}

 protected:
  void StartContextAgent(const std::string& url) {
    auto agent_host = std::make_unique<maxwell::AgentEnvironmentHost>();
    agent_host->AddService<maxwell::context::ContextAgentClient>([this, url](
        fidl::InterfaceRequest<maxwell::context::ContextAgentClient> request) {
      context_engine_->RegisterContextAgent(url, std::move(request));
    });
    StartAgent(url, std::move(agent_host));
  }

  const maxwell::context::ContextEnginePtr context_engine_;
};
