// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'panel.dart';
import 'simulated_fractional.dart';
import 'story_bar.dart';
import 'story_cluster_id.dart';
import 'story_list.dart';
import 'simulated_fractionally_sized_box.dart';

class StoryId extends ValueKey<dynamic> {
  StoryId(dynamic value) : super(value);
}

typedef Widget OpacityBuilder(BuildContext context, double opacity);

/// The representation of a Story.  A Story's contents are display as a [Widget]
/// provided by [builder] while the size of a story in the [StoryList] is
/// determined by [lastInteraction] and [cumulativeInteractionDuration].
class Story {
  final StoryId id;
  final WidgetBuilder builder;
  final List<OpacityBuilder> icons;
  final OpacityBuilder avatar;
  final String title;
  final Color themeColor;
  final StoryClusterId clusterId;
  final GlobalKey<StoryBarState> storyBarKey;
  final GlobalKey storyBarPaddingKey;
  final GlobalKey clusterDraggableKey;
  final GlobalKey<SimulatedFractionalState> shadowPositionedKey;
  final GlobalKey containerKey;
  final GlobalKey<SimulatedFractionallySizedBoxState> tabSizerKey;

  DateTime lastInteraction;
  Duration cumulativeInteractionDuration;
  bool inactive;
  GlobalKey<SimulatedFractionalState> positionedKey;
  Panel panel;

  Story({
    this.id,
    this.builder,
    this.title: '',
    this.icons: const <OpacityBuilder>[],
    this.avatar,
    this.lastInteraction,
    this.cumulativeInteractionDuration,
    this.themeColor,
    this.inactive: false,
  })
      : this.clusterId = new StoryClusterId(),
        this.storyBarKey = new GlobalKey<StoryBarState>(),
        this.storyBarPaddingKey = new GlobalKey(),
        this.clusterDraggableKey = new GlobalKey(),
        this.positionedKey = new GlobalKey(),
        this.shadowPositionedKey = new GlobalKey(),
        this.containerKey = new GlobalKey(),
        this.tabSizerKey = new GlobalKey<SimulatedFractionallySizedBoxState>(),
        this.panel = new Panel();

  /// Returns true if the [Story] has no content and should just take up empty
  /// space.
  bool get isPlaceHolder => false;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(dynamic other) => (other is Story && other.id == id);

  @override
  String toString() => 'Story( id: $id, title: $title, panel: $panel )';

  static int storyListHashCode(List<Story> stories) =>
      hashList(stories.map((Story s) => s.id));
}
