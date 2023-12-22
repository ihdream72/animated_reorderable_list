import 'package:flutter/widgets.dart';
import 'package:motion_list/src/model/motion_data.dart';

import '../builder/motion_animation_builder.dart';
import '../builder/motion_builder.dart';

const Duration _kDragDuration = Duration(milliseconds: 1000);
const Duration _kEntryDuration = Duration(milliseconds: 1000);
const Duration _kExitDuration = Duration(milliseconds: 1000);

class MotionAnimatedContent extends StatefulWidget {
  final Key key;
  final int index;
  final MotionData motionData;
  final bool enter;
  final bool exit;
  final AnimatedWidgetBuilder insertAnimationBuilder;
  final AnimatedWidgetBuilder removeAnimationBuilder;
  final Widget? child;
  final Function(MotionData)? updateMotionData;

  const MotionAnimatedContent(
      {required this.key,
      required this.index,
      required this.motionData,
      required this.enter,
      required this.exit,
      required this.insertAnimationBuilder,
      required this.removeAnimationBuilder,
      required this.child,
      this.updateMotionData})
      : super(key: key);

  @override
  State<MotionAnimatedContent> createState() => MotionAnimatedContentState();
}

class MotionAnimatedContentState extends State<MotionAnimatedContent>
    with TickerProviderStateMixin {
  late AnimationController _visibilityController;
  late AnimationController _positionController;
  late Animation<Offset> _offsetAnimation;

  late MotionBuilderState _listState;

  int get index => widget.index;

  Offset? get currentAnimatedOffset =>
      _positionController.isAnimating ? _offsetAnimation.value : null;

  @override
  void initState() {
    //  print("initState ${widget.index}");
    _listState = MotionBuilderState.of(context);
    _listState.registerItem(this);
    _visibilityController = AnimationController(
      value: 1.0,
      duration: _kEntryDuration,
      reverseDuration: _kExitDuration,
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          // widget.updateMotionData?.call(widget.motionData);
        }
      });

    _positionController =
        AnimationController(vsync: this, duration: _kDragDuration)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              // widget.updateMotionData?.call(widget.motionData);
            }
          });

    _offsetAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero)
        .animate(_positionController)
      ..addListener(() {
        setState(() {});
      });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.updateMotionData?.call(widget.motionData);
      // _updateAnimationTranslation();
    });

    _visibilityController.value = 0.0;
    // print(" ------ object enter animation----- $index");
    Future.delayed(_kDragDuration, () {
      _visibilityController.forward();
    });

    super.initState();
  }

  @override
  void didUpdateWidget(covariant MotionAnimatedContent oldWidget) {
    final oldMotionData = oldWidget.motionData;
    final newMotionData = widget.motionData;

    if (oldWidget.index != widget.index) {
      _listState.unregisterItem(oldWidget.index, this);
      _listState.registerItem(this);
    }
    //final currentOffset = itemOffset();

    //  print("OLD - ${oldMotionData.enter}   \n   NEW - ${newMotionData.enter}");
    // if (!oldMotionData.enter && newMotionData.enter) {
    //   _visibilityController.reset();
    //   _visibilityController.value = 0.0;
    //   print(" ------ object enter animation----- $index");
    //   Future.delayed(_kDragDuration, () {
    //     _visibilityController.forward();
    //   });
    // } else
    // if (!oldMotionData.exit && newMotionData.exit) {
    //   Future.delayed(_kDragDuration, () {
    //     _visibilityController.reset();
    //     _visibilityController.value = 1.0;
    //     _visibilityController.reverse();
    //   });
    // }

    // if (oldMotionData.target != newMotionData.target &&
    //     newMotionData.target != currentOffset) {
    // final offsetToMove = currentOffset.offset < newMotionData.offset
    //     ? newMotionData.nextItemOffset
    //     : newMotionData.frontItemOffset;

    // final currentOffset = newMotionData.offset;

    //  _updateAnimationTranslation();
    // print("didUpdateWidget for  $index old $oldMotionData new $newMotionData");

    //  if (oldWidget.index != widget.index) {
    //
    //    final target = widget.motionData.current > oldWidget.motionData.current
    //        ? widget.motionData.nextItemOffset
    //        : widget.motionData.frontItemOffset;
    //   // Offset offsetDiff =target -itemOffset();
    //
    //    Offset offsetDiff = target - widget.motionData.current;
    // //   print("offsetDiff $offsetDiff");
    //    if (offsetDiff.dx != 0 || offsetDiff.dy != 0) {
    //      _positionController.reset();
    //
    //      _offsetAnimation = Tween<Offset>(begin: offsetDiff, end: Offset.zero)
    //          .animate(_positionController);
    //      _positionController.forward();
    //      //}
    //    }
    //  }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //widget.updateMotionData?.call(widget.motionData);
      // _updateAnimationTranslation();
      _updateAnimationTranslation();
      // _listState.registerItem(this);
    });

    super.didUpdateWidget(oldWidget);
  }

  void _updateAnimationTranslation() {
    final currentOffset = itemOffset();

    ///Offset offsetDiff = currentOffset - widget.motionData.current;
    Offset offsetDiff = widget.motionData.target - currentOffset;

    if (offsetDiff.dx != 0 || offsetDiff.dy != 0) {
      _positionController.reset();

      _offsetAnimation = Tween<Offset>(begin: offsetDiff, end: Offset.zero)
          .animate(_positionController);
      _positionController.forward();
      //}
    }

    // final originalOffset = widget.reorderableItem!.oldOffset;
    // final updatedOffset = itemOffset();
    // Offset offsetDiff = originalOffset - updatedOffset;
    //
    // if (offsetDiff.dx != 0 || offsetDiff.dy != 0) {
    //   // if (_offsetAnimationController.isAnimating) {
    //   //   final currentAnimationOffset = _animationOffset.value;
    //   //   final newOriginalOffset = currentAnimationOffset - offsetDiff;
    //   //   offsetDiff = offsetDiff + newOriginalOffset;
    //   // }
    //   _offsetAnimationController.reset();
    //
    //   _animationOffset = Tween<Offset>(begin: offsetDiff, end: Offset.zero)
    //       .animate(_offsetAnimationController);
    //   _offsetAnimationController.forward();
    // }
  }

  Offset itemOffset() {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return Offset.zero;
    var currentOffset = box.localToGlobal(Offset.zero);
    var local = box.globalToLocal(Offset.zero);
    print("currentOffset $currentOffset local $local index ${widget.index}");
    return currentOffset;
  }

  @override
  Widget build(BuildContext context) {
    _listState.registerItem(this);
    //  print("index $index, visibility controller ${_visibilityController.value}");
    return Transform.translate(
        offset: _offsetAnimation.value,
        child: widget.motionData.exit
            ? widget.removeAnimationBuilder(context,
                widget.child ?? const SizedBox.shrink(), _visibilityController)
            : widget.insertAnimationBuilder(
                context,
                widget.child ?? const SizedBox.shrink(),
                _visibilityController));

    return DualTransitionBuilder(
      animation: _visibilityController,
      forwardBuilder: (
        BuildContext context,
        Animation<double> animation,
        Widget? child,
      ) {
        return widget.insertAnimationBuilder(
            context, child ?? const SizedBox.shrink(), animation);
      },
      reverseBuilder: (
        BuildContext context,
        Animation<double> animation,
        Widget? child,
      ) {
        return widget.removeAnimationBuilder(
            context, child ?? const SizedBox.shrink(), animation);
      },
      child: Transform(
          transform: Matrix4.translationValues(
              _offsetAnimation.value.dx, _offsetAnimation.value.dy, 0.0),
          child: widget.child),
    );
  }

  @override
  void dispose() {
    _listState.unregisterItem(widget.index, this);
    _visibilityController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _listState.unregisterItem(index, this);
    super.deactivate();
  }
}
