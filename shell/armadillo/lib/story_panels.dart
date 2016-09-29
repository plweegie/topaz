// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import 'story.dart';
import 'story_bar.dart';
import 'story_keys.dart';

/// The height of the vertical gesture detector used to reveal the story bar in
/// full screen mode.
/// TODO(apwilson): Reduce the height of this.  It's large for now for ease of
/// use.
const double _kVerticalGestureDetectorHeight = 32.0;

const double _kStoryBarMinimizedHeight = 12.0;
const double _kStoryBarMaximizedHeight = 48.0;
const double _kUnfocusedStoryMargin = 4.0;
const double _kFocusedStoryMargin = 8.0;

/// Displays up to four stories in a grid-like layout.
class StoryPanels extends StatelessWidget {
  final List<Story> stories;
  final double focusProgress;
  final Size fullSize;
  StoryPanels({
    this.stories,
    this.focusProgress,
    this.fullSize,
  });

  @override
  Widget build(BuildContext context) => new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: new List<Widget>.generate(
          _rowCount,
          (int rowIndex) => new Flexible(
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: new List<Widget>.generate(
                    _columnCount(rowIndex),
                    (int columnIndex) => new Flexible(
                          child: new Padding(
                            padding: new EdgeInsets.only(
                              left: columnIndex == 0
                                  ? 0.0
                                  : lerpDouble(
                                        _kUnfocusedStoryMargin,
                                        _kFocusedStoryMargin,
                                        focusProgress,
                                      ) /
                                      2.0,
                              right: columnIndex == 1 ||
                                      _columnCount(rowIndex) == 1
                                  ? 0.0
                                  : lerpDouble(
                                        _kUnfocusedStoryMargin,
                                        _kFocusedStoryMargin,
                                        focusProgress,
                                      ) /
                                      2.0,
                              top: rowIndex == 0
                                  ? 0.0
                                  : lerpDouble(
                                        _kUnfocusedStoryMargin,
                                        _kFocusedStoryMargin,
                                        focusProgress,
                                      ) /
                                      2.0,
                              bottom: rowIndex == 1 || _rowCount == 1
                                  ? 0.0
                                  : lerpDouble(
                                        _kUnfocusedStoryMargin,
                                        _kFocusedStoryMargin,
                                        focusProgress,
                                      ) /
                                      2.0,
                            ),
                            child: _getStory(
                                context,
                                stories[_storyIndex(rowIndex, columnIndex)],
                                _getSizeFromStoryIndex(
                                  _storyIndex(rowIndex, columnIndex),
                                )),
                          ),
                        ),
                  ),
                ),
              ),
        ),
      );

  int _columnCount(int rowIndex) =>
      math.min(2, (stories.length - rowIndex * 2));
  int get _rowCount => stories.length > 2 ? 2 : 1;
  int _storyIndex(int rowIndex, int columnIndex) => rowIndex * 2 + columnIndex;

  Size _getSizeFromStoryIndex(int storyIndex) {
    if (stories.length == 1) {
      return fullSize;
    }
    if (stories.length == 2) {
      return new Size(
          (fullSize.width - _kFocusedStoryMargin) / 2.0, fullSize.height);
    }
    if (stories.length == 3) {
      if (storyIndex < 2) {
        return new Size(
            (fullSize.width - _kFocusedStoryMargin) / 2.0, fullSize.height);
      }
      return new Size(
          fullSize.width, (fullSize.height - _kFocusedStoryMargin) / 2.0);
    } else {
      return new Size((fullSize.width - _kFocusedStoryMargin) / 2.0,
          (fullSize.height - _kFocusedStoryMargin) / 2.0);
    }
  }

  Widget _getStory(BuildContext context, Story story, Size size) => new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The story bar that pushes down the story.
          new StoryBar(
            key: StoryKeys.storyBarKey(story),
            story: story,
            minimizedHeight: _kStoryBarMinimizedHeight,
            maximizedHeight: _kStoryBarMaximizedHeight,
          ),

          // The story itself.
          new Flexible(
            child: _getStoryContents(context, story, size),
          ),
        ],
      );

  /// The scaled and clipped story.  When full size, the story will
  /// no longer be scaled or clipped.
  Widget _getStoryContents(BuildContext context, Story story, Size size) =>
      new FittedBox(
        fit: ImageFit.cover,
        alignment: FractionalOffset.topCenter,
        child: new SizedBox(
          width: size.width,
          height: size.height - _kStoryBarMaximizedHeight,
          child: story.wideBuilder(context),
        ),
      );
}
