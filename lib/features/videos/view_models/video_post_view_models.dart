import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_like_model.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class VideoPostViewModel extends FamilyAsyncNotifier<VideoLikeModel, String> {
  late final VideosRepository _repository;
  late final String _videoId;
  late final String _userId;
  bool _isLiked = false;
  int _likeCounts = 0;

  @override
  FutureOr<VideoLikeModel> build(String arg) {
    final argStr = arg.split("000");
    _videoId = argStr[0];
    _userId = argStr[1];
    _repository = ref.read(videosRepo);
    return isLikedVideo();
  }

  Future<VideoLikeModel> isLikedVideo() async {
    final likeData = await _repository.isLiked(_videoId, _userId);
    _isLiked = likeData.isLikeVideo;
    _likeCounts = likeData.likeCount;
    return likeData;
  }

  Future<void> likeVideo() async {
    final isLiked = await _repository.likeVideo(_videoId, _userId);
    _isLiked = !isLiked;
    _likeCounts = isLiked ? _likeCounts - 1 : _likeCounts + 1;
    state = AsyncValue.data(
        VideoLikeModel(isLikeVideo: _isLiked, likeCount: _likeCounts));
  }
}

final videoPostProvider =
    AsyncNotifierProvider.family<VideoPostViewModel, VideoLikeModel, String>(
        () => VideoPostViewModel());
